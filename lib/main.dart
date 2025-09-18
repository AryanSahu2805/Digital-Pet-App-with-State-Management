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

  String gameMessage = ""; // For Win/Loss messages
  Timer? hungerTimer;
  Timer? winTimer;

  // Text controller for name input
  TextEditingController nameController = TextEditingController();

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      if (happinessLevel > 100) happinessLevel = 100;
      _updateHunger();
      _checkConditions();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      if (hungerLevel < 0) hungerLevel = 0;
      _updateHappiness();
      _checkConditions();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
    if (happinessLevel > 100) happinessLevel = 100;
    if (happinessLevel < 0) happinessLevel = 0;
  }

  void _updateHunger() {
    hungerLevel += 5;
    if (hungerLevel > 100) hungerLevel = 100;
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

  // Automatically increase hunger
  void _autoIncreaseHunger() {
    setState(() {
      hungerLevel += 5; // Increase hunger by 5 every 30 seconds
      if (hungerLevel > 100) hungerLevel = 100;
      if (hungerLevel > 100) hungerLevel = 100;
      _checkConditions();
    });
  }

  // Check Win/Loss conditions
  void _checkConditions() {
    // Loss condition
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      setState(() {
        gameMessage = "💀 Game Over! Your pet was too hungry and unhappy.";
      });
      hungerTimer?.cancel();
      winTimer?.cancel();
    }

    // Start/Reset win timer if happiness > 80
    if (happinessLevel > 80) {
      winTimer?.cancel(); // reset if already running
      winTimer = Timer(Duration(minutes: 3), () {
        setState(() {
          gameMessage = "🎉 You Win! Your pet stayed happy for 3 minutes!";
        });
        hungerTimer?.cancel();
      });
    } else {
      winTimer?.cancel(); // stop win timer if happiness drops
    }
  }

  @override
  void initState() {
    super.initState();
    // Start hunger timer
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _autoIncreaseHunger();
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winTimer?.cancel();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getPetColor(),
      appBar: AppBar(
        title: Text('Digital Pet'),
        backgroundColor: getPetColor().withOpacity(0.8),
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
            Text(
              'Mood: ${getMoodText()}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
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
              onPressed: gameMessage.isEmpty ? _playWithPet : null,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: gameMessage.isEmpty ? _feedPet : null,
              child: Text('Feed Your Pet'),
            ),
            SizedBox(height: 32.0),
            Text(
              'ℹ️ Hunger increases automatically every 30 seconds!',
              style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16.0),
            if (gameMessage.isNotEmpty)
              Text(
                gameMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
