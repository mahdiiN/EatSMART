import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:tflite/tflite.dart';
import 'package:external_app_launcher/external_app_launcher.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      home: NameEntryPage(),
    );
  }
}


class NameEntryPage extends StatefulWidget {
  const NameEntryPage({Key? key}) : super(key: key);

  @override
  _NameEntryPageState createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male'; // Default to 'Male'

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void moveToWelcomePage() {
    String userName = _nameController.text;
    int userAge = int.tryParse(_ageController.text) ?? 0;
    String userGender = _selectedGender;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(userName, userAge, userGender),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Information'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 45),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Name',
                  ),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Age',
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: 'Male',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value.toString();
                        });
                      },
                    ),
                    Text('Male'),
                    Radio(
                      value: 'Female',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value.toString();
                        });
                      },
                    ),
                    Text('Female'),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: moveToWelcomePage,
                  child: const Text('Submit Information'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF34416D),
                  ),
                ),
                SizedBox(height: 170),
              ],
            ),
          ),
        ),
      ),
    );
  }

}





class WelcomePage extends StatefulWidget {
  final String userName;
  final int userAge;
  final String userGender;

  WelcomePage(this.userName, this.userAge, this.userGender);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();

    // Delay for 1 second and then move to the BMI calculation page
    Timer(Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BMICalculatorPage(widget.userName),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eat Smart'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/welcome.jpg", // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome, ${widget.userName}!',
                  style: TextStyle(fontSize: 29),
                ),
                SizedBox(height: 155), // Add this SizedBox to adjust the vertical position
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  final String userName;

  BMICalculatorPage(this.userName);

  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  double height = 170.0;
  double weight = 70.0;
  double bmi = 0.0;

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    heightController.text = 'Enter your height';
    weightController.text = 'Enter your weight';
  }

  void calculateBMI() {
    setState(() {
      bmi = weight / ((height / 100) * (height / 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Step'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back3.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  onTap: () {
                    if (heightController.text == 'Enter your height') {
                      heightController.text = '';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      height = double.tryParse(value) ?? 0.0;
                    });
                    calculateBMI();
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your height (cm)',
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  onTap: () {
                    if (weightController.text == 'Enter your weight') {
                      weightController.text = '';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      weight = double.tryParse(value) ?? 0.0;
                    });
                    calculateBMI();
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your weight (kg)',
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () {
                    calculateBMI();
                    moveToPurposeSelection();
                  },
                  child: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF34416D),
                  ),
                ),
                Text(
                  'Your BMI: ${bmi.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToPurposeSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurposeSelectionPage(widget.userName, bmi),
      ),
    );
  }
}


class PurposeSelectionPage extends StatefulWidget {
  final String userName;
  final double bmi;

  PurposeSelectionPage(this.userName, this.bmi);

  @override
  _PurposeSelectionPageState createState() => _PurposeSelectionPageState();
}

