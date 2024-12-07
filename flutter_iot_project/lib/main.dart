import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {
  late Socket socket;
  final TextEditingController ipController =
      TextEditingController(text: '192.168.4.1');
  final TextEditingController portController =
      TextEditingController(text: '1234');
  bool isConnected = false;

  void send(String c) {
    if (isConnected) {
      socket.add(utf8.encode(c));
    } else {
      print("Not connected");
    }
  }

  void connect() async {
    try {
      socket = await Socket.connect(
          ipController.text, int.parse(portController.text));
      isConnected = true;
      print("Connected to socket!");
    } catch (e) {
      print("Error: $e");
      isConnected = false;
    }
  }

  Widget fancyButton(IconData icon, Color color, String command) {
    return GestureDetector(
      onLongPress: () {
        send(command); // Send command while holding the button
      },
      onLongPressEnd: (_) {
        send('none\n'); // Stop the motor when released
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30), right: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          side: BorderSide(color: Colors.black, width: 3), // Black border
        ),
        onPressed: () {
          send('none\n'); // Send the command once when tapped
        },
        child: Icon(icon, size: 36),
      ),
    );
  }

  Widget fancyHonkButton(String label, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        padding: const EdgeInsets.all(20),
        side: BorderSide(color: Colors.black, width: 3), // Black border
      ),
      onPressed: () {
        send(label);
      },
      child: Icon(icon, size: 36),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RC Car Controller',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            const Color.fromARGB(255, 213, 208, 221).withOpacity(0.8),
        centerTitle: true,
        elevation: 10, // Fancy border effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 252, 80, 0),
                const Color.fromARGB(255, 226, 149, 113),
                const Color.fromARGB(255, 252, 80, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 204, 185, 12),
              const Color.fromARGB(255, 202, 193, 118),
              const Color.fromARGB(255, 204, 185, 12)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Main controls
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Top padding
                fancyButton(Icons.arrow_upward, Colors.green, 'forward\n'),
                const SizedBox(height: 20), // Spacing between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fancyButton(Icons.arrow_back, Colors.blue, 'left\n'),
                    const SizedBox(width: 20), // Space between Left and Honk
                    fancyHonkButton('Honk', Icons.volume_up),
                    const SizedBox(width: 20), // Space between Honk and Right
                    fancyButton(Icons.arrow_forward, Colors.teal, 'right\n'),
                  ],
                ),
                const SizedBox(height: 20), // Spacing between rows
                fancyButton(Icons.arrow_downward, Colors.orange, 'reverse\n'),
              ],
            ),
            // IP and Port input
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                      labelText: 'IP Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10), // Spacing between text fields
                  TextField(
                    controller: portController,
                    decoration: InputDecoration(
                      labelText: 'Port',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            // Connection status
            Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                  color: isConnected ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold), // Make the text bold
            ),
            // Connect button at the bottom
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 30.0), // Padding from bottom
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  side:
                      BorderSide(color: Colors.black, width: 3), // Black border
                ),
                onPressed: connect,
                child: Text('Connect', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
