import 'package:flutter/material.dart';
import 'package:pheasant_house/screen/mqtt/mqtt.dart';
import 'package:pheasant_house/screen/popupscreen/customdropdown.dart';

class PopupLight extends StatefulWidget {
  final double? minLdr;
  final double? maxLdr;

  const PopupLight({Key? key, this.minLdr, this.maxLdr}) : super(key: key);

  @override
  State<PopupLight> createState() => _PopupLightState();
}

class _PopupLightState extends State<PopupLight> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  List<String> minute =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));
  double? minLdr;
  double? maxLdr;
  TimeOfDay selectedOpeningTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime = TimeOfDay.now();
  double? LdrDifference;

  late MqttHandler mqttHandler;

  @override
  void initState() {
    super.initState();
    mqttHandler = MqttHandler();
    mqttHandler.connectAndSubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'ตั้งค่าการทำงานอัตโนมัติ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
            // Light Intensity
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
                  child: Text(
                    'Light Range',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Minimum',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              minLdr = double.tryParse(value);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Maximum',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              maxLdr = double.tryParse(value);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Opening Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
                  child: Text(
                    'Opening Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedOpeningTime,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedOpeningTime) {
                          setState(() {
                            selectedOpeningTime = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        selectedOpeningTime.format(context),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Closing Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
                  child: Text(
                    'Closing Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedClosingTime,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedClosingTime) {
                          setState(() {
                            selectedClosingTime = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        selectedClosingTime.format(context),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String openingTimeMessage =
                        '${selectedOpeningTime.hour}:${selectedOpeningTime.minute}'; // ส่งเวลาโดยไม่รวม AM/PM
                    String closingTimeMessage =
                        '${selectedClosingTime.hour}:${selectedClosingTime.minute}';
                    mqttHandler.sendAutoModeCommand(
                        'esp32/lighton', openingTimeMessage);
                    mqttHandler.sendAutoModeCommand(
                        'esp32/lightoff', closingTimeMessage);
                    print('Opening Time: $openingTimeMessage');
                    print('Closing Time: $closingTimeMessage');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B68DD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // ย้อนกลับไปที่หน้าก่อนหน้านี้
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE85E5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PopupTemp extends StatefulWidget {
  final double? minTemp;
  final double? maxTemp;

  const PopupTemp({Key? key, this.minTemp, this.maxTemp}) : super(key: key);

  @override
  State<PopupTemp> createState() => _PopupTempState();
}

class _PopupTempState extends State<PopupTemp> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  List<String> minute =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));
  double? minTemp;
  double? maxTemp;
  TimeOfDay selectedOpeningTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime = TimeOfDay.now();

  late MqttHandler mqttHandler;

  @override
  void initState() {
    super.initState();
    mqttHandler = MqttHandler();
    mqttHandler.connectAndSubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'ตั้งค่าการทำงานอัตโนมัติ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
            // Temp
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
                  child: Text(
                    'Temperature Range',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _minController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Minimum',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              minTemp = double.tryParse(value);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _maxController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Maximum',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              maxTemp = double.tryParse(value);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Opening Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
                  child: Text(
                    'Opening Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedOpeningTime,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedOpeningTime) {
                          setState(() {
                            selectedOpeningTime = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        selectedOpeningTime.format(context),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Closing Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
                  child: Text(
                    'Closing Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedClosingTime,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedClosingTime) {
                          setState(() {
                            selectedClosingTime = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        selectedClosingTime.format(context),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String openingTimeMessage =
                        '${selectedOpeningTime.hour}:${selectedOpeningTime.minute}'; // ส่งเวลาโดยไม่รวม AM/PM
                    String closingTimeMessage =
                        '${selectedClosingTime.hour}:${selectedClosingTime.minute}';
                    mqttHandler.sendAutoModeCommand(
                        'esp32/fanon', openingTimeMessage);
                    mqttHandler.sendAutoModeCommand(
                        'esp32/fanoff', closingTimeMessage);
                    print('Opening Time: $openingTimeMessage');
                    print('Closing Time: $closingTimeMessage');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B68DD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // ย้อนกลับไปที่หน้าก่อนหน้านี้
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE85E5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PopupSmell extends StatefulWidget {
  final double? minMq;
  final double? maxMq;

  const PopupSmell({Key? key, this.minMq, this.maxMq}) : super(key: key);

  @override
  State<PopupSmell> createState() => _PopupSmellState();
}

class _PopupSmellState extends State<PopupSmell> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  List<String> minute =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));
  double? minMq;
  double? maxMq;
  TimeOfDay selectedOpeningTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime = TimeOfDay.now();
  late MqttHandler mqttHandler;

  @override
  void initState() {
    super.initState();
    mqttHandler = MqttHandler();
    mqttHandler.connectAndSubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: Text(
              'ตั้งค่าการทำงานอัตโนมัติ',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
              ),
            ),
          ),
        ),
        // Temp
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Ammonia Range',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _minController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minimum',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          minMq = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Maximum',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          maxMq = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Opening Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Opening Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedOpeningTime,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedOpeningTime) {
                      setState(() {
                        selectedOpeningTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    selectedOpeningTime.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Closing Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Closing Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedClosingTime,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedClosingTime) {
                      setState(() {
                        selectedClosingTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    selectedClosingTime.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                String openingTimeMessage =
                    '${selectedOpeningTime.hour}:${selectedOpeningTime.minute}'; // ส่งเวลาโดยไม่รวม AM/PM
                String closingTimeMessage =
                    '${selectedClosingTime.hour}:${selectedClosingTime.minute}';
                mqttHandler.sendAutoModeCommand(
                    'esp32/motor1on', openingTimeMessage);
                mqttHandler.sendAutoModeCommand(
                    'esp32/motor1off', closingTimeMessage);
                print('Opening Time: $openingTimeMessage');
                print('Closing Time: $closingTimeMessage');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B68DD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ตกลง',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // ย้อนกลับไปที่หน้าก่อนหน้านี้
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE85E5E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
              ),
            )
          ],
        ),
      ],
    )));
  }
}

class PopupTempFloor extends StatefulWidget {
  final double? minHum;
  final double? maxHum;

  const PopupTempFloor({Key? key, this.minHum, this.maxHum}) : super(key: key);

  @override
  State<PopupTempFloor> createState() => _PopupTempFloorState();
}

class _PopupTempFloorState extends State<PopupTempFloor> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  List<String> minute =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));

  double? minHum;
  double? maxHum;

  TimeOfDay selectedOpeningTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime = TimeOfDay.now();
  double? HumDifference;
  late MqttHandler mqttHandler;

  @override
  void initState() {
    super.initState();
    mqttHandler = MqttHandler();
    mqttHandler.connectAndSubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: Text(
              'ตั้งค่าการทำงานอัตโนมัติ',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
              ),
            ),
          ),
        ),
        // Temp
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Humidity Range',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _minController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minimum',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          minHum = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Maximum',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          maxHum = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Opening Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Opening Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedOpeningTime,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedOpeningTime) {
                      setState(() {
                        selectedOpeningTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    selectedOpeningTime.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Closing Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Closing Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedClosingTime,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedClosingTime) {
                      setState(() {
                        selectedClosingTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    selectedClosingTime.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                String openingTimeMessage =
                    '${selectedOpeningTime.hour}:${selectedOpeningTime.minute}'; // ส่งเวลาโดยไม่รวม AM/PM
                String closingTimeMessage =
                    '${selectedClosingTime.hour}:${selectedClosingTime.minute}';
                mqttHandler.sendAutoModeCommand(
                    'esp32/motor1on', openingTimeMessage);
                mqttHandler.sendAutoModeCommand(
                    'esp32/motor1off', closingTimeMessage);
                print('Opening Time: $openingTimeMessage');
                print('Closing Time: $closingTimeMessage');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B68DD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ตกลง',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // ย้อนกลับไปที่หน้าก่อนหน้านี้
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE85E5E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
              ),
            )
          ],
        ),
      ],
    )));
  }
}

