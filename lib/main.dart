import 'package:flutter/material.dart';

/// Entry point of the Flutter application.
void main() => runApp(const MeasuresConverterApp());

/// Root application widget configuring Material Design theme and home screen.
class MeasuresConverterApp extends StatelessWidget {
  const MeasuresConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use modern Material 3 design with a classic blue primary swatch
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

/// Stateful home screen widget allowing interactive measurement conversions.
class MeasuresConverterScreen extends StatefulWidget {
  const MeasuresConverterScreen({super.key});

  @override
  State<MeasuresConverterScreen> createState() =>
      _MeasuresConverterScreenState();
}

class _MeasuresConverterScreenState extends State<MeasuresConverterScreen> {
  // ---------------------------------------------------------------------------
  // STATE VARIABLES
  // ---------------------------------------------------------------------------

  /// Holds the numeric value entered by the user.
  double? _numberFrom;

  /// Currently selected source measure unit (defaults to 'meters').
  String? _startMeasure = 'meters';

  /// Currently selected target measure unit (defaults to 'feet').
  String? _convertedMeasure = 'feet';

  /// Message displayed to the user containing the conversion result or an error.
  String _resultMessage = '';

  /// Controller for managing the numeric input text field.
  final TextEditingController _controller = TextEditingController(text: '100');

  // ---------------------------------------------------------------------------
  // MEASURES DATA & CONVERSION FACTORS
  // ---------------------------------------------------------------------------

  /// List of convertible units available in the app dropdowns.
  /// Includes metric and imperial units for distance and mass/weight.
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

  /// Mapping each unit to its physical category (Distance or Mass).
  /// This prevents incompatible conversions (e.g., converting meters to kilograms).
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

  /// Conversion factors relative to the standard base unit:
  /// - Base unit for 'distance' is **meter** (1.0 meter)
  /// - Base unit for 'mass' is **kilogram** (1.0 kilogram)
  final Map<String, double> _factorToBase = {
    // Distance (in meters)
    'meters': 1.0,
    'kilometers': 1000.0,
    'feet': 0.3048,
    'miles': 1609.344,

    // Mass (in kilograms)
    'kilograms': 1.0,
    'grams': 0.001,
    'pounds': 0.45359237,
    'ounces': 0.028349523125,
  };

  // ---------------------------------------------------------------------------
  // LIFECYCLE & DISPOSAL
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    // Initialize default conversion for initial display (100 meters -> feet)
    _numberFrom = 100.0;
    _convert();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // CONVERSION LOGIC
  // ---------------------------------------------------------------------------

  /// Formats double numbers cleanly:
  /// - If the number is a whole integer, displays one decimal place (e.g., 100.0).
  /// - If the number is fractional, rounds to up to 3 decimal places (e.g., 328.084).
  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(1);
    }
    // Round to 3 decimal places to match university assignment specification
    String formatted = value.toStringAsFixed(3);
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      if (formatted.endsWith('.')) {
        formatted = '${formatted}0';
      }
    }
    return formatted;
  }

  /// Performs the unit conversion and updates the UI state.
  void _convert() {
    // 1. Guard against unselected units
    if (_startMeasure == null || _convertedMeasure == null) {
      setState(() {
        _resultMessage = 'Please select both measures';
      });
      return;
    }

    // 2. Guard against empty or invalid input
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

    // 3. Incompatibility Guard: Ensure both units belong to the same category
    final String? fromType = _measureTypes[_startMeasure];
    final String? toType = _measureTypes[_convertedMeasure];

    if (fromType != toType) {
      setState(() {
        _resultMessage = 'This conversion cannot be performed';
      });
      return;
    }

    // 4. Compute conversion using base-unit normalization
    // Formula: (value * fromFactor) / toFactor
    final double fromFactor = _factorToBase[_startMeasure!]!;
    final double toFactor = _factorToBase[_convertedMeasure!]!;

    final double baseValue = _numberFrom! * fromFactor;
    final double result = baseValue / toFactor;

    final String formattedInput = _formatNumber(_numberFrom!);
    final String formattedResult = _formatNumber(result);

    // 5. Update state with exact required output format:
    // "{value} {fromUnit} are {result} {toUnit}"
    setState(() {
      _resultMessage =
          '$formattedInput $_startMeasure are $formattedResult $_convertedMeasure';
    });
  }

  // ---------------------------------------------------------------------------
  // USER INTERFACE BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Reusable text styles matching the assignment screenshot layout
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

              // --- 1. "Value" Label ---
              Text(
                'Value',
                style: labelStyle,
              ),
              const SizedBox(height: 10),

              // --- 2. Numeric Input TextField ---
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

              // --- 3. "From" Dropdown Label ---
              Text(
                'From',
                style: labelStyle,
              ),
              const SizedBox(height: 10),

              // --- 4. "From" DropdownButton ---
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

              // --- 5. "To" Dropdown Label ---
              Text(
                'To',
                style: labelStyle,
              ),
              const SizedBox(height: 10),

              // --- 6. "To" DropdownButton ---
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

              // --- 7. "Convert" Action Button ---
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

              // --- 8. Result Display ---
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
