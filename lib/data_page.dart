import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:excel/excel.dart';
import 'package:screen_loader/screen_loader.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key, required this.product}) : super(key: key);
  final String product;

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> with ScreenLoader {
  String answer = '';
  String temperature = '';
  String density = '';
  var tempController = TextEditingController();
  var densController = TextEditingController();
  var excel;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    dataLoadFunction(); // this function gets called
  }

  dataLoadFunction() async {
    setState(() {
      _isLoading = true; // your loader has started to load
    });

    Future.delayed(const Duration(seconds: 3), (){
      setState(() {
        setup();
        _isLoading = false; // your loder will stop to finish after the data fetch
      });});
  }

  Future setup() async {
    if (excel == null) {
      var file = 'assets/PETROL_DATA.xlsx';
      ByteData data = await rootBundle.load(file);
      var bytes =
          data.buffer.asUint8List(0, data.lengthInBytes);
      excel = Excel.decodeBytes(bytes);
    }
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // product title
        const SizedBox(height: 120),
        Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(widget.product,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ))),

        SizedBox(
          height: 110,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 75.22,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    answer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Temperature",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 50,
                      height: 75.22,
                      child: Container(
                        // color: Colors.grey[200],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: TextField(
                            controller: tempController,
                            onTap: () =>
                                {temperature = '', tempController.clear()},
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (String word) => {
                              temperature = word,
                            },
                            onSubmitted: (String word) => getData(),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Density",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 50,
                      height: 75.22,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: TextField(
                            controller: densController,
                            onTap: () => {
                              density = '',
                              densController.clear(),
                            },
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (String word) => {
                              density = word,
                            },
                            onSubmitted: (String word) => getData(),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ],
        ),

        SizedBox(
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 75.22,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                    onPressed: () {
                      getData();
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return loadableWidget(
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: excel == null
              ? _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBody()
              : _buildBody()
          // () async => performFuture(()=>setup());
          ),
    );
  }

  Future getData() async {
    int i;
    var sheet = widget.product;
    var temp = temperature;
    var dens = density;

    for (var table in excel.tables.keys) {
      if (table == sheet) {
        var densRow = excel.tables[table]!.rows[0];
        for (i = 0; i < excel.tables[table]!.maxCols; i++) {
          // print(densRow[i].toString() + "  " + dens);
          if (densRow[i] == double.parse(dens)) {
            // print(densRow[i]);
            for (var row in excel.tables[table]!.rows) {
              if (row[0] == double.parse(temp)) {
                setState(() {
                  answer = row[i].toString();
                  print('answer is: $answer');
                });
                break;
              }
            }
            break;
          }
        }
        if (i >= excel.tables[table]!.maxCols) {
          print("wrong tem or dens value");
          setState(() {
            answer = "";
          });
          _showMyDialog(context);
        }
      }
    }
  }
}

Future<void> _showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No entry for these values'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text("Try again. Note that your temperature has to be within the "
                  "interval: 0.0-50.0 and your density within: 0.73-0.899"),
              // Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
