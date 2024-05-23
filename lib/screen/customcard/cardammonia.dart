// Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:pheasant_house/constants.dart';
import 'package:pheasant_house/screen/mqtt/mqtt.dart';

import '../popupscreen/popupscreen.dart';

class CardAmmonia extends StatefulWidget {
  final bool initialIsOpen;
  final bool initialIsAuto;

  const CardAmmonia({
    Key? key,
    this.initialIsOpen = false,
    this.initialIsAuto = false,
  }) : super(key: key);

  @override
  State<CardAmmonia> createState() => _CardAmmoniaState();
}

class _CardAmmoniaState extends State<CardAmmonia> {
  late bool isOpen;
  late bool isOpen1;
  late bool isAuto;
  late double mqValue; // Add this variable to store MQ value
  late double temperatureValue; // Add this variable to store temperature value
  bool isAutoMode = false;
  late final MqttHandler mqttHandler;

  @override
  void initState() {
    super.initState();
    isOpen = widget.initialIsOpen;
    isOpen1 = widget.initialIsOpen;
    isAuto = widget.initialIsAuto;
    mqValue = 0.0;
    temperatureValue = 0.0;
    mqttHandler = MqttHandler();
    // Subscribe to the MQ stream to get real-time updates
    mqttHandler.mqStream.listen((double value) {
      setState(() {
        mqValue = value;
      });
    });

    // Subscribe to the temperature stream to get real-time updates
    mqttHandler.temperatureStream.listen((double value) {
      setState(() {
        temperatureValue = value;
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

  void turnOnRelay2() {
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.controlRelay('esp32/relay2', 'on');
    }
  }

  void turnOffRelay2() {
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.controlRelay('esp32/relay2', 'off');
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

  @override
  void dispose() {
    mqttHandler
        .dispose(); // Dispose of the MQTT handler when the widget is disposed
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
          Image.asset('lib/images/Rectangle78.png'),
          sizedBox,
          buildStatusRow(),
          buildSwitchRow(
              'เปิด/ปิด(พัดลม)',
              isOpen1,
              (value) => setState(
                    () {
                      isOpen1 = value;
                      if (isOpen1) {
                        turnOnRelay2();
                      } else {
                        turnOffRelay2();
                      }
                    },
                  )),
          buildSwitchRow(
              'เปิด/ปิด(สปริงเกอร์บนลังคา)',
              isOpen,
              (value) => setState(
                    () {
                      isOpen = value;
                      if (isOpen) {
                        turnOnRelay3();
                      } else {
                        turnOffRelay3();
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PopupTemp()));
            },
            child: buildInfoContainer('อุณหภูมิ', '  C ',
                'lib/images/Rectangle78.png', 7, temperatureValue),
          ),
          sizedBox,
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PopupSmell()));
            },
            child: buildInfoContainer(
                'แอมโมเนียม', 'pH ', 'lib/images/image3.png', 4, mqValue),
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
            fontSize: 18,
          ),
        ),
        Text(
          isOpen1 ? 'เปิด' : 'ปิด ',
          style: TextStyle(
            color: isOpen1 ? Colors.green : Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          ' สถานะ : ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          isOpen ? 'เปิด' : 'ปิด ',
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
            fontSize: 16.5,
          ),
        ),
        Switch(
          activeColor: Colors.green,
          activeTrackColor: Colors.green[200],
          inactiveTrackColor: Colors.red[200],
          inactiveThumbColor: Colors.white,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildInfoContainer(String title, String unit, String imageAsset,
      double scale, double value) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.6,
      height: MediaQuery.of(context).size.height / 33,
      decoration: const BoxDecoration(
        color: Color(0xFF6FC0C5),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
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
                Image.asset(
                  imageAsset,
                  scale: scale,
                ),
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
              width: 5,
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
}
