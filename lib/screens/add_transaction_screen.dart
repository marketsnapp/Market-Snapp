import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/providers/portfolio_provider.dart';
import 'package:marketsnapp/screens/home_screen.dart';
import 'package:marketsnapp/screens/portfolio_screen.dart';
import 'package:marketsnapp/types/cryptocurrency.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTransactionScreen extends StatefulWidget {
  final CryptocurrencyRecord cryptocurrency;
  const AddTransactionScreen({Key? key, required this.cryptocurrency})
      : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String errormessage = "";
  double price = 0.0;
  double amount = 0.0;
  bool transaction_type = true;
  DateTime transaction_date = DateTime.now();
  String transaction_note = '';

  Future<bool> addTransactionRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    const endpoint = "transaction/add";
    const String url = '$serverURL$endpoint';

    final Map<String, dynamic> body = {
      "cryptocurrency_id": widget.cryptocurrency.id,
      "transaction_type": transaction_type,
      "price": price,
      "amount": amount,
      "transaction_date": transaction_date.toString(),
      "transaction_note": transaction_note
    };
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        setState(() {
          errormessage = "Transaction added successfully";
        });
        return true;
      } else {
        setState(() {
          errormessage = "Failed to add transaction";
        });
        return false;
      }
    } catch (e) {
      setState(() {
        errormessage = "Failed to add transaction";
      });
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: whiteColor),
          centerTitle: true,
          backgroundColor: backgroundColor,
          title: Text(
            widget.cryptocurrency.symbol,
            style: Header1(),
          ),
          bottom: TabBar(
            indicatorColor: primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: Header2(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    transaction_type = true;
                  });
                },
                child: const Tab(
                  text: 'Buy',
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    transaction_type = false;
                  });
                },
                child: const Tab(
                  text: 'Sell',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Text("Price", style: Header3()),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the price when you bought',
                      hintStyle: InputPlaceholder(),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      fillColor: Colors.transparent,
                    ),
                    style: Body(),
                    cursorColor: primaryColor,
                    cursorHeight: 20,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        price = double.tryParse(value) ?? 0.0;
                        ;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text("Amount", style: Header3()),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the amount you bought',
                      hintStyle: InputPlaceholder(),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      fillColor: Colors.transparent,
                    ),
                    style: Body(),
                    cursorColor: primaryColor,
                    cursorHeight: 20,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        amount = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: transaction_date,
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null &&
                          pickedDate != transaction_date) {
                        setState(() {
                          transaction_date = pickedDate;
                        });
                      }
                    },
                    tileColor: const Color(0xff0e0f18),
                    subtitle: Text(
                      'Select the transaction date',
                      style: InputPlaceholder(),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction Date',
                          style: Header3(),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                    trailing: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("Transaction Note", style: Header3()),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the transaction note',
                      hintStyle: InputPlaceholder(),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      fillColor: Colors.transparent,
                    ),
                    style: Body(),
                    cursorColor: primaryColor,
                    cursorHeight: 20,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        transaction_note = value;
                      });
                    },
                  ),
                  if (errormessage != "") Text(errormessage, style: DownText())
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Text("Price", style: Header3()),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the price when you sold',
                      hintStyle: InputPlaceholder(),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      fillColor: Colors.transparent,
                    ),
                    style: Body(),
                    cursorColor: primaryColor,
                    cursorHeight: 20,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        price = double.tryParse(value) ?? 0.0;
                        ;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text("Amount", style: Header3()),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the amount you sold',
                      hintStyle: InputPlaceholder(),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      fillColor: Colors.transparent,
                    ),
                    style: Body(),
                    cursorColor: primaryColor,
                    cursorHeight: 20,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        amount = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: transaction_date,
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null &&
                          pickedDate != transaction_date) {
                        setState(() {
                          transaction_date = pickedDate;
                        });
                      }
                    },
                    tileColor: const Color(0xff0e0f18),
                    subtitle: Text(
                      'Select the transaction date',
                      style: InputPlaceholder(),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction Date',
                          style: Header3(),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                    trailing: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("Transaction Note", style: Header3()),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the transaction note',
                      hintStyle: InputPlaceholder(),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: whiteColorOpacity55),
                      ),
                      fillColor: Colors.transparent,
                    ),
                    style: Body(),
                    cursorColor: primaryColor,
                    cursorHeight: 20,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        transaction_note = value;
                      });
                    },
                  ),
                  if (errormessage != "") Text(errormessage, style: DownText())
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          style: ElevatedButton.styleFrom(
            visualDensity: const VisualDensity(),
            backgroundColor: primaryColor,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () async {
            var isTransactionGenerated = await addTransactionRequest();
            if (isTransactionGenerated) {
              await Provider.of<PortfolioProvider>(context, listen: false)
                  .getPortfolio()
                  .then(
                    (value) => Navigator.pushNamedAndRemoveUntil(
                        context, HomeScreen.id, (route) => false),
                  );
            }
          },
          child: Text("Add Transaction", style: Header2()),
        ),
      ),
    );
  }
}