class _PurposeSelectionPageState extends State<PurposeSelectionPage> {
  String? selectedPurpose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Step'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select Your Purpose',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text('Lose Weight'),
              leading: Radio<String>(
                value: 'Lose Weight',
                groupValue: selectedPurpose,
                onChanged: (value) {
                  setState(() {
                    selectedPurpose = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Maintain Weight'),
              leading: Radio<String>(
                value: 'Maintain Weight',
                groupValue: selectedPurpose,
                onChanged: (value) {
                  setState(() {
                    selectedPurpose = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Gain Weight'),
              leading: Radio<String>(
                value: 'Gain Weight',
                groupValue: selectedPurpose,
                onChanged: (value) {
                  setState(() {
                    selectedPurpose = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedPurpose != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityLevelSelectionPage(
                        userName: widget.userName,
                        selectedPurpose: selectedPurpose!,
                        bmi: widget.bmi,
                      ),
                    ),
                  );
                }
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF34416D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityLevelSelectionPage extends StatefulWidget {
  final String userName;
  final String selectedPurpose;
  final double bmi;

  ActivityLevelSelectionPage({
    required this.userName,
    required this.selectedPurpose,
    required this.bmi,
  });

  @override
  _ActivityLevelSelectionPageState createState() =>
      _ActivityLevelSelectionPageState();
}

class _ActivityLevelSelectionPageState
    extends State<ActivityLevelSelectionPage> {
  String? selectedActivityLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Step'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select Your Activity Level',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text('Sedentary'),
              leading: Radio<String>(
                value: 'Sedentary',
                groupValue: selectedActivityLevel,
                onChanged: (value) {
                  setState(() {
                    selectedActivityLevel = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Lightly Active'),
              leading: Radio<String>(
                value: 'Lightly Active',
                groupValue: selectedActivityLevel,
                onChanged: (value) {
                  setState(() {
                    selectedActivityLevel = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Moderately Active'),
              leading: Radio<String>(
                value: 'Moderately Active',
                groupValue: selectedActivityLevel,
                onChanged: (value) {
                  setState(() {
                    selectedActivityLevel = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Very Active'),
              leading: Radio<String>(
                value: 'Very Active',
                groupValue: selectedActivityLevel,
                onChanged: (value) {
                  setState(() {
                    selectedActivityLevel = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedActivityLevel != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalPage(
                        userName: widget.userName,
                        selectedPurpose: widget.selectedPurpose,
                        bmi: widget.bmi,
                        selectedActivityLevel: selectedActivityLevel!,
                      ),
                    ),
                  );
                }
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF34416D),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class CalorieCalculationPage extends StatefulWidget {
  final String userName;
  final String selectedPurpose;
  final double bmi;
  final String selectedActivityLevel;

  CalorieCalculationPage({
    required this.userName,
    required this.selectedPurpose,
    required this.bmi,
    required this.selectedActivityLevel,
  });

  @override
  _CalorieCalculationPageState createState() => _CalorieCalculationPageState();
}

class _CalorieCalculationPageState extends State<CalorieCalculationPage> {
  double maintenanceCalories = 0.0;

  // Function to calculate maintenance calories based on BMI, purpose, and activity level
  void calculateMaintenanceCalories() {
    if (widget.selectedPurpose == 'Lose Weight') {
      maintenanceCalories = widget.bmi * 22.0 + getActivityLevelCalories();
    } else if (widget.selectedPurpose == 'Maintain Weight') {
      maintenanceCalories = widget.bmi * 25.0 + getActivityLevelCalories();
    } else if (widget.selectedPurpose == 'Gain Weight') {
      maintenanceCalories = widget.bmi * 28.0 + getActivityLevelCalories();
    }
  }

  // Function to get calories based on activity level
  double getActivityLevelCalories() {
    switch (widget.selectedActivityLevel) {
      case 'Sedentary':
        return 200;
      case 'Moderate':
        return 400;
      case 'Active':
        return 600;
      case 'Very Active':
        return 800;
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    calculateMaintenanceCalories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Calculation'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Calories Needed: ${maintenanceCalories.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}

class FinalPage extends StatelessWidget {
  final String userName;
  final String selectedPurpose;
  final double bmi;
  final String selectedActivityLevel;

  FinalPage({
    required this.userName,
    required this.selectedPurpose,
    required this.bmi,
    required this.selectedActivityLevel,
  });

  @override
  Widget build(BuildContext context) {
    double calculatedCalories = calculateCalories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Page'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/back2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              margin: const EdgeInsets.only(top: 60.0), // Adjust the top margin
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.scale_outlined,
                    size: 50,
                    color: Color(0xFF34416D),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Hello, $userName!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your Estimated Daily Caloric Intake:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${calculatedCalories.toStringAsFixed(2)} calories',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'To achieve your $selectedPurpose goal with a BMI of ${bmi.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JourneyPage(
                            userName: userName,
                            calculatedCalories: calculatedCalories,
                          ),
                        ),
                      );
                    },
                    child: Text('Start Your Journey'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF34416D),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double calculateCalories() {
    if (selectedPurpose == 'Lose Weight') {
      return bmi * 22.0 + 1900 + getActivityLevelCalories();
    } else if (selectedPurpose == 'Maintain Weight') {
      return bmi * 25.0 + 1900 + getActivityLevelCalories();
    } else if (selectedPurpose == 'Gain Weight') {
      return bmi * 28.0 + 1900 + getActivityLevelCalories();
    }

    return 0.0;
  }

  double getActivityLevelCalories() {
    switch (selectedActivityLevel) {
      case 'Sedentary':
        return 200;
      case 'Lightly Active':
        return 400;
      case 'Moderately Active':
        return 600;
      case 'Very Active':
        return 800;
      default:
        return 0;
    }
  }
}

class JourneyPage extends StatefulWidget {
  final String userName;
  final double calculatedCalories; // Add this property

  JourneyPage({
    required this.userName,
    required this.calculatedCalories,
  });

  @override
  _JourneyPageState createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  double consumedCalories = 0.0;
  double dailyCalorieGoal = 0.0; // Initialize with 0.0

  @override
  void initState() {
    super.initState();
    // Set the dailyCalorieGoal based on widget.calculatedCalories
    dailyCalorieGoal = widget.calculatedCalories;
    print("JourneyPage initState called");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Journey'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back5.jpg"), // Replace with your image path
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 250.0, bottom: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Logo or icon
                      Icon(
                        Icons.food_bank_outlined,
                        size: 90,
                        color: Color(0xFF34416D),
                      ),
                      // Circular progress indicator
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: dailyCalorieGoal > 0
                            ? CircularProgressIndicator(
                          strokeWidth: 8,
                          value: consumedCalories / dailyCalorieGoal,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF34416D)),
                        )
                            : Container(),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text(
                    '            Hello, ${widget.userName}!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '               Your Daily Caloric Intake:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '  $consumedCalories calories / ${dailyCalorieGoal.toStringAsFixed(2)} calories',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // Navigate to the FoodEntryPage and wait for the result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodEntryPage(dailyCalorieGoal: dailyCalorieGoal),
                        ),
                      );

                      // Check if result is not null and update the consumed calories
                      if (result != null) {
                        setState(() {
                          consumedCalories += result; // Add the calories from the result
                        });
                      }
                    },
                    child: Text('Log Food Intake'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF34416D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BluetoothScanPage extends StatefulWidget {
  @override
  _BluetoothScanPageState createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    await _enableBluetooth();
    await _requestBluetoothPermission();
    _startScanning();
  }

  Future<void> _enableBluetooth() async {
    if (!await flutterBlue.isOn) {
      print('Requesting Bluetooth enable...');
      await FlutterBlue.instance.startScan();
      await FlutterBlue.instance.stopScan();
    }
  }

  Future<void> _requestBluetoothPermission() async {
    var status = await Permission.bluetooth.request();
    if (status.isDenied) {
      print('Bluetooth permission is required to use this feature.');
    }
  }

  void _startScanning() {
    setState(() {
      isScanning = true;
    });

    try {
      flutterBlue.startScan(timeout: Duration(seconds: 120));
      flutterBlue.scanResults.listen((results) {
        if (mounted) {
          setState(() {
            devices = results.map((result) => result.device).toList();
            print('Devices: $devices');
          });
        }
      });
    } catch (e) {
      print('Error starting scan: $e');
    }
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scan'),
      ),
      body: Column(
        children: [
          if (isScanning)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(devices[index].name),
                    subtitle: Text(devices[index].id.toString()),
                    onTap: () {
                      _connectToDevice(context, devices[index]);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _connectToDevice(BuildContext context, BluetoothDevice device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsPage(device: device),
      ),
    );
  }
}

class DeviceDetailsPage extends StatelessWidget {
  final BluetoothDevice device;

  DeviceDetailsPage({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
      ),
      body: Center(
        child: Text('Details for ${device.name}'),
      ),
    );
  }
}

class YourNewPage extends StatelessWidget {
  final List<BluetoothDevice> devices;

  YourNewPage({required this.devices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Found Devices'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].name),
            subtitle: Text(devices[index].id.toString()),
            onTap: () {
              _connectToDevice(context, devices[index]);
            },
          );
        },
      ),
    );
  }

  void _connectToDevice(BuildContext context, BluetoothDevice device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsPage(device: device),
      ),
    );
  }
}


class BluetoothDeviceList extends StatefulWidget {
  @override
  _BluetoothDeviceListState createState() => _BluetoothDeviceListState();
}

class _BluetoothDeviceListState extends State<BluetoothDeviceList> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  void startScanning() {
    flutterBlue.startScan(timeout: Duration(seconds: 120));

    flutterBlue.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          devices = results.map((result) => result.device).toList();
          print('Devices: $devices');
        });
      }
    });
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(devices[index].name),
          subtitle: Text(devices[index].id.toString()),
          onTap: () {
            _connectToDevice(context, devices[index]);
          },
        );
      },
    );
  }

  void _connectToDevice(BuildContext context, BluetoothDevice device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsPage(device: device),
      ),
    );
  }
}




class FoodEntryPage extends StatefulWidget {
  final double dailyCalorieGoal;

  FoodEntryPage({
    required this.dailyCalorieGoal,
  });
  @override
  _FoodEntryPageState createState() => _FoodEntryPageState();
}

class _FoodEntryPageState extends State<FoodEntryPage> {
  StreamSubscription<bool>? scanningSubscription;

  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _weightController = TextEditingController();
  double consumedCalories = 0.0;
  double dailyCalorieGoal = 0.0;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];
  BluetoothState bluetoothState = BluetoothState.unknown;


  @override
  void initState() {
    super.initState();
    dailyCalorieGoal = widget.dailyCalorieGoal;

  }

  @override
  void dispose() {
    _weightController.dispose();
    _foodNameController.dispose();
    _caloriesController.dispose();
    scanningSubscription?.cancel(); // Dispose of the scanning subscription
    flutterBlue.stopScan(); // Stop scanning when the widget is disposed
    super.dispose();
  }
  Future<bool> loadModel() async {
    try {
      // Load the TFLite model
      ByteData modelData = await rootBundle.load('assets/model.tflite');
      List<int> modelBytes = modelData.buffer.asUint8List();

      // Load the labels
      String labels = await rootBundle.loadString('assets/labels.txt');
      List<String> labelList = labels.split('\n');

      // Load the model
      await Tflite.loadModel(
        model: String.fromCharCodes(modelBytes),
        labels: labelList.join(','), // Convert list of labels to a comma-separated string
      );

      return true; // Model loaded successfully
    } catch (e) {
      print("Error loading TFLite model: $e");
      return false; // Model loading failed
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Food Intake'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _foodNameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Calories per 100g'),
            ),
            SizedBox(height: 16),
            // New TextFormField for weight
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight (grams)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_validateForm()) {
                  double caloriesConsumed = calculateCalories();
                  _saveFoodIntake(caloriesConsumed);
                  Navigator.pop(context, caloriesConsumed);
                }
              },
              child: Text('Log Food'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF34416D),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async{
                await LaunchApp.openApp(
                  androidPackageName: 'appinventor.ai_medaliprof.arduino_poids',
                  openStore: false,
                );
              },
              child: Text('Start Bluetooth Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigate to the ReadyFoodListPage and wait for the result
                final selectedFood = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadyFoodListPage(),
                  ),
                );

                // Update the UI with the selected food name and calories
                if (selectedFood != null) {
                  setState(() {
                    _foodNameController.text = selectedFood.name;
                    _caloriesController.text = selectedFood.calories.toString();

                  });
                }
              },
              child: Text('Select from Ready Food List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
        ElevatedButton(
          onPressed: () async{
            await LaunchApp.openApp(
              androidPackageName: 'com.example.fruit_recog_flutter',
              openStore: false,
            );
          },
          child: Text('Capture Food Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black54,
          ),
        ),
          ],
        ),
      ),
      ),
    );
  }

  bool _validateForm() {
    if (_foodNameController.text.isEmpty ||
        _caloriesController.text.isEmpty ||
        _weightController.text.isEmpty) {
      // Show an error message or toast
      return false;
    }
    return true;
  }


  void _saveFoodIntake(double caloriesConsumed) {
    // Add your logic to save the food intake data, update consumedCalories, etc.
    // For example, you might use a database or state management to store the data.
    setState(() {
      consumedCalories += caloriesConsumed;
    });
  }
  void _openBluetoothSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BluetoothScanPage(),
      ),
    );
  }






  double calculateCalories() {
    // Validate that the caloriesController and weightController texts are not empty
    if (_caloriesController.text.isEmpty || _weightController.text.isEmpty) {
      // Show an error message or handle it as needed
      return 0.0; // Return a default value
    }

    // Parse the calories and weight only if the texts are valid doubles
    double calories, weight;
    try {
      calories = double.parse(_caloriesController.text);
      weight = double.parse(_weightController.text);
    } catch (e) {
      // Show an error message or handle it as needed
      return 0.0; // Return a default value
    }

    // Multiply the calories by the weight divided by 100
    return (calories * weight) / 100.0;
  }
}
// Define the FoodItem class
class FoodItem {
  final String name;
  final int calories;

