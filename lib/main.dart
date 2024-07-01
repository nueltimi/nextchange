import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //theme: ThemeData(primarySwatch: const Color.fromARGB(255, 23, 7, 146)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();

    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Another API'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 153, 182, 245),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FixedColumnWidth(100.0),
                1: FixedColumnWidth(200.0),
                // 2: FixedColumnWidth(200.0),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('ID',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Pairs',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    // TableCell(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(8.0),
                    //     child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                    //   ),
                    // ),
                  ],
                ),
                ...users.take(5).map((user) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(user['id'].toString()),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(user['pairs']),
                        ),
                      ),
                      // TableCell(
                      //   child: Padding(
                      //     padding: EdgeInsets.all(8.0),
                      //     child: Text(user['email']),
                      //   ),
                      // ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),

          // ListView.builder(
          //   itemCount: users.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     final user = users[index];
          //     final name = user['pairs'];
          //     final static_closing_rate = user['static_closing_rate'];
          //     final low_limit = user['low_limit'];
          //     //final email = user['email'];
          //     return ListTile(
          //       leading: CircleAvatar(child: Text('${index + 1}')),
          //       title: Text('Name: $name'),
          //       subtitle: Text('Static closing rate: $static_closing_rate'),
          //       trailing: Text('Low limit: $low_limit'),
          //       // subtitle2: Text(high_limit),
          //     );
          //   },
          // ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: fetchUsers,
          // ),
        ),
      ),
    );
  }

  void fetchUsers() async {
    const url = 'https://etrade.nexhange.com/api/fetch_display_prices';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    print('Response body: $body');
    final json = jsonDecode(body);

    setState(() {
      users = json['fx'];
    });
  }

  // void fetchUsers() async {
  //   const url = 'https://randomuser.me/api/?results=100';
  //   const retryCount = 3;

  //   for (int attempt = 0; attempt < retryCount; attempt++) {
  //     try {
  //       var response = await http.get(Uri.parse(url));
  //       print(response.body);
  //       break; // Exit loop if successful
  //     } catch (e) {
  //       print('Error: $e');
  //       if (attempt < retryCount - 1) {
  //         print('Retrying...');
  //         await Future.delayed(
  //             const Duration(seconds: 2)); // Wait before retrying
  //       } else {
  //         print('Failed after $retryCount attempts');
  //       }
  //     }
  //   }
  // }
}
