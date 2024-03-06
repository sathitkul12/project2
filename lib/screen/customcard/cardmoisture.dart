import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:pheasant_house/screen/mqtt/mqtt.dart';

import '../popupscreen/popupscreen.dart';

class CardMoisture extends StatefulWidget {
  final bool initialIsOpen;
  final bool initialIsAuto;

  const CardMoisture({
    Key? key,
    this.initialIsOpen = false,
    this.initialIsAuto = false,
  }) : super(key: key);

  @override
  State<CardMoisture> createState() => _CardMoistureState();
}

class _CardMoistureState extends State<CardMoisture> {
  late bool isOpen;
  late bool isOpen1;
  late bool isAuto;
  late double humidityValue;
  late double soilValue;
  bool isAutoMode = false;
  // Instantiate MqttHandler
  final MqttHandler mqttHandler = MqttHandler();

  @override
  void initState() {
    super.initState();
    isOpen = widget.initialIsOpen;
    isOpen1 = widget.initialIsOpen;
    isAuto = widget.initialIsAuto;
    humidityValue = 0.0;
    soilValue = 0.0;

    // Subscribe to the humidity stream to get real-time updates
    mqttHandler.humidityStream.listen((double value) {
      setState(() {
        humidityValue = value;
      });
    });

    // Subscribe to the soil stream to get real-time updates
    mqttHandler.soilStream.listen((double value) {
      setState(() {
        soilValue = value;
      });
    });
  }

  void switchToManualMode() {
    setState(() {
      isAutoMode = false;
    });

    // Check if MQTT client is connected before sending the command
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.sendAutoModeCommand('esp32/auto_mode', 'manual');
    }
  }

  void switchToAutoMode() {
    setState(() {
      isAutoMode = true;
    });

    // Check if MQTT client is connected before sending the command
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.sendAutoModeCommand('esp32/auto_mode', 'auto');
    }
  }

  void turnOnRelay3() {
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.controlRelay('esp32/relay3', 'on');
    }
  }

  void turnOffRelay3() {
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.controlRelay('esp32/relay3', 'off');
    }
  }

  void turnOnRelay4() {
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.controlRelay('esp32/relay4', 'on');
    }
  }

  void turnOffRelay4() {
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.controlRelay('esp32/relay4', 'off');
    }
  }

  @override
  void dispose() {
    mqttHandler
        .dispose(); // Dispose of the MqttHandler when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      height: MediaQuery.of(context).size.height / 1.7,
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
          sizedBox,
          Image.asset('lib/images/Vector.png'),
          sizedBox,
          buildStatusRow(),
          buildSwitchRow(
              'เปิด/ปิด(สปริงเกอร์บนลังคา)',
              isOpen1,
              (value) => setState(
                    () {
                      isOpen1 = value;
                      if (isOpen1) {
                        turnOnRelay3();
                      } else {
                        turnOffRelay3();
                      }
                    },
                  )),
          buildSwitchRow(
              'เปิด/ปิด(สปริงเกอร์รดต้นไม้)',
              isOpen,
              (value) => setState(
                    () {
                      isOpen = value;
                      if (isOpen) {
                        turnOnRelay4();
                      } else {
                        turnOffRelay4();
                      }
                    },
                  )),
          buildSwitchRow(
              'อัตโนมัติ',
              isAuto,
              (value) => setState(
                    () {
                      isAuto = value;
                      if (isAuto) {
                        switchToAutoMode();
                      } else {
                        switchToManualMode();
                      }
                    },
                  )),
          sizedBox,
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PopupTempIn()),
              );
            },
            child: buildInfoContainer(
              'ความชื้นในอากาศ',
              ' %',
              'lib/images/Vector.png',
              7,
              humidityValue,
            ),
          ),
          sizedBox,
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PopupMoisture(),
                ),
              );
            },
            child: buildInfoContainer(
              'ความชื้นในดิน',
              ' %',
              'lib/images/Vector.png',
              7,
              soilValue,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'สถานะ : ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          isOpen ? 'เปิด' : 'ปิด',
          style: TextStyle(
            color: isOpen1 ? Colors.green : Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          '  สถานะ : ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          isOpen ? 'เปิด' : 'ปิด',
          style: TextStyle(
            color: isOpen ? Colors.green : Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildSwitchRow(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label : ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Switch(
          activeColor: Colors.green,
          activeTrackColor: Colors.green[200],
          inactiveTrackColor: Colors.red[200],
          inactiveThumbColor: Colors.white,
          autofocus: false,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildInfoContainer(String title, String unit, String imageAsset,
      double scale, double value) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      height: MediaQuery.of(context).size.height / 25,
      decoration: const BoxDecoration(
        color: Color(0xFF6FC0C5),
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(imageAsset, scale: scale),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 30,
            ),
            Text(
              '$value $unit',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox get sizedBox => const SizedBox(height: 10);
}
