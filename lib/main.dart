import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Data with Post Functionality',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _data = [];
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.example.com/comments'));

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> postComment(String commentText) async {
    final response = await http.post(
      Uri.parse('https://api.example.com/comments'),
      body: json.encode({'text': commentText}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Comment posted successfully
      _commentController.clear();
      fetchData(); // Refresh data after posting comment
    } else {
      throw Exception('Failed to post comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data with Post Functionality'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Enter your comment...',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String commentText = _commentController.text;
              if (commentText.isNotEmpty) {
                await postComment(commentText);
              }
            },
            child: Text('Post Comment'),
          ),
          Expanded(
            child: _data.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final item = _data[index];
                return ListTile(
                  title: Text(item['text']),
                  // You can customize the ListTile as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
