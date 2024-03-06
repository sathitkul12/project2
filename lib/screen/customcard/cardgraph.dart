import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pheasant_house/screen/chartscreen/chartscreen.dart';
import 'package:pheasant_house/screen/mqtt/mqtt.dart';

class CardGraph extends StatefulWidget {
  final List<double> temperatureData;
  final List<double> humidityData;
  final List<double> ldrData;
  final List<double> mqData;
  final List<double> soilData;

  const CardGraph({
    Key? key,
    required this.temperatureData,
    required this.humidityData,
    required this.ldrData,
    required this.mqData,
    required this.soilData,
  }) : super(key: key);

  @override
  State<CardGraph> createState() => _CardGraphState();
}

class _CardGraphState extends State<CardGraph> {
  late MqttHandler mqttHandler;

  List<double> accumulatedTemperatureData = [];
  List<double> accumulatedHumidityData = [];
  List<double> accumulatedLdrData = [];
  List<double> accumulatedMqData = [];
  List<double> accumulatedSoilData = [];

  @override
  void initState() {
    super.initState();
    mqttHandler = MqttHandler();
    mqttHandler.connectAndSubscribe();

    mqttHandler.temperatureStream.listen((double value) {
      onDataReceived(value, accumulatedTemperatureData);
    });

    mqttHandler.humidityStream.listen((double value) {
      onDataReceived(value, accumulatedHumidityData);
    });

    mqttHandler.ldrStream.listen((double value) {
      onDataReceived(value, accumulatedLdrData);
    });

    mqttHandler.mqStream.listen((double value) {
      onDataReceived(value, accumulatedMqData);
    });

    mqttHandler.soilStream.listen((double value) {
      onDataReceived(value, accumulatedSoilData);
    });
  }

  void onDataReceived(double value, List<double> dataList) {
    if (mounted) {
      setState(() {
        dataList.add(value);

        if (dataList.length == 20) {
          double averageValue = dataList.reduce((a, b) => a + b) / 20;
          dataList.clear();

          if (dataList == accumulatedTemperatureData) {
            accumulatedTemperatureData.add(averageValue);
          } else if (dataList == accumulatedHumidityData) {
            accumulatedHumidityData.add(averageValue);
          } else if (dataList == accumulatedLdrData) {
            accumulatedLdrData.add(averageValue);
          } else if (dataList == accumulatedMqData) {
            accumulatedMqData.add(averageValue);
          } else if (dataList == accumulatedSoilData) {
            accumulatedSoilData.add(averageValue);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 1.53,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(80),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.67,
              width: MediaQuery.of(context).size.width / 1.7,
              child: ListWheelScrollView(
                itemExtent: 500, // Adjust the itemExtent based on your needs
                children: [
                  LineChart(
                    buildLineChartData(
                      accumulatedTemperatureData,
                      Colors.red,
                      maxY: 50,
                    ),
                    //เพิ่มข้อความ อูณหภูมิ
                  ),
                  LineChart(
                    buildLineChartData(
                      accumulatedHumidityData,
                      const Color.fromARGB(255, 23, 151, 255),
                      maxY: 100,
                    ),
                    //เพิ่มข้อความ ความชื่น
                  ),
                  LineChart(
                    buildLineChartData(
                      accumulatedMqData,
                      const Color.fromARGB(255, 7, 120, 5),
                      maxY: 50,
                      //เพิ่มข้อความ เเก็สเเอมโมเนีย
                    ),
                  ),
                  LineChart(
                    buildLineChartData(
                      accumulatedLdrData,
                      Colors.yellow,
                      maxY: 1000,
                    ),
                    //เพิ่มข้อความ ความเข็มเเสง
                  ),
                  LineChart(
                    buildLineChartData(
                      accumulatedSoilData,
                      Colors.brown,
                      maxY: 50,
                    ),
                    //เพิ่มข้อความ ความชื่นในดิน
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}