  FoodItem(this.name, this.calories);
}
class ReadyFoodListPage extends StatefulWidget {
  @override
  _ReadyFoodListPageState createState() => _ReadyFoodListPageState();
}
class _ReadyFoodListPageState extends State<ReadyFoodListPage> {
  final List<FoodItem> readyFoodList = [
    FoodItem('Salad', 100),
    FoodItem('Grilled Chicken', 100),
    FoodItem('Fruit Smoothie', 100),
    FoodItem('Apple', 95),
    FoodItem('Banana', 105),
    FoodItem('Orange', 43),
    FoodItem('Strawberries (1 cup)', 32),
    FoodItem('Blueberries (1 cup)', 57),
    FoodItem('Chicken Breast (100g)', 165),
    FoodItem('Salmon (100g)', 206),
    FoodItem('Broccoli (1 cup, cooked)', 55),
    FoodItem('Quinoa (1 cup, cooked)', 120),
    FoodItem('Brown Rice (1 cup, cooked)', 215),
    FoodItem('Oats (1 cup, cooked)', 145),
    FoodItem('Almonds (100g)', 576),
    FoodItem('Greek Yogurt (100g)', 59),
    FoodItem('Egg (1 large, boiled)', 68),
    FoodItem('Whole Wheat Bread (1 slice)', 69),
    FoodItem('Avocado (100g)', 160),
    FoodItem('Carrot (100g)', 41),
    FoodItem('Spinach (1 cup, raw)', 23),
    FoodItem('Sweet Potato (100g, baked)', 86),
    FoodItem('Tomato (100g)', 18),
    FoodItem('Cheese (100g)', 402),
    FoodItem('Pasta (1 cup, cooked)', 200),
    FoodItem('Milk (1 cup)', 61),
    FoodItem('Coffee (8 oz)', 2),
    FoodItem('Dark Chocolate (100g)', 546),
    FoodItem('Pizza Slice (1 slice)', 285),
    FoodItem('Ice Cream (100g)', 207),
    FoodItem('Hamburger', 250),
    FoodItem('French Fries (100g)', 365),
    FoodItem('Hot Dog', 150),
    FoodItem('Grilled Cheese Sandwich', 360),
    FoodItem('Caesar Salad', 150),
    FoodItem('Coca-Cola (12 oz)', 140),
    FoodItem('Orange Juice (8 oz)', 110),
    FoodItem('Cupcake', 384),
    FoodItem('Cheeseburger', 300),
    FoodItem('Chicken Nuggets (100g)', 290),
    FoodItem('Spaghetti Bolognese (1 cup)', 300),
    FoodItem('Sushi Roll', 200),
    FoodItem('Peanut Butter (100g)', 588),
    FoodItem('Honey (1 tbsp)', 64),
    FoodItem('Granola (100g)', 471),
    FoodItem('Bacon (100g)', 42),
    FoodItem('Fried Rice (1 cup)', 235),
    FoodItem('Soda Crackers (100g)', 502),
    FoodItem('Pancakes (100g)', 227),
    FoodItem('Maple Syrup (1/4 cup)', 210),
    FoodItem('Chicken Caesar Wrap', 480),
    FoodItem('Beef Burrito', 400),
    FoodItem('Tuna Salad (1 cup)', 200),
    FoodItem('Mango (100g)', 60),
    FoodItem('Pineapple (1 cup)', 82),
    FoodItem('Raspberry (1 cup)', 65),
    FoodItem('Peach (100g)', 39),
    FoodItem('Cucumber (100g)', 45),
    FoodItem('Red Wine (5 oz)', 85),
    FoodItem('White Wine (5 oz)', 82),
    FoodItem('Beer (12 oz)', 43),
    FoodItem('Salami (100g)', 336),
    FoodItem('Vanilla Ice Cream (100g)', 207),
    FoodItem('Peanuts (100g)', 567),
    FoodItem('Popcorn (100g, air-popped)', 387),
    FoodItem('Cheetos (100g)', 509),
    FoodItem('Grapes (1 cup)', 69),
    FoodItem('Watermelon (1 cup)', 30),
    FoodItem('Chocolate Chip Cookie', 502),
    FoodItem('Pretzels (100g)', 385),
    FoodItem('Shrimp (100g, cooked)', 99),
    FoodItem('Lobster (100g, cooked)', 83),
    FoodItem('Crab (100g, cooked)', 83),
    FoodItem('Clams (100g, cooked)', 126),
    FoodItem('Mussels (100g, cooked)', 172),
    FoodItem('Oysters (100g, cooked)', 68),
    FoodItem('Lentils (1 cup, cooked)', 116),
    FoodItem('Chickpeas (1 cup, cooked)', 164),
    FoodItem('Black Beans (1 cup, cooked)', 133),
    FoodItem('Kidney Beans (1 cup, cooked)', 127),
    FoodItem('Pinto Beans (1 cup, cooked)', 143),
    FoodItem('Tofu (100g)', 144),
    FoodItem('Soy Milk (1 cup)', 33),
    FoodItem('Beef Steak (100g, cooked)', 250),
    FoodItem('Pork Chop (100g, cooked)', 143),
    FoodItem('Lamb Chop (100g, cooked)', 250),
    FoodItem('Baked Beans (1 cup, canned)', 155),
    FoodItem('Corn on the Cob (100g)', 86),
    FoodItem('Eggplant (1 cup, cooked)', 35),
    FoodItem('Pumpkin (1 cup, cooked)', 20),
    FoodItem('Zucchini (1 cup, cooked)', 20),
    FoodItem('Potato (100g, baked)', 93),
    FoodItem('Onion (100g)', 40),
    FoodItem('Cabbage (1 cup, cooked)', 23),
    FoodItem('Bell Pepper (100g)', 20),
    FoodItem('Asparagus (1 cup, cooked)', 20),
    FoodItem('Cauliflower (1 cup, cooked)', 25),
    FoodItem('Rice Krispies Cereal (1 cup)', 101),
    FoodItem('Cheerios Cereal (1 cup)', 117),
    FoodItem('Cornflakes Cereal (1 cup)', 100),
    FoodItem('Raisin Bran Cereal (1 cup)', 190),
    FoodItem('Oatmeal (1 cup, cooked)', 143),
    FoodItem('Skim Milk (1 cup)', 34),
    FoodItem('Whole Milk (1 cup)', 61),
    FoodItem('Cottage Cheese (100g)', 98),
    FoodItem('American Cheese (100g)', 371),
    FoodItem('Swiss Cheese (100g)', 380),
    FoodItem('Cheddar Cheese (100g)', 406),
    FoodItem('Mozzarella Cheese (100g)', 300),
    FoodItem('Yogurt (100g, plain)', 61),
    FoodItem('Butter (100g)', 717),
    FoodItem('Olive Oil (1 tbsp)', 119),
    FoodItem('Ketchup (1 tbsp)', 101),
    FoodItem('Mayonnaise (1 tbsp)', 94),
    FoodItem('Mustard (1 tbsp)', 66),
    FoodItem('Soy Sauce (1 tbsp)', 8),
    FoodItem('Barbecue Sauce (1 tbsp)', 101),
    FoodItem('Peanut Oil (1 tbsp)', 119),
    FoodItem('Canola Oil (1 tbsp)', 124),
    FoodItem('Chocolate Milk (1 cup)', 87),
    FoodItem('Red Bull (8.4 oz)', 131),
    FoodItem('Green Tea (8 oz)', 2),
    FoodItem('Black Coffee (8 oz)', 0),
    FoodItem('Latte (12 oz)', 125),
    FoodItem('Mocha (12 oz)', 242),
    FoodItem('Espresso (1 oz)', 2),
    FoodItem('Cappuccino (12 oz)', 67),
    FoodItem('Hot Chocolate (12 oz)', 171),
    FoodItem('Whiskey (1.5 oz)', 70),
    FoodItem('Vodka (1.5 oz)', 231),
    FoodItem('Rum (1.5 oz)', 231),
    FoodItem('Tequila (1.5 oz)', 231),
    FoodItem('Gin (1.5 oz)', 231),
    FoodItem('Wine Cooler (12 oz)', 167),
    FoodItem('Martini (2.5 oz)', 64),
    FoodItem('Margarita (8 oz)', 455),
    FoodItem('Cosmopolitan (3 oz)', 146),
    FoodItem('Pina Colada (6 oz)', 327),
    FoodItem('Mai Tai (6 oz)', 350),
    FoodItem('Long Island Iced Tea (8 oz)', 320),
    FoodItem('Whopper Sandwich', 257),
    FoodItem('Big Mac', 229),
    FoodItem('Chicken Quesadilla', 340),
    FoodItem('Taco Salad', 300),
    FoodItem('Chicken Wrap', 150),
    FoodItem('Veggie Burger', 150),
    FoodItem('Lettuce (1 cup, shredded)', 5),
    FoodItem('Cranberry Juice (8 oz)', 46),
    FoodItem('Gin and Tonic (8 oz)', 123),
    FoodItem('Mint Julep (8 oz)', 225),
    FoodItem('Bloody Mary (8 oz)', 150),
    FoodItem('Caipirinha (8 oz)', 275),
    FoodItem('Tom Collins (8 oz)', 150),
    FoodItem('Negroni (8 oz)', 210),
    FoodItem('Mule Cocktail (8 oz)', 225),
    FoodItem('Mai Tai Cocktail (8 oz)', 325),
    FoodItem('Pomegranate Martini (8 oz)', 280),
    FoodItem('Water', 0),

  ];

  late List<FoodItem> filteredFoodList;

  @override
  void initState() {
    super.initState();
    filteredFoodList = readyFoodList;
  }

  void filterFoodList(String query) {
    setState(() {
      filteredFoodList = readyFoodList
          .where((food) =>
          food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ready Food List'),
        backgroundColor: Color(0xFF34416D),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => filterFoodList(query),
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for food...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFoodList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredFoodList[index].name),
                  subtitle: Text('${filteredFoodList[index].calories} calories'),
                  onTap: () {
                    // Pass both the name and calories back to the FoodEntryPage
                    Navigator.pop(
                      context,
                      FoodItem(
                        filteredFoodList[index].name,
                        filteredFoodList[index].calories,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}