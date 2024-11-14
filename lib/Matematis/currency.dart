import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Currency extends StatefulWidget {
  @override
  _CurrencyState createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  double _inputValue = 0;
  double _convertedValue = 0;
  String _fromCurrency = 'IDR';
  String _toCurrency = 'USD';

  // Static conversion rates to USD
  final Map<String, double> _ratesInUSD = {
    'USD': 1.0,
    'IDR': 0.000065, // 1 IDR = 0.000065 USD
    'EUR': 1.09,      // 1 EUR = 1.09 USD
  };

  void _convertCurrency() {
    setState(() {
      // Convert to USD first
      double amountInUSD = _inputValue * _ratesInUSD[_fromCurrency]!;
      // Then convert from USD to target currency
      _convertedValue = amountInUSD / _ratesInUSD[_toCurrency]!;
    });
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat("#,##0.00", "id_ID");
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Masukkan jumlah dalam $_fromCurrency"),
            onChanged: (value) {
              setState(() {
                _inputValue = double.tryParse(value) ?? 0;
              });
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: _fromCurrency,
                items: ['IDR', 'USD', 'EUR'].map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _fromCurrency = value!;
                  });
                },
              ),
              DropdownButton<String>(
                value: _toCurrency,
                items: ['IDR', 'USD', 'EUR'].map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _toCurrency = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _convertCurrency,
            child: Text("Konversi"),
          ),
          SizedBox(height: 20),
          Text(
            "Hasil: ${_formatCurrency(_convertedValue)} $_toCurrency",
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
