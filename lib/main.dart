import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GQL App",
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      appBar: AppBar(title: Text("GraphQL Client")),
      body: Query(
        options: QueryOptions(document: gql(r'''
          query{
              country(code:"KR"){
              name
              code
              phone
              currency
              continent{
                name
                code
              }
              languages{
                name
              }
            }
        }''')),
        builder: (result, {fetchMore, refetch}) {
          if (result.data == null) {
            return Text("No Data Found !");
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return Text(result.data.toString());
            },
            itemCount: result.data?.length,
          );
        },
      ),
    );
  }
}
