import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  bool isNameSet = false; // Track if name has been set
  
  // Text controller for name input
  TextEditingController nameController = TextEditingController();
  
  // Timer for automatic hunger increase
  Timer? hungerTimer;

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

  // Simple function to get pet color based on happiness
  Color getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green; // Happy
    } else if (happinessLevel >= 30) {
      return Colors.yellow; // Neutral
    } else {
      return Colors.red; // Unhappy
    }
  }

  // Simple function to get mood text and emoji
  String getMoodText() {
    if (happinessLevel > 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😢";
    }
  }

  // Simple function to change pet name
  void _changePetName() {
    setState(() {
      if (nameController.text.isNotEmpty) {
        petName = nameController.text;
        isNameSet = true; // Mark name as set
        nameController.clear(); // Clear the input field
      }
    });
  }

  // Simple function to automatically increase hunger
  void _autoIncreaseHunger() {
    setState(() {
      hungerLevel += 5; // Increase hunger by 5 every 30 seconds
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 10; // Pet gets unhappy if too hungry
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Start timer when app starts
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _autoIncreaseHunger();
    });
  }

  @override
  void dispose() {
    // Stop timer when app closes
    hungerTimer?.cancel();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getPetColor(), // Background changes with mood
      appBar: AppBar(
        title: Text('Digital Pet'),
        backgroundColor: getPetColor().withOpacity(0.8), // AppBar matches background
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 8.0),
            // Name Input Field (only show if name not set)
            if (!isNameSet) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter pet name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _changePetName,
                    child: Text('Set Name'),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
            ],
            // Mood Indicator
            Text(
              'Mood: ${getMoodText()}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            // Pet Image
            Image.asset(
              'assets/images/pet.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
