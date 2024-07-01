import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaginationExample(),
    );
  }
}

class PaginationExample extends StatefulWidget {
  @override
  _PaginationExampleState createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  final int itemsPerPage = 10;
  int currentPage = 0;
  int totalItems = 0;
  List<String> displayedItems = [];
  bool isLoading = false;

  Future<void> fetchItems(int page) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://api.example.com/items?page=$page&limit=$itemsPerPage'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<String> fetchedItems = List<String>.from(data['items']);
      totalItems = data['total'];

      setState(() {
        displayedItems = fetchedItems;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load items');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItems(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalItems / itemsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text('API Pagination'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(displayedItems[index]),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalPages, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage = index;
                          });
                          fetchItems(currentPage);
                        },
                        child: Text('${index + 1}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              currentPage == index ? Colors.blue : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
    );
  }
}
