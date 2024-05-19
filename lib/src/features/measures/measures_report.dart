import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final_movil/src/providers/api_provider.dart';
import 'package:http/http.dart' as http;

class MeasuresReport extends StatefulWidget {
  const MeasuresReport({super.key});

  @override
  State<MeasuresReport> createState() {
    return _MeasuresReportState();
  }
}

class _MeasuresReportState extends State<MeasuresReport> {
  final ApiProvider _apiProvider = ApiProvider();
  final Color lineColor = Colors.deepPurple;
  final List<FlSpot> dataFtp = [];
  final List<FlSpot> dataVo2 = [];

  @override
  void initState() {
    super.initState();
    getMeasures(context);
  }

  Future<void> getMeasures(context) async {
    final client = http.Client();
    dynamic res = await _apiProvider.getMeasures(context, client);

    if (res['success'] == false) {
      log('error en la obtencion de la lista de calendario');
    } else {
      var data = res['response']['result'];
      var ftpData = data['ftp'];
      var vo2Data = data['vo2'];
      for(int i = 0; i < ftpData.length; i++) {
        dataFtp.add(FlSpot(i.toDouble(), ftpData[i]['valor']));
      }
      for(int i = 0; i < vo2Data.length; i++) {
        dataVo2.add(FlSpot(i.toDouble(), (vo2Data[i]['valor']).toDouble()));
      }
      setState(() {
        dataFtp;
        dataVo2;
      });
    }

  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        text = '++';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(value.toString(), style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value + 0.1}',
        style: style,
      ),
    );
  }

  Widget leftTitleVo2Widgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value + 8.0}',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          const Text(
              'FTP',
            style: TextStyle(
              fontSize: 25,
              color: Colors.deepPurple
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                key: const Key('ftp_dashboard'),
                scrollDirection: Axis.horizontal,
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 18,
                      top: 10,
                      bottom: 4,
                    ),
                    child: LineChart(
                      LineChartData(
                        lineTouchData: const LineTouchData(enabled: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: dataFtp,
                            isCurved: true,
                            barWidth: 2,
                            color: lineColor,
                            dotData: const FlDotData(
                              show: true,
                            ),
                          ),
                        ],
                        minY: 0,
                        borderData: FlBorderData(
                          show: true,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: bottomTitleWidgets,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: leftTitleWidgets,
                              interval: 1,
                              reservedSize: 36,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 1,
                          checkToShowHorizontalLine: (double value) {
                            return value == 1 || value == 6 || value == 4 || value == 5;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ),
          const Text(
              'VO2 max',
            style: TextStyle(
            fontSize: 25,
            color: Colors.deepPurple
          ),
          ),
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 18,
                      top: 10,
                      bottom: 4,
                    ),
                    child: LineChart(
                      LineChartData(
                        lineTouchData: const LineTouchData(enabled: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: dataVo2,
                            isCurved: true,
                            barWidth: 2,
                            color: lineColor,
                            dotData: const FlDotData(
                              show: true,
                            ),
                          ),
                        ],
                        minY: 0,
                        borderData: FlBorderData(
                          show: true,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: bottomTitleWidgets,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: leftTitleVo2Widgets,
                              interval: 1,
                              reservedSize: 36,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 1,
                          checkToShowHorizontalLine: (double value) {
                            return value == 1 || value == 6 || value == 4 || value == 5;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ),
        ],
      )
    );
  }
}

