import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:srs/components/line_chart.dart';
import 'package:http/http.dart' as http;

class StockScreen extends StatefulWidget {
  const StockScreen({super.key, required this.stockName});
  final String stockName;

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<String> xAxis = [];
  List<double> yAxis = [];
  List<FlSpot> spots = [];
  TextEditingController prevCloseController = TextEditingController();
  TextEditingController volumeController = TextEditingController();
  TextEditingController deliverableVolumeController = TextEditingController();
  TextEditingController ma30DaysController = TextEditingController();
  TextEditingController rsiController = TextEditingController();
  TextEditingController macdController = TextEditingController();
  TextEditingController macdSignalController = TextEditingController();
  TextEditingController dmiController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    prevCloseController.dispose();
    volumeController.dispose();
    deliverableVolumeController.dispose();
    ma30DaysController.dispose();
    rsiController.dispose();
    macdController.dispose();
    macdSignalController.dispose();
    dmiController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    var response = await http.get(
        Uri.parse('http://127.0.0.1:5000/data?stock_name=${widget.stockName}'));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      xAxis = List<String>.from(body['x_axis']);
      yAxis = List<dynamic>.from(body['y_axis'])
          .map((e) => double.parse(e.toString().replaceAll('\$', '')))
          .toList();

      setState(() {
        spots = List<FlSpot>.generate(xAxis.length, (index) {
          return FlSpot(index.toDouble(), yAxis[index]);
        });
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Future<void> sendData() async {

  //   var input_data = {
  //       'Prev Close': [double.tryParse(prevCloseController.text)],
  //       'Volume': [double.tryParse(volumeController.text)],
  //       'Deliverable Volume': [double.tryParse(deliverableVolumeController.text)],
  //       '30-day MA': [double.tryParse(ma30DaysController.text)],
  //       'RSI': [double.tryParse(rsiController.text)],
  //       'MACD': [double.tryParse(macdController.text)],
  //       'MACD Signal': [double.tryParse(macdSignalController.text)],
  //       'DMI': [double.tryParse(dmiController.text)]
  //   };
  //   var response = await http.post(Uri.parse(
  //       'http://127.0.0.1:5000/predict?stock_name=${widget.stockName}&data=${jsonEncode(input_data))}'));

  //   if (response.statusCode == 200) {
  //     Map<String,dynamic> body = jsonDecode(response.body);
      
  //     AlertDialog(content: Center(child: Text(body['message']),),);
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  Future<void> sendData() async {
  var input_data = {
    'Prev Close': [double.tryParse(prevCloseController.text) ?? 0.0],
    'Volume': [double.tryParse(volumeController.text) ?? 0.0],
    'Deliverable Volume': [double.tryParse(deliverableVolumeController.text) ?? 0.0],
    '30-day MA': [double.tryParse(ma30DaysController.text) ?? 0.0],
    'RSI': [double.tryParse(rsiController.text) ?? 0.0],
    'MACD': [double.tryParse(macdController.text) ?? 0.0],
    'MACD Signal': [double.tryParse(macdSignalController.text) ?? 0.0],
    'DMI': [double.tryParse(dmiController.text) ?? 0.0],
  };

  var jsonData = jsonEncode(input_data);  // Convert to JSON string

  var url = Uri.parse('http://127.0.0.1:5000/predict?stock_name=${widget.stockName}');

  try {
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,  // Send JSON data as body
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Prediction Result'),
          content: Container(
            width: 300,
            height: 200,
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: 270,
                  child: Image.asset(
                    
                      () {
                        switch (body['message']) {
                          case 'increase':
                            return 'assets/animatedlogos/increase.png'; // Replace with your asset path
                        // Replace with another asset path
                          default:
                            return 'assets/animatedlogos/decrease.png';  // Default asset path
                        }
                      }(),
                    ),
                ),
                Text(body['message']),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      throw Exception('Failed to predict: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending data: $e');
    // Handle error appropriately, e.g., show error message to user
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to send data. Please try again later.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stockName),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            height: 250,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            child: GradientLineChart(
              spots: spots,
            ),
          ),
          const Center(
            child: Text("Hello there"),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _buildTextField("Prev Close", prevCloseController),
                    _buildTextField("Volume", volumeController),
                    _buildTextField(
                        "Deliverable Volume", deliverableVolumeController),
                    _buildTextField("30-day MA", ma30DaysController),
                    _buildTextField("RSI", rsiController),
                    _buildTextField("MACD", macdController),
                    _buildTextField("MACD Signal", macdSignalController),
                    _buildTextField("DMI", dmiController),
                    IconButton(
                      onPressed: sendData,
                      icon: const Icon(Icons.ads_click),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
