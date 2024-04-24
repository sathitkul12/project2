// Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:pheasant_house/constants.dart';
import 'package:pheasant_house/screen/mqtt/mqtt.dart';

import '../popupscreen/popupscreen.dart';

class CardHeat extends StatefulWidget {
  const CardHeat({super.key});

  @override
  State<CardHeat> createState() => _CardHeatState();
}

class _CardHeatState extends State<CardHeat> {
  // Instantiate MqttHandler
  final MqttHandler mqttHandler = MqttHandler();
  bool isOpen = false;
  bool isAuto = false;
  bool isAutoMode = false;
  bool isrelaylight = false;
  double minLdrValue = 0.0; // Example initial value for minLdr
  double maxLdrValue = 0.0; // Example initial value for maxLdr
  @override
  void initState() {
    super.initState();

    // Subscribe to the LDR stream to get real-time updates
    mqttHandler.ldrStream.listen((double ldrValue) {
      setState(() {
        PopupLight(minLdr: minLdrValue, maxLdr: maxLdrValue);
        ldrValue = ldrValue;
      });
    });
  }

  void handleRelayStatus(String topic, String payload) {
    bool status = payload.toLowerCase() == 'on';
    if (topic == 'esp32/relay1') {
      setState(() {
        isrelaylight = status;
      });
    }
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

  void turnOnRelay1() {
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.controlRelay('esp32/relay1', 'on');
    }
  }

  void turnOffRelay1() {
    if (mqttHandler.client.connectionStatus!.state ==
        MqttConnectionState.connected) {
      mqttHandler.controlRelay('esp32/relay1', 'off');
    }
  }

  @override
  void dispose() {
    // Dispose of the MqttHandler when the widget is disposed
    mqttHandler.dispose();
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
          Image.asset('lib/images/lamp.png'),
          sizedBox,
          Row(
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
                  color: isOpen ? Colors.green : Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ปิด/เปิด : ',
                style: TextStyle(
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
                value: isOpen,
                onChanged: (value) {
                  setState(
                    () {
                      isOpen = value;
                      if (isOpen) {
                        turnOnRelay1();
                      } else {
                        turnOffRelay1();
                      }
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'อัตโนมัติ : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Switch(
                activeColor: Colors.green,
                activeTrackColor: Colors.green[200],
                inactiveTrackColor: Colors.red[200],
                inactiveThumbColor: Colors.white,
                value: isAuto,
                onChanged: (value) {
                  setState(
                    () {
                      isAuto = value;
                      if (isAuto) {
                        switchToAutoMode();
                      } else {
                        switchToManualMode();
                      }
                    },
                  );
                },
              ),
            ],
          ),
          sizedBox,
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PopupLight()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 1.6,
              height: MediaQuery.of(context).size.height / 20,
              decoration: const BoxDecoration(
                color: Color(0xFF6FC0C5),
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'lib/images/li.png',
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'ความเข้มเเสง',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<double>(
                      stream: mqttHandler.ldrStream,
                      initialData: 0.0,
                      builder: (context, snapshot) {
                        return Text(
                          '  ${snapshot.data} Lux', // Display LDR value with 'C'
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
