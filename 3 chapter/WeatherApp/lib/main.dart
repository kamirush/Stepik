import 'package:flutter/material.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        appBar: AppBar(
          title: const Text(
            "Weather Forecast",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 1. Поиск
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 30),

              
                const Text(
                  'Murmansk Oblast, RU',
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Friday, Mar 20, 2020',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 40),

                
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_sunny, size: 80, color: Colors.white),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '14 °F',
                          style: TextStyle(color: Colors.white, fontSize: 60),
                        ),
                        Text(
                          'LIGHT SNOW',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.ac_unit, color: Colors.white),
                        Text('5', style: TextStyle(color: Colors.white, fontSize: 25)),
                        Text('km/hr', style: TextStyle(color: Colors.white70, fontSize: 15)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.ac_unit, color: Colors.white),
                        Text('3', style: TextStyle(color: Colors.white, fontSize: 25)),
                        Text('%', style: TextStyle(color: Colors.white70, fontSize: 20)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.ac_unit, color: Colors.white),
                        Text('20', style: TextStyle(color: Colors.white, fontSize: 25)),
                        Text('%', style: TextStyle(color: Colors.white70, fontSize: 20)),
                      ],
                    ),
                  ],
                ),                              
                const SizedBox(height: 50),

                
                const Text(
                  '7-DAY WEATHER FORECAST',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),

                
                SizedBox(
                  height: 120, 
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        color: Colors.white24,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Friday', style: TextStyle(color: Colors.white, fontSize: 22)),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('6 °F ', style: TextStyle(color: Colors.white, fontSize: 24)),
                                Icon(Icons.wb_sunny, color: Colors.white, size: 30),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        color: Colors.white24,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Saturday', style: TextStyle(color: Colors.white, fontSize: 22)),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('5 °F ', style: TextStyle(color: Colors.white, fontSize: 24)),
                                Icon(Icons.wb_sunny, color: Colors.white, size: 30),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        color: Colors.white24,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sunday', style: TextStyle(color: Colors.white, fontSize: 22)),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('22 °F ', style: TextStyle(color: Colors.white, fontSize: 24)),
                                Icon(Icons.wb_sunny, color: Colors.white, size: 30),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}