// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:money_counter/widgets/numtoword.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

import '../keyboard/pin_keyboard.dart';
import 'historyPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int randomNum = 0;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
  }

  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  final _controller5 = TextEditingController();
  final _controller6 = TextEditingController();
  final _controller7 = TextEditingController();
  final _controller8 = TextEditingController();
  final _controller9 = TextEditingController();
  int _output1 = 0;
  int _output2 = 0;
  int _output3 = 0;
  int _output4 = 0;
  int _output5 = 0;
  int _output6 = 0;
  int _output7 = 0;
  int _output8 = 0;
  int _output9 = 0;
  int _totalOutput = 0;
  String finalDate = '';
  var formatter = NumberFormat('#,##,000', "en_US");
  bool isAdd = false;

  @override
  void initState() {
    super.initState();

    // _currentUser = widget.user;
    _controller1.addListener(_calculateOutput1);
    _controller2.addListener(_calculateOutput2);
    _controller3.addListener(_calculateOutput3);
    _controller4.addListener(_calculateOutput4);
    _controller5.addListener(_calculateOutput5);
    _controller6.addListener(_calculateOutput6);
    _controller7.addListener(_calculateOutput7);
    _controller8.addListener(_calculateOutput8);
    _controller9.addListener(_calculateOutput9);
    //getCurrentDate();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
    _controller8.dispose();
    _controller9.dispose();
    super.dispose();
  }

  getCurrentDate() {
    var date = DateFormat.yMEd().add_jms().format(DateTime.now()).toString();

    var dateParse = DateTime.parse(date);
  }

  void _calculateOutput1() {
    setState(() {
      _output1 = (int.tryParse(_controller1.text) ?? 0) * 1000;
    });
  }

  void _calculateOutput2() {
    setState(() {
      _output2 = (int.tryParse(_controller2.text) ?? 0) * 500;
    });
  }

  void _calculateOutput3() {
    setState(() {
      _output3 = (int.tryParse(_controller3.text) ?? 0) * 200;
    });
  }

  void _calculateOutput4() {
    setState(() {
      _output4 = (int.tryParse(_controller4.text) ?? 0) * 100;
    });
  }

  void _calculateOutput5() {
    setState(() {
      _output5 = (int.tryParse(_controller5.text) ?? 0) * 50;
    });
  }

  void _calculateOutput6() {
    setState(() {
      _output6 = (int.tryParse(_controller6.text) ?? 0) * 20;
    });
  }

  void _calculateOutput7() {
    setState(() {
      _output7 = (int.tryParse(_controller7.text) ?? 0) * 10;
    });
  }

  void _calculateOutput8() {
    setState(() {
      _output8 = (int.tryParse(_controller8.text) ?? 0) * 5;
    });
  }

  void _calculateOutput9() {
    setState(() {
      _output9 = (int.tryParse(_controller9.text) ?? 0) * 2;
    });
  }

  void _calculateTotal() {
    setState(() {
      _totalOutput = _output1 +
          _output2 +
          _output3 +
          _output4 +
          _output5 +
          _output6 +
          _output7 +
          _output8 +
          _output9;
      randomNum = Random().nextInt(1000000000);

      print('Counting $randomNum');
    });
  }

  void _clearAll() {
    setState(() {
      _controller1.clear();
      _controller2.clear();
      _controller3.clear();
      _controller4.clear();
      _controller5.clear();
      _controller6.clear();
      _controller7.clear();
      _controller8.clear();
      _controller9.clear();
      _output1 = 0;
      _output2 = 0;
      _output3 = 0;
      _output4 = 0;
      _output5 = 0;
      _output6 = 0;
      _output7 = 0;
      _output8 = 0;
      _output9 = 0;
      _totalOutput = 0;
      isAdd = false;
    });
  }

  void saveUID(String title) async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Get the count of existing documents
      //String newIndexStr = _counter.toString();

      // Create the "moneycount" collection with the UID as document ID
      await _firestore.collection(user.uid).doc(randomNum.toString()).set({
        // 'data': 'Your data goes here', // Add your data here
        'id': randomNum,
        'input1': _controller1.text,
        'input2': _controller2.text,
        'input3': _controller3.text,
        'input4': _controller4.text,
        'input5': _controller5.text,
        'input6': _controller6.text,
        'input7': _controller7.text,
        'input8': _controller8.text,
        'input9': _controller9.text,
        'output1': _output1,
        'output2': _output2,
        'output3': _output3,
        'output4': _output4,
        'output5': _output5,
        'output6': _output6,
        'output7': _output7,
        'output8': _output8,
        'output9': _output9,
        'total_output': _totalOutput,
        'title': title,
        'date': finalDate,
      });

      print('Moneycount collection created with document ID: ${user.uid}');
      print('Press Save $randomNum');
    } else {
      print('User is not logged in');
    }
  }

  void _saveToDatabase(String title) async {
    final db = await _initializeDatabase();
    await db.insert(
      'money_counter',
      {
        'input1': _controller1.text,
        'input2': _controller2.text,
        'input3': _controller3.text,
        'input4': _controller4.text,
        'input5': _controller5.text,
        'input6': _controller6.text,
        'input7': _controller7.text,
        'input8': _controller8.text,
        'input9': _controller9.text,
        'output1': _output1,
        'output2': _output2,
        'output3': _output3,
        'output4': _output4,
        'output5': _output5,
        'output6': _output6,
        'output7': _output7,
        'output8': _output8,
        'output9': _output9,
        'total_output': _totalOutput,
        'title': title,
        'date': finalDate,
      },
    );
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

  void _showSaveDialog(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save to history'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Enter title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && _totalOutput != 0) {
                  var formattedDate1 = DateFormat.yMEd()
                      .add_jms()
                      .format(DateTime.now())
                      .toString();
                  var formattedDate = DateTime.now().toString();

                  setState(() {
                    finalDate = formattedDate.toString();
                  });
                  _saveToDatabase(titleController.text);

                  saveUID(titleController.text);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Saved to history'),
                  ));
                } else {
                  if (titleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Title is empty'),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You are not count any thing..'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.displayName ?? user.email!),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: _calculateTotal,
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const HistoryPage(
                      isHome: false,
                      appBarSize: 40,
                    );
                  },
                ),
              ),
            ),
            PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 'clear':
                    _clearAll();
                    break;
                  case 'save':
                    _showSaveDialog(context);
                    break;
                  case 'logout':
                    signUserOut();
                    // _logout(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'clear',
                    child: Text('Clear'),
                  ),
                  const PopupMenuItem(
                    value: 'save',
                    child: Text('Save'),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: context.isMobile
            ? partOne(context)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  partOne(context).expand(),
                  VerticalDivider(
                    indent: 20,
                    endIndent: 20,
                    color: Colors.grey[400],
                    thickness: 0.5,
                  ),
                  const HistoryPage(
                    isHome: true,
                    appBarSize: 0,
                  ).expand(),
                ],
              ),
        bottomSheet: PinKeyboard(
          length: 4,
          enableBiometric: true,
          iconBiometricColor: Colors.blue[400],
          onChange: (pin) {
            setState(() {
              pin = _controller1.text;
            });
          },
          onConfirm: (pin) {},
          onBiometric: () {},
        )
            .h(MediaQuery.of(context).size.height / 3)
            .w(MediaQuery.of(context).size.height)
            .hide(),
      ),
    );
  }

  SingleChildScrollView partOne(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _totalOutput == 0
              ? ''.text.make().hide()
              : NumberFormat.currency(
                      decimalDigits: 0,
                      customPattern: 'Total: \u09f3 ##,##,###/=')
                  .format(_totalOutput)
                  .text
                  .xl2
                  .bold
                  .make()
                  .p(10),
          _totalOutput == 0
              ? ''.text.make().hide()
              : "${NumberToWordsEnglish.convert(_totalOutput)} only "
                  .text
                  .maxFontSize(15)
                  .xl2
                  .bold
                  .uppercase
                  .black
                  .headline5(context)
                  .make()
                  .p(10),
          _buildInputField(context, '1000 X', _controller1, _output1),
          _buildInputField(context, '500 X', _controller2, _output2),
          _buildInputField(context, '200 X', _controller3, _output3),
          _buildInputField(context, '100 X', _controller4, _output4),
          _buildInputField(context, '50 X', _controller5, _output5),
          _buildInputField(context, '20 X', _controller6, _output6),
          _buildInputField(context, '10 X', _controller7, _output7),
          IconButton(
            onPressed: () {
              isAdd == false
                  ? setState(() {
                      isAdd = true;
                    })
                  : setState(() {
                      isAdd = false;
                    });
            },
            icon: isAdd == false
                ? const Icon(Icons.add)
                : const Icon(Icons.minimize),
          ),
          isAdd == true
              ? _buildInputField(context, '5 X', _controller8, _output8)
              : _buildInputField(context, '5 X', _controller8, _output8).hide(),
          isAdd == true
              ? _buildInputField(context, '2 X', _controller9, _output9)
              : _buildInputField(context, '2 X', _controller9, _output9).hide(),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8),
            child: ElevatedButton(
              onPressed: _calculateTotal,
              child: const Text('Calculate'),
            ),
          ).hide(),
        ],
      ),
    );
  }

  Widget _buildInputField(
      _, String label, TextEditingController controller, int counter) {
    var w = MediaQuery.of(_).size.width;
    var h = MediaQuery.of(_).size.height;
    return Container(
      child: TextField(
        readOnly: false,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          counter: NumberFormat.currency(
                  decimalDigits: 0, customPattern: '\u09f3 ##,##,###')
              .format(counter)
              .text
              .make(),
          border: const OutlineInputBorder(),
        ),
        onTap: () {
          SizedBox(
            // height: h / 3,
            // width: w,
            child: PinKeyboard(
              // controller: controller,
              length: 4,
              enableBiometric: false,
              iconBiometricColor: Colors.blue[400],
              onChange: (pin) {
                setState(() {
                  pin = controller.text;
                });
              },
              onConfirm: (pin) {},
              onBiometric: () {},
            ),
            // child: NumericKeyboard(
            //   onKeyboardTap: (String text) {
            //     setState(() {
            //       text = controller.text;
            //       print("controller $text ${controller.text.toString()}");
            //     });
            //   },
            // ),
          );
        },
        autofocus: true,
      ).h(h / 10).w(w / 8),
    ).pOnly(left: 10, right: 10, top: 10);
  }
}
