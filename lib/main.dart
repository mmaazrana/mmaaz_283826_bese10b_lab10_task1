import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Search> _todos;
  late List<Search> searchString;
  bool isLoading = true;

  Future<List<Search>> fetchData() async {
    const uriString = 'https://codewithandrea.com/search/search.json';
    final response = await http.get(Uri.parse(uriString));
    if (response.statusCode == 200) {
      final jsonData = (jsonDecode(response.body))["results"];
      final results = <Search>[];
      for (int i = 0; i < jsonData.length; i++) {
        results.add(Search.fromJson(jsonData[i]));
      }
      return results;
    } else {
      throw Exception('Failed to reload');
    }
  }

  Future readJsonFile() async {
    try {
      String data =
          await DefaultAssetBundle.of(context).loadString("searchlist.json");
      final jsonData = jsonDecode(data)['results'];
      print(jsonData);
      final results = <Search>[];
      for (int i = 0; i < jsonData.length; i++) {
        results.add(Search.fromJson(jsonData[i]));
      }
      return results;
    } catch (error) {
      throw Exception('Failed to reload: $error');
    }
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    readJsonFile();
    searchString = await readJsonFile();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Response'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: searchString.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    margin: const EdgeInsets.all(4),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Title: ",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              Flexible(
                                child: Text(
                                  searchString[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "url: ",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              Text(searchString[index].url)
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Content Type: ",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              Text(searchString[index].contentType)
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Date: ",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              Text(searchString[index].date)
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Tags: ",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              Text(searchString[index].tags.toString())
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
