// mqtt.dart
import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler {
  // Constants for MQTT topics and client ID
  final String mqttServer = 'test.mosquitto.org';
  final String clientId = 'clientId-bzwIkQ3vF5';
  // final String tempTopic = 'esp32/temp';
  // final String humidityTopic = 'esp32/humidity';
  // final String ldrTopic = 'esp32/ldr';
  // final String mqTopic = 'esp32/mq';
  // final String soilTopic = 'esp32/soil';
  final String autoModeTopic = 'esp32/auto_mode';

  // MQTT client and StreamControllers for different sensor data
  late MqttServerClient client;
  final StreamController<double> _temperatureStreamController =
      StreamController<double>.broadcast();
  final StreamController<double> _humidityStreamController =
      StreamController<double>.broadcast();
  final StreamController<double> _ldrStreamController =
      StreamController<double>.broadcast();
  final StreamController<double> _mqStreamController =
      StreamController<double>.broadcast();
  final StreamController<double> _soilStreamController =
      StreamController<double>.broadcast();

  // Getter methods for sensor data streams
  Stream<double> get temperatureStream => _temperatureStreamController.stream;
  Stream<double> get humidityStream => _humidityStreamController.stream;
  Stream<double> get ldrStream => _ldrStreamController.stream;
  Stream<double> get mqStream => _mqStreamController.stream;
  Stream<double> get soilStream => _soilStreamController.stream;

  // Constructor: Initializes the MQTT client and sets up MQTT connection
  MqttHandler() {
    client = MqttServerClient(mqttServer, clientId);
    _setupMqtt();
  }

  // Set up MQTT connection and subscriptions
  void _setupMqtt() {
    client.logging(on: false);
    // client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.connect();
  }

  // Callback on successful MQTT connection
  // void onConnected() {
  //   // Subscribe to different sensor topics
  //   client.subscribe(tempTopic, MqttQos.atLeastOnce);
  //   client.subscribe(humidityTopic, MqttQos.atLeastOnce);
  //   client.subscribe(ldrTopic, MqttQos.atLeastOnce);
  //   client.subscribe(mqTopic, MqttQos.atLeastOnce);
  //   client.subscribe(soilTopic, MqttQos.atLeastOnce);

  // Listen for incoming messages and handle them
  //   client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
  //     final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
  //     final String payload =
  //         MqttPublishPayload.bytesToStringAsString(message.payload.message);
  //     final String topic = c[0].topic;
  //     handleMessage(topic, payload);
  //   });
  // }

  // Callback on MQTT disconnection
  void onDisconnected() {
    // Handle disconnection
  }

  // Callback on unsubscribing from a topic
  void onUnsubscribed(String? topic) {}

  // // Handle incoming MQTT messages based on topic
  // void handleMessage(String topic, String payload) {
  //   double value = double.tryParse(payload) ?? 0.0;

  //   // Update respective StreamControllers based on topic
  //   if (topic == tempTopic) {
  //     _temperatureStreamController.add(value);
  //   }
  //   if (topic == humidityTopic) {
  //     _humidityStreamController.add(value);
  //   }
  //   if (topic == ldrTopic) {
  //     _ldrStreamController.add(value);
  //   }
  //   if (topic == mqTopic) {
  //     _mqStreamController.add(value);
  //   }
  //   if (topic == soilTopic) {
  //     _soilStreamController.add(value);
  //   }
  // }

  // Control relay by sending MQTT command
  void controlRelay(String topic, String command) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(command);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  // Send MQTT command for automatic mode
  void sendAutoModeCommand(String topic, String command) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(command);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  // Connect and subscribe to MQTT topics
  void connectAndSubscribe() {
    // No need to include additional logic here
  }

  // Callback for handling received temperature data
  void onTemperatureReceived(double value) {
    // Handle the received temperature data, if needed
  }

  // Callback for handling received humidity data
  void onHumidityReceived(double value) {
    // Handle the received humidity data, if needed
  }

  // Callback for handling received LDR data
  void onldrReceived(double value) {
    // Handle the received LDR data, if needed
  }

  // Callback for handling received MQ data
  void onmqReceived(double value) {
    // Handle the received MQ data, if needed
  }

  // Callback for handling received soil data
  void onsoilReceived(double value) {
    // Handle the received soil data, if needed
  }

  // Dispose of resources when no longer needed
  void dispose() {
    _temperatureStreamController.close();
    _humidityStreamController.close();
    _ldrStreamController.close();
    _mqStreamController.close();
    _soilStreamController.close();
    client.disconnect();
  }

  // Send relay command with optional retention
  void sendRelayCommand(String topic, String command,
      {required bool retained}) {}
}
