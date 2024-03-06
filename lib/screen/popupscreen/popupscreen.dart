import 'package:flutter/material.dart';
import 'package:pheasant_house/screen/popupscreen/customdropdown.dart';

class PopupLight extends StatefulWidget {
  const PopupLight({Key? key}) : super(key: key);

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
  String selectedTime = '00';
  String selectedMinute = '00';
  TimeOfDay selectedClosingTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime1 = TimeOfDay.now();

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
                      initialTime: selectedClosingTime,
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedClosingTime) {
                      setState(() {
                        selectedClosingTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
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
                      initialTime: selectedClosingTime1,
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedClosingTime1) {
                      setState(() {
                        selectedClosingTime1 = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: Text(
                    selectedClosingTime1.format(context),
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
                // Use minTemperature and maxTemperature as needed
                print('Minimum Light: $minLdr');
                print('Maximum Light: $maxLdr');
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
      ],
    )));
  }
}

class PopupTemp extends StatefulWidget {
  const PopupTemp({Key? key}) : super(key: key);

  @override
  State<PopupTemp> createState() => _PopupTempState();
}

class _PopupTempState extends State<PopupTemp> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  List<String> minute =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));
  double? minTemperature;
  double? maxTemperature;
  String selectedTime = '00';
  String selectedMinute = '00';
  TimeOfDay selectedClosingTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime1 = TimeOfDay.now();
  double? temperatureDifference;

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
                              minTemperature = double.tryParse(value);
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
                              maxTemperature = double.tryParse(value);
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
                          initialTime: selectedClosingTime,
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
                          initialTime: selectedClosingTime1,
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedClosingTime1) {
                          setState(() {
                            selectedClosingTime1 = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        selectedClosingTime1.format(context),
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
                    // Calculate the temperature difference
                    temperatureDifference =
                        maxTemperature != null && minTemperature != null
                            ? maxTemperature! - minTemperature!
                            : null;

                    // Print the difference
                    print('Temperature Difference: $temperatureDifference');

                    // Navigate to CardAmmonia with the temperature difference
                    Navigator.pop(context, temperatureDifference);
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
          ],
        ),
      ),
    );
  }
}

class PopupSmell extends StatefulWidget {
  const PopupSmell({Key? key}) : super(key: key);

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

  TimeOfDay selectedClosingTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime1 = TimeOfDay.now();
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
                      initialTime: selectedClosingTime,
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
                      initialTime: selectedClosingTime1,
                    );
                    if (pickedTime != null &&
                        pickedTime != selectedClosingTime1) {
                      setState(() {
                        selectedClosingTime1 = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    selectedClosingTime1.format(context),
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
                // Use minTemperature and maxTemperature as needed
                print('Minimum Ammonai: $minMq');
                print('Maximum Ammonai: $maxMq');
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
      ],
    )));
  }
}

class PopupTempIn extends StatefulWidget {
  const PopupTempIn({Key? key}) : super(key: key);

  @override
  State<PopupTempIn> createState() => _PopupTempInState();
}

class _PopupTempInState extends State<PopupTempIn> {
  final TextEditingController _fullController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  List<String> minute =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));

  String selectedTime = '00';
  String selectedMinute = '00';
  TimeOfDay selectedClosingTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime1 = TimeOfDay.now();

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
                    'สปริงเกอร์บนหลังคา',
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
                          controller: _fullController,
                          decoration: const InputDecoration(
                            labelText: 'ต่ำสุด',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Do something with the entered value
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _pointController,
                          decoration: const InputDecoration(
                            labelText: 'สูงสุด',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Do something with the entered value
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
                          initialTime: selectedClosingTime,
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedClosingTime) {
                          setState(() {
                            selectedClosingTime = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
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
                          initialTime: selectedClosingTime1,
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedClosingTime1) {
                          setState(() {
                            selectedClosingTime1 = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: Text(
                        selectedClosingTime1.format(context),
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
          ],
        ),
      ),
    );
  }
}

class PopupMoisture extends StatefulWidget {
  const PopupMoisture({Key? key}) : super(key: key);

  @override
  State<PopupMoisture> createState() => _PopupMoistureState();
}

class _PopupMoistureState extends State<PopupMoisture> {
  final TextEditingController _fullController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  List<String> minute =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));

  String selectedTime = '00';
  String selectedMinute = '00';
  TimeOfDay selectedClosingTime = TimeOfDay.now();
  TimeOfDay selectedClosingTime1 = TimeOfDay.now();

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
                    'สปริงเกอร์รดน้ำต้นไม้',
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
                          controller: _fullController,
                          decoration: const InputDecoration(
                            labelText: 'ต่ำสุด',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Do something with the entered value
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _pointController,
                          decoration: const InputDecoration(
                            labelText: 'สูงสุด',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Do something with the entered value
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
                          initialTime: selectedClosingTime,
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedClosingTime) {
                          setState(() {
                            selectedClosingTime = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
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
                          initialTime: selectedClosingTime1,
                        );
                        if (pickedTime != null &&
                            pickedTime != selectedClosingTime1) {
                          setState(() {
                            selectedClosingTime1 = pickedTime;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: Text(
                        selectedClosingTime1.format(context),
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
          ],
        ),
      ),
    );
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
