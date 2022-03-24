import 'package:flutter/material.dart';

import 'data_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List products = ['ESSENCE', 'GASOLINE', 'PETROL', 'LUBRICANT', 'FUEL1'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // welcome
            const SizedBox(height: 120),
            const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text("Welcome!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ))),

            const SizedBox(height: 50),
            const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text("Select a product",
                    style: TextStyle(
                      fontSize: 18,
                    ))),

            // product list
            // const SizedBox(height: 25),

            Container(
              height: 500,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return InkWell(
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
                            products[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(products[index]),
                        duration: const Duration(seconds: 1),
                      ));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataPage(product: products[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
