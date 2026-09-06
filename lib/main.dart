import 'package:flutter/material.dart';

void main() => runApp(const MeasuresConverterApp());

class MeasuresConverterApp extends StatelessWidget {
  const MeasuresConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const MeasuresConverterScreen(),
    );
  }
}

class MeasuresConverterScreen extends StatefulWidget {
  const MeasuresConverterScreen({super.key});

  @override
  State<MeasuresConverterScreen> createState() =>
      _MeasuresConverterScreenState();
}

class _MeasuresConverterScreenState extends State<MeasuresConverterScreen> {
  double? _numberFrom;
  String? _startMeasure = 'meters';
  String? _convertedMeasure = 'feet';
  String _resultMessage = '';
  final TextEditingController _controller = TextEditingController(text: '100');

  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds',
    'ounces',
  ];

  final Map<String, String> _measureTypes = {
    'meters': 'distance',
    'kilometers': 'distance',
    'feet': 'distance',
    'miles': 'distance',
    'grams': 'mass',
    'kilograms': 'mass',
    'pounds': 'mass',
    'ounces': 'mass',
  };

  final Map<String, double> _factorToBase = {
    'meters': 1.0,
    'kilometers': 1000.0,
    'feet': 0.3048,
    'miles': 1609.344,
    'kilograms': 1.0,
    'grams': 0.001,
    'pounds': 0.45359237,
    'ounces': 0.028349523125,
  };

  @override
  void initState() {
    super.initState();
    _numberFrom = 100.0;
    _convert();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(1);
    }
    String formatted = value.toStringAsFixed(3);
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      if (formatted.endsWith('.')) {
        formatted = '${formatted}0';
      }
    }
    return formatted;
  }

  void _convert() {
    if (_startMeasure == null || _convertedMeasure == null) {
      setState(() {
        _resultMessage = 'Please select both measures';
      });
      return;
    }

    final String text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _resultMessage = 'Please insert a number to convert';
      });
      return;
    }

    final double? parsed = double.tryParse(text);
    if (parsed == null) {
      setState(() {
        _resultMessage = 'Please enter a valid numeric value';
      });
      return;
    }

    _numberFrom = parsed;

    final String? fromType = _measureTypes[_startMeasure];
    final String? toType = _measureTypes[_convertedMeasure];

    if (fromType != toType) {
      setState(() {
        _resultMessage = 'This conversion cannot be performed';
      });
      return;
    }

    final double fromFactor = _factorToBase[_startMeasure!]!;
    final double toFactor = _factorToBase[_convertedMeasure!]!;

    final double baseValue = _numberFrom! * fromFactor;
    final double result = baseValue / toFactor;

    final String formattedInput = _formatNumber(_numberFrom!);
    final String formattedResult = _formatNumber(result);

    setState(() {
      _resultMessage =
          '$formattedInput $_startMeasure are $formattedResult $_convertedMeasure';
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontSize: 22,
      color: Colors.grey[700],
      fontWeight: FontWeight.w500,
    );

    final TextStyle inputStyle = TextStyle(
      fontSize: 20,
      color: Colors.blue[900],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measures Converter'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                'Value',
                style: labelStyle,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: inputStyle,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Please insert the measure to be converted',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (text) {
                  final double? value = double.tryParse(text.trim());
                  if (value != null) {
                    _numberFrom = value;
                  }
                },
                onSubmitted: (_) => _convert(),
              ),
              const SizedBox(height: 25),
              Text(
                'From',
                style: labelStyle,
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                style: inputStyle,
                value: _startMeasure,
                items: _measures.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: inputStyle,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _startMeasure = value;
                  });
                },
              ),
              const SizedBox(height: 25),
              Text(
                'To',
                style: labelStyle,
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                style: inputStyle,
                value: _convertedMeasure,
                items: _measures.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: inputStyle,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _convertedMeasure = value;
                  });
                },
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 2,
                ),
                onPressed: _convert,
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _resultMessage,
                textAlign: TextAlign.center,
                style: labelStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
