// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
//
//
// class HomePage extends StatefulWidget {
//
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
//
//
// class _HomePageState extends State<HomePage> {
//
//
//   String? stringResponse ;
//     Map? mapResponse ;
//   Map?   dataResponse ;
// List listResponse = [];
//
//   @override
//   void initState() {
//     apiCall();
//     super.initState();
//   }
//
//   Future apiCall() async {
//     http.Response response;
//     response =  await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
//
//     if (response.statusCode == 200){
//       setState(() {
//         stringResponse = response.body;
//         mapResponse = json.decode(response.body);
//         listResponse  = mapResponse!['data'];
//       });
//     }
//   }
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Awesome App"),),
//
//       body: Container(
//
//         // child: Text(stringResponse.toString()),
//         child:  dataResponse == null ? Container(child: Text('Hii'),) : Text(listResponse[0]['first_name'].toString()),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Data in ListView',
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

  @override
  void initState() {

    fetchData();

    super.initState();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body)['data'];
        print(_data);
      });
    } else {
      throw Exception('Failed to load data');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data in ListView'),
      ),
      body: _data.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final item = _data[index];
          return ListTile(
            title: Text(item['email']),
            // You can customize the ListTile as needed
          );
        },
      ),
    );
  }
}
