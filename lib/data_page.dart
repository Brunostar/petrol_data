import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:excel/excel.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key, required this.product}) : super(key: key);
  final String product;

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  String answer = '';
  String temperature = '';
  String density = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
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
              padding:
                  const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
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
                              // autofocus: true,
                              keyboardType: const TextInputType.numberWithOptions(),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (String word) => {
                                temperature += word,
                                getData()
                              },
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
                              // autofocus: true,
                              keyboardType: const TextInputType.numberWithOptions(),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (String word) => {
                                density += word,
                                getData()
                              },

                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getData() async {
    var file = 'assets/PETROL_DATA.xlsx';
    // String v = await DefaultAssetBundle.of(context).loadString(file);
    // var bytes = File(file).readAsBytesSync();
    // var bytes = utf8.encode(v);
    // var excel = Excel.decodeBytes(bytes);
    ByteData data = await rootBundle.load(file);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    int i;
    var sheet = widget.product;
    var temp = temperature;
    var dens = density;

    for (var table in excel.tables.keys) {
      if (table == sheet) {
        var densRow = excel.tables[table]!.rows[0];
        for (i = 0; i < excel.tables[table]!.maxCols; i++) {
          if (densRow[i] == dens) break;
        }
        for (var row in excel.tables[table]!.rows) {
          if (row[0] == temp) {
            setState(() {
              answer = row[i].toString();
            });
          }
          break;
        }
      }
    }
  }
}
