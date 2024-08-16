import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Region Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RegionsList()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash.png'), // Your splash screen image
      ),
    );
  }
}

class RegionsList extends StatelessWidget {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child('regions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Region Cards'),
      ),
      body: StreamBuilder(
        stream: _databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError && snapshot.data?.snapshot.value != null) {
            Object? data = snapshot.data!.snapshot.value;
            List regions = data!.values.toList();
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: regions.length,
              itemBuilder: (context, index) {
                final region = regions[index];
                final bool lastUpdate = DateTime.now().difference(DateTime.parse(region['lastUpdate'])).inDays < 7;

                return RegionCard(
                  imagePath: region['imagePath'],
                  regionName: region['regionName'],
                  gross: region['gross'],
                  net: region['net'],
                  workingEngines: region['workingEngines'],
                  lastUpdate: region['lastUpdate'],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

extension on Object {
  get values => null;
}

class RegionCard extends StatelessWidget {
  final String imagePath;
  final String regionName;
  final int gross;
  final int net;
  final int workingEngines;
  final String lastUpdate;

  RegionCard({
    required this.imagePath,
    required this.regionName,
    required this.gross,
    required this.net,
    required this.workingEngines,
    required this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.green, width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  regionName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gross: $gross'),
                          Text('Net: $net'),
                          Text('Working Engines: $workingEngines'),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Last Update: $lastUpdate',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
