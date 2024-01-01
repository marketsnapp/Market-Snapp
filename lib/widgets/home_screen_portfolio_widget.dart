import 'package:flutter/material.dart';
import 'package:marketsnapp/config.dart';
import 'package:marketsnapp/screens/portfolio_screen.dart';

class HomeScreenPortfolioWidget extends StatefulWidget {
  const HomeScreenPortfolioWidget({super.key});

  @override
  _HomeScreenPortfolioWidgetState createState() =>
      _HomeScreenPortfolioWidgetState();
}

class _HomeScreenPortfolioWidgetState extends State<HomeScreenPortfolioWidget> {
  late Future<List<dynamic>> portfolioFuture;

  @override
  void initState() {
    super.initState();
    portfolioFuture = getPortfolio();
  }

  Future<List<dynamic>> getPortfolio() async {
    return [1];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: portfolioFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: primaryColor);
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: Header3(),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Text(
            'You don’t have a portfolio.',
            style: Header3(),
          );
        } else {
          return Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: snapshot.data!.map((portfolio) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Your portfolio ',
                          style: Header3(),
                        ),
                        const Icon(
                          Icons.arrow_outward_rounded,
                          color: greenColor,
                        ),
                        Text(
                          ' 7% (584\$) ',
                          style: spaceGroteskStyle(
                            16,
                            FontWeight.w700,
                            greenColor,
                          ),
                        ),
                        Text(
                          'today.',
                          style: Header3(),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "home");
                          },
                          child: Row(
                            children: [
                              InkWell(
                                child: Row(
                                  children: [
                                    Text(
                                      ' Details',
                                      style: spaceGroteskStyle(
                                        16,
                                        FontWeight.w400,
                                        primaryColor,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, PortfolioScreen.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
