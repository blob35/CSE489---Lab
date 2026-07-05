import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

// 1. ROOT APP CONFIGURATION
class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vangti Chai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 247, 179, 237)),
        useMaterial3: true,
      ),
      home: const VangtiChaiHomePage(),
    );
  }
}

// 2. STATEFUL SCREEN WRAPPER
class VangtiChaiHomePage extends StatefulWidget {
  const VangtiChaiHomePage({super.key});

  @override
  State<VangtiChaiHomePage> createState() => _VangtiChaiHomePageState();
}

// 3. THE ACTUAL LOGIC & UI BUILDER
class _VangtiChaiHomePageState extends State<VangtiChaiHomePage> {
  // --- STATE VARIABLES ---
  String _inputAmount = ''; 
  
  final Map<int, int> _noteCounts = {
    500: 0, 100: 0, 50: 0, 20: 0, 10: 0, 5: 0, 2: 0, 1: 0
  };

  // --- LOGIC METHODS ---
  void _handleKeyPress(String value) {
    setState(() {
      if (value == 'CLEAR') {
        _inputAmount = '';
      } else {
        if (_inputAmount.length < 8) {
          _inputAmount += value;
        }
      }
      _calculateBreakdown();
    });
  }

  void _calculateBreakdown() {
    int amount = int.tryParse(_inputAmount) ?? 0;
    List<int> denominations = [500, 100, 50, 20, 10, 5, 2, 1];

    for (var den in denominations) {
      _noteCounts[den] = 0;
    }

    for (var den in denominations) {
      if (amount >= den) {
        _noteCounts[den] = amount ~/ den;
        amount = amount % den;
      }
    }
  }

  // --- UI MAIN BUILDER ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VangtiChai'),
        backgroundColor: const Color.fromARGB(255, 102, 193, 253),
        foregroundColor: Colors.white,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;

          return Column(
            children: [
              const SizedBox(height: 15),
              // Centered Display (Always at the top)
              Text(
                _inputAmount.isEmpty ? 'Taka: 0' : 'Taka: $_inputAmount',
                style: const TextStyle(fontSize: 24, color: Colors.black87),
              ),
              const SizedBox(height: 15),
              // Content Area splits based on screen orientation
              Expanded(
                child: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- PORTRAIT SIDE-BY-SIDE LAYOUT ---
  Widget _buildPortraitLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side: Plain Text Breakdown
        Expanded(
          flex: 2,
          child: _buildPlainList(),
        ),
        // Right Side: Grid Keypad
        Expanded(
          flex: 3,
          child: _buildPlainKeypad(isLandscape: false),
        ),
      ],
    );
  }

  // --- LANDSCAPE SIDE-BY-SIDE LAYOUT ---
  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side: Plain Text Breakdown
        Expanded(
          flex: 2,
          child: SingleChildScrollView(child: _buildPlainList()),
        ),
        // Right Side: Shorter Grid Keypad for wide screens
        Expanded(
          flex: 3,
          child: SingleChildScrollView(child: _buildPlainKeypad(isLandscape: true)),
        ),
      ],
    );
  }

  // --- PLAIN TEXT LIST ---
  Widget _buildPlainList() {
    List<int> denominations = [500, 100, 50, 20, 10, 5, 2, 1];
    
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: denominations.map((den) {
          int count = _noteCounts[den] ?? 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              '$den: $count',
              style: const TextStyle(fontSize: 22, color: Colors.black87),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- PLAIN BLOCK KEYPAD ---
  Widget _buildPlainKeypad({required bool isLandscape}) {
    // Tweak row heights so it doesn't overflow when horizontal
    double buttonHeight = isLandscape ? 40 : 55; 

    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 4.0),
      child: Column(
        children: [
          _buildRow(['1', '2', '3'], buttonHeight),
          const SizedBox(height: 6),
          _buildRow(['4', '5', '6'], buttonHeight),
          const SizedBox(height: 6),
          _buildRow(['7', '8', '9'], buttonHeight),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(flex: 1, child: _buildRawButton('0', buttonHeight)),
              const SizedBox(width: 6),
              Expanded(flex: 2, child: _buildRawButton('CLEAR', buttonHeight)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> labels, double height) {
    return Row(
      children: labels.map((label) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: _buildRawButton(label, height),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRawButton(String label, double height) {
    return SizedBox(
      height: height, 
      child: TextButton(
        onPressed: () => _handleKeyPress(label),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFDCDCDC), 
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), 
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
    );
  }
}