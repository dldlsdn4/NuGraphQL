import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const productQL = r'''
          query GetContinent{
            continent(code: "AS") {
              countries{
                code
                name
              }
            }
        }''';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GQL App",
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GraphQL Example"),
      ),
      body: Center(
          child: ElevatedButton(
        child: const Text("submit"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubmitGraphQL(),
              ));
        },
      )),
    );
  }
}

class SubmitGraphQL extends StatelessWidget {
  const SubmitGraphQL({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink("https://countries.trevorblades.com/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(link: httpLink, cache: GraphQLCache()));

    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GraphQL Client")),
      body: Query(
        options: QueryOptions(
          document: gql(productQL),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final queryList = result.data?["continent"]["countries"];

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Countries List",
                    style: Theme.of(context).textTheme.headline5),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: queryList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    // print(queryList[index]);
                    return Text(queryList[index]['code'] +
                        "\n" +
                        queryList[index]['name']);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
