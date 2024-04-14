import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:velocity_x/velocity_x.dart';

import '../helper/firebase_auth.dart';
import 'countDetailsScreen.dart';

class HistoryPage extends StatefulWidget {
  final bool isHome;
  final double appBarSize;
  const HistoryPage({
    Key? key,
    required this.isHome,
    required this.appBarSize,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _futureData;
  final user = FirebaseAuth.instance.currentUser!;

  FireStoreDataBase data = FireStoreDataBase();
  List<dynamic> searchTerms = [];

  Future<void> initializeSearchTerms() async {
    await Future.delayed(const Duration(seconds: 1));
    searchTerms = await data.getData();
  }

  @override
  void initState() {
    super.initState();
    _futureData = _getFromDatabase();
    initializeSearchTerms();
  }

  Future<List<Map<String, dynamic>>> _getFromDatabase() async {
    final db = await _initializeDatabase();
    return db.query('money_counter', orderBy: 'id DESC');
  }

  Future<Database> _initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'money_counter_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE money_counter(id INTEGER PRIMARY KEY AUTOINCREMENT, input1 TEXT, input2 TEXT, input3 TEXT, input4 TEXT, input5 TEXT, input6 TEXT, input7 TEXT, input8 TEXT, input9 TEXT,output1 TEXT,output2 TEXT,output3 TEXT,output4 TEXT,output5 TEXT,output6 TEXT,output7 TEXT,output8 TEXT,output9 TEXT, total_output INTEGER, title TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  void _deleteItem(int id) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(user.uid);
    collectionRef.doc(id.toString()).delete();
  }

  @override
  Widget build(BuildContext context) {
    // print(FireStoreDataBase().getData().then((data) {
    //   print("Luli $data");
    // }, onError: (e) {
    //   print(e);
    // }));
    return SelectionArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            widget.isHome ? widget.appBarSize : 40,
          ),
          child: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  // method to show the search bar
                  showSearch(
                      context: context,
                      // delegate to customize the search bar
                      delegate: CustomSearchDelegate(searchTerms));
                },
                icon: const Icon(Icons.search),
              )
            ],
            title: const Text('History'),
          ),
        ),
        body: FutureBuilder(
          future: FireStoreDataBase().getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No data'),
              );
            }
            final data = snapshot.data!;
            print("Json Data ${FireStoreDataBase().countingList}");
            data.sort((a, b) {
              DateTime dateA = DateTime.parse(a['date']);
              DateTime dateB = DateTime.parse(b['date']);
              return dateB.compareTo(
                  dateA); // To sort in descending order (newest first)
            });
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                return Dismissible(
                  confirmDismiss: (direction) async {
                    deleteDialog(
                      context,
                      TextButton(
                        onPressed: () {
                          _deleteItem(item['id']);
                          setState(() {});
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('DELETE',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    );
                    return null;
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  key: Key(item['id'].toString()),
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Deleted..'),
                      backgroundColor: Colors.red,
                    ));
                  },
                  child: countDetiels(context, item),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget countDetiels(BuildContext _, Map<String, dynamic> item) {
    final originalDateTime = DateTime.parse(item['date']);

    final formattedDate =
        DateFormat('EEE dd/MM/yyyy HH:mm:ss').format(originalDateTime);
    double w = _.screenWidth * .50;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          "${item['title']} $formattedDate "
              .text
              .maxLines(1)
              .maxFontSize(15)
              .xl2
              .uppercase
              .bold
              .make(),
          Table(
            children: [
              TableRow(
                children: [
                  "1000".text.make(),
                  "X".text.make(),
                  item['input1'] == ""
                      ? "0".text.make()
                      : "${item['input1']}".text.make(),
                  " = ".text.make(),
                  "${item['output1']}".text.make(),
                ],
              ),
              TableRow(
                children: [
                  "500".text.make(),
                  "X".text.make(),
                  "${item['input2']}".text.make(),
                  " = ".text.make(),
                  "${item['output2']}".text.make(),
                ],
              ),
              TableRow(
                children: [
                  "200".text.make(),
                  "X".text.make(),
                  "${item['input3']}".text.make(),
                  " = ".text.make(),
                  "${item['output3']}".text.make(),
                ],
              ),
              TableRow(
                children: [
                  "100".text.make(),
                  "X".text.make(),
                  "${item['input4']}".text.make(),
                  " = ".text.make(),
                  "${item['output4']}".text.make(),
                ],
              ),
              TableRow(
                children: [
                  "50".text.make(),
                  "X".text.make(),
                  "${item['input5']}".text.make(),
                  " = ".text.make(),
                  "${item['output5']}".text.make(),
                ],
              ),
              TableRow(
                children: [
                  "20".text.make(),
                  "X".text.make(),
                  "${item['input6']}".text.make(),
                  " = ".text.make(),
                  "${item['output6']}".text.make(),
                ],
              ),
              TableRow(
                children: [
                  "10".text.make(),
                  "X".text.make(),
                  "${item['input7']}".text.make(),
                  " = ".text.make(),
                  "${item['output7']}".text.make(),
                ],
              ),
              TableRow(
                children: [
                  "5".text.make(),
                  "X".text.make(),
                  "${item['input8']}".text.make(),
                  " = ".text.make(),
                  "${item['output8']}".text.make(),
                ],
              ),
              TableRow(
                children: [
                  "2".text.make().hide(isVisible: item['input9'] != ""),
                  "X".text.make().hide(isVisible: item['input9'] != ""),
                  "${item['input9']}"
                      .text
                      .make()
                      .hide(isVisible: item['input9'] != ""),
                  " = ".text.make().hide(isVisible: item['input9'] != ""),
                  "${item['output9']}"
                      .text
                      .make()
                      .hide(isVisible: item['input9'] != ""),
                ],
              ),
              TableRow(
                children: [
                  "--------------".text.make(),
                  "--------------".text.make(),
                  "--------------".text.make(),
                  "--------------".text.make(),
                  "--------------".text.make(),
                ],
              ),
            ],
          ),
          NumberFormat.currency(
                  decimalDigits: 0, customPattern: 'Total: \u09f3 ##,##,###/=')
              .format(item['total_output'])
              .text
              .xl2
              .bold
              .make()
        ],
      ).p12(),
    ).box.width(w).makeCentered().onTap(() {
      Navigator.push(
        _,
        MaterialPageRoute(
          builder: (context) =>
              CountDetailsScreen(item), // Pass data to the new screen
        ),
      );
    });
  }

  Future deleteDialog(BuildContext context, Widget deleteWidget) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GiffyDialog(
          backgroundColor: Colors.grey[300],
          giffy: const Column(children: [
            SizedBox(height: 8),
            Text(
              'Delete',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Are you want to sure delete ?',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // email textfield
          ]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'CANCEL'),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey[700])),
            ),
            deleteWidget,
          ],
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List searchTerms;

  CustomSearchDelegate(this.searchTerms);
  // Demo list to show querying
  // var searchTerms = FireStoreDataBase().countingList;

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    print("result data $searchTerms");
    return [
      IconButton(
        onPressed: () {
          query = '';
          Navigator.pop(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> matchQuery = [];
    for (var item in searchTerms) {
      if (item is Map<String, dynamic>) {
        // Replace 'fieldName' with the actual field name in your map
        dynamic fieldValue = item['fieldName'];
        if (fieldValue != null &&
            fieldValue is String &&
            fieldValue.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(item);
        }
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        dynamic fieldNameValue = result['fieldName']; // Replace 'fieldName'
        return ListTile(
          title: Text(fieldNameValue.toString()), // Convert to string
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CountDetailsScreen(result), // Pass data to the new screen
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> matchQuery = [];
    for (var item in searchTerms) {
      if (item is Map<String, dynamic>) {
        // Replace 'fieldName' with the actual field name in your map
        dynamic fieldValue = item['title'];
        if (fieldValue != null &&
            fieldValue is String &&
            fieldValue.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(item);
        }
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        dynamic fieldNameValue = result['title']; // Replace 'fieldName'
        return ListTile(
          title: Text(fieldNameValue.toString()), // Convert to string
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CountDetailsScreen(result), // Pass data to the new screen
              ),
            );
          },
        );
      },
    );
  }
}
