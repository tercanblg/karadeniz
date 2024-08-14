import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Region Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,  // Correctly placed inside MaterialApp
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Region Cards'),
        ),
        body: const RegionsList(),
      ),
    );
  }
}

class RegionsList extends StatelessWidget {
  const RegionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 21, // Number of regions
      itemBuilder: (context, index) {
        final imageIndex = index + 1;
        return RegionCard(
          imagePath: 'assets/1 ($imageIndex).jpg', // Images named as 1 (1).jpg, 1 (2).jpg, etc.
          regionName: 'KPS ${imageIndex} Gökhan Bey', // Naming convention based on the provided example
          lastUpdate: index % 2 == 0, // Alternating true/false for demonstration
        );
      },
    );
  }
}

class RegionCard extends StatelessWidget {
  final String imagePath;
  final String regionName;
  final bool lastUpdate;

  const RegionCard({
    Key? key,
    required this.imagePath,
    required this.regionName,
    required this.lastUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.green, width: 2), // Green border
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150, // Adjust the height as necessary
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
                        children: const [
                          Text('Gross'),
                          Text('Net'),
                          Text('Working Engines'),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        lastUpdate ? 'Updated Recently' : 'Update Needed',
                        style: TextStyle(
                          fontSize: 12,
                          color: lastUpdate ? Colors.green : Colors.red,
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
