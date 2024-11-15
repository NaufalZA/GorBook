import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'currency.dart';  // Add this import

class Calculator extends StatefulWidget {
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Matematis',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5669FF), Color(0xFF4054EA)],
                stops: [0.5, 1.0],
              ),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Kalkulator'),
              Tab(text: 'Currency'),
            ],
            labelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
          elevation: 0,
        ),
        body: TabBarView(
          children: [
            CalculatorTab(),
            Currency(),  // Replace LainnyaTab with Currency
          ],
        ),
      ),
    );
  }
}

class CalculatorTab extends StatefulWidget {
  @override
  _CalculatorTabState createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  String _output = "0";

  void _buttonPressed(String text) {
    setState(() {
      if (text == "🧮") {
        return; // Ignore calculator icon button press
      }
      if (text == "AC") {
        _output = "0";
      } else if (text == "=") {
        // Menghitung ekspresi
        try {
          Parser p = Parser();
          Expression exp = p.parse(_output.replaceAll('÷', '/').replaceAll('×', '*')); // Ganti simbol
          ContextModel cm = ContextModel();
          double result = exp.evaluate(EvaluationType.REAL, cm);
          
          // Memeriksa apakah hasil adalah angka bulat
          if (result == result.toInt()) {
            _output = result.toInt().toString();  // Tampilkan tanpa koma
          } else {
            _output = result.toStringAsFixed(2);  // Tampilkan dengan 2 angka di belakang koma
          }
        } catch (e) {
          _output = "Error";
        }
      } else if (text == "%") {
        // Menghitung persen
        try {
          double currentValue = double.parse(_output);
          _output = (currentValue / 100).toString();
        } catch (e) {
          _output = "Error";
        }
      } else if (text == ",") {
        // Menambahkan koma ke angka
        if (!_output.contains(".")) {
          _output += ".";
        }
      } else if (text == "←") {
        // Menghapus karakter terakhir
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
      } else {
        if (_output == "0") {
          _output = text;
        } else {
          _output += text;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              _output,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemCount: 20,
          itemBuilder: (context, index) {
            final buttons = [
              'AC', '←', '%', '÷',
              '7', '8', '9', '×',
              '4', '5', '6', '-',
              '1', '2', '3', '+',
              '🧮', '0', ',', '=' // Kalkulator icon
            ];

            return GestureDetector(
              onTap: () => _buttonPressed(buttons[index]),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: buttons[index] == "←"
                      ? Icon(Icons.backspace, size: 28, color: Colors.black87) // Icon backspace
                      : buttons[index] == "🧮"
                          ? Icon(Icons.calculate, size: 28, color: Colors.black87) // Kalkulator icon
                          : Text(
                              buttons[index],
                              style: TextStyle(fontSize: 24, color: Colors.black87),
                            ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
