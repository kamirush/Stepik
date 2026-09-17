import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ColorModel(),
      child: const MyApp(),
    ),
  );
}

// Модель состояния
class ColorModel extends ChangeNotifier {
  Color _currentColor = Colors.purple;
  bool _isSwitched = false;

  Color get currentColor => _currentColor;
  bool get isSwitched => _isSwitched;

  void toggleSwitch(bool value) {
    _isSwitched = value;
    _generateRandomColor();
    notifyListeners();
  }

  void _generateRandomColor() {
    final random = Random();
    _currentColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeworkPage(),
    );
  }
}

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем экземпляр модели
    final colorModel = context.watch<ColorModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Homework Provider',
          style: TextStyle(
            color: colorModel.currentColor, // Цвет текста из Provider
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Цветной квадрат
            Container(
              width: 200,
              height: 200,
              color: colorModel.currentColor, // Цвет квадрата из Provider
            ),
            const SizedBox(height: 30),
            // Свитч
            Switch(
              value: colorModel.isSwitched,
              onChanged: (value) {
                context.read<ColorModel>().toggleSwitch(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}