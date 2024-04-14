import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _getFromDatabase();
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
    final db = await _initializeDatabase();
    await db.delete('money_counter', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _futureData = _getFromDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureData,
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
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final item = data[index];
              return Dismissible(
                key: Key(item['id'].toString()),
                onDismissed: (direction) {
                  _deleteItem(item['id']);
                },
                child: newMethod(context, item),
              );
            },
          );
        },
      ),
    );
  }

  Widget newMethod(BuildContext _, Map<String, dynamic> item) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          "${item['title']} ${item['date']} "
              .text
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
                  "2".text.make(),
                  "X".text.make(),
                  "${item['input9']}".text.make(),
                  " = ".text.make(),
                  "${item['output9']}".text.make(),
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
    );
  }
}