class PopupMoisture extends StatefulWidget {
  final double? minSoil;
  final double? maxSoil;

  const PopupMoisture({Key? key, this.minSoil, this.maxSoil}) : super(key: key);

  @override
  State<PopupMoisture> createState() => _PopupMoistureState();
}

class _PopupMoistureState extends State<PopupMoisture> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  List<String> minute =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));

  double? minSoil;
  double? maxSoil;
  String selectedTime = '00';
  String selectedMinute = '00';
  TimeOfDay selectedOpeningTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime = TimeOfDay.now();
  double? SoilDifference;
  late MqttHandler mqttHandler;

  @override
  void initState() {
    super.initState();
    mqttHandler = MqttHandler();
    mqttHandler.connectAndSubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: Text(
              'ตั้งค่าการทำงานอัตโนมัติ',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
              ),
            ),
          ),
        ),
        // Temp
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Moisture Range',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _minController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minimum',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          minSoil = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Maximum',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          maxSoil = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Opening Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Opening Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedOpeningTime,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedOpeningTime) {
                      setState(() {
                        selectedOpeningTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    selectedOpeningTime.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Closing Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
              child: Text(
                'Closing Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedClosingTime,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedClosingTime) {
                      setState(() {
                        selectedClosingTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    selectedClosingTime.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                String openingTimeMessage =
                    '${selectedOpeningTime.hour}:${selectedOpeningTime.minute}'; // ส่งเวลาโดยไม่รวม AM/PM
                String closingTimeMessage =
                    '${selectedClosingTime.hour}:${selectedClosingTime.minute}';
                mqttHandler.sendAutoModeCommand(
                    'esp32/motor2on', openingTimeMessage);
                mqttHandler.sendAutoModeCommand(
                    'esp32/motor2off', closingTimeMessage);
                print('Opening Time: $openingTimeMessage');
                print('Closing Time: $closingTimeMessage');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B68DD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ตกลง',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // ย้อนกลับไปที่หน้าก่อนหน้านี้
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE85E5E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
              ),
            )
          ],
        ),
      ],
    )));
  }
}

class PopupClean extends StatefulWidget {
  const PopupClean({Key? key}) : super(key: key);

  @override
  State<PopupClean> createState() => _PopupCleanState();
}

class _PopupCleanState extends State<PopupClean> {
  DateTime dateTime = DateTime.now();
  late DateTime selectedDate;
  List<String> time = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23'
  ];
  List<String> minute = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59'
  ];
  String selectedTime = '00';
  String selectedMinute = '00';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'ตั้งค่าการทำงานอัตโนมัติ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
            //วันทำความสะอาดโรงเรือน
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
                  child: Text(
                    'วันทำความสะอาดโรงเรือน',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () async {
                          final date = await pickDate();
                          if (date == null) return;
                          setState(() {
                            dateTime = date;
                            selectedDate =
                                '${date.day}/${date.month}/${date.year}'
                                    as DateTime;
                          });
                          Navigator.pop(
                              context, {'selectedDate': selectedDate});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                          style: const TextStyle(
                              fontSize: 25, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // เวลา
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 70, top: 20, bottom: 10),
                  child: Text(
                    'เวลา',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownCustom(select: selectedTime, items: time),
                    const SizedBox(width: 20),
                    DropdownCustom(select: selectedMinute, items: minute),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B68DD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE85E5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  ),
                )
              ],
            ),
            // const TimePickerWidget(),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
}
