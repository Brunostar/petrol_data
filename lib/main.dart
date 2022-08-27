import 'package:flutter/material.dart';
import 'package:screen_loader/screen_loader.dart';
import 'homepage.dart';

void main() {
  configScreenLoader(
    loader: const AlertDialog(
      title: Text('Gobal Loader..'),
    ),
    bgBlur: 20.0,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
    Future.delayed(const Duration(seconds: 5), (){
    setState(() {
      _isLoading = false; // your loder will stop to finish after the data fetch
    });});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isLoading ?
        const Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            ))
      : const HomePage(),
    );
  }
}