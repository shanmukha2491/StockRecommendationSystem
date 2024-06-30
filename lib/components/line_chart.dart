

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GradientLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  GradientLineChart({Key? key, required this.spots}) : super(key: key);
  
  // List<FlSpot> spots = [
  //     FlSpot(0, 1), // (x, y) = (0, 1)
  //     FlSpot(1, 3), // (x, y) = (1, 3)
  //     FlSpot(2, 2), // (x, y) = (2, 2)
  //     FlSpot(3, 5), // (x, y) = (3, 5)
  //     FlSpot(4, 3), // (x, y) = (4, 3)
  //     FlSpot(5, 4), // (x, y) = (5, 4)
  //     FlSpot(6, 3), // (x, y) = (6, 3)
  //   ];
  
  @override
  Widget build(BuildContext context) {
    
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots.reversed.toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,),),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,),),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,),),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
      ),
    );
  }
}
