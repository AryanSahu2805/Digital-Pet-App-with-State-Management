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
  int energyLevel = 70; // ✅ Energy Level
  bool isNameSet = false;

  String gameMessage = "";
  Timer? hungerTimer;
  Timer? winTimer;

  TextEditingController nameController = TextEditingController();

  // ✅ Activity Selection State
  String selectedActivity = "Play"; 
  final List<String> activities = ["Play", "Feed", "Rest"];

  void _performActivity() {
    if (selectedActivity == "Play") {
      _playWithPet();
    } else if (selectedActivity == "Feed") {
      _feedPet();
    } else if (selectedActivity == "Rest") {
      _restPet();
    }
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      if (happinessLevel > 100) happinessLevel = 100;

      energyLevel -= 10; // Playing reduces energy
      if (energyLevel < 0) energyLevel = 0;

      _updateHunger();
      _checkConditions();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      if (hungerLevel < 0) hungerLevel = 0;

      energyLevel += 5; // Feeding restores some energy
      if (energyLevel > 100) energyLevel = 100;

      _updateHappiness();
      _checkConditions();
    });
  }

  // ✅ New Rest Activity
  void _restPet() {
    setState(() {
      energyLevel += 15; // Rest restores energy
      if (energyLevel > 100) energyLevel = 100;

      happinessLevel -= 5; // Resting may reduce fun
      if (happinessLevel < 0) happinessLevel = 0;

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

  Color getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String getMoodText() {
    if (happinessLevel > 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Unhappy 😢";
    }
  }

  void _changePetName() {
    setState(() {
      if (nameController.text.isNotEmpty) {
        petName = nameController.text;
        isNameSet = true;
        nameController.clear();
      }
    });
  }

  void _autoIncreaseHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) hungerLevel = 100;
      _checkConditions();
    });
  }

  void _checkConditions() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      setState(() {
        gameMessage = "💀 Game Over! Your pet was too hungry and unhappy.";
      });
      hungerTimer?.cancel();
      winTimer?.cancel();
    }

    if (happinessLevel > 80) {
      winTimer?.cancel();
      winTimer = Timer(Duration(minutes: 3), () {
        setState(() {
          gameMessage = "🎉 You Win! Your pet stayed happy for 3 minutes!";
        });
        hungerTimer?.cancel();
      });
    } else {
      winTimer?.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
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
            SizedBox(height: 16.0),
            Text(
              'Energy Level:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
              child: LinearProgressIndicator(
                value: energyLevel / 100,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                minHeight: 15,
              ),
            ),
            Text(
              '$energyLevel / 100',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 32.0),

            // ✅ Activity Selection
            Text(
              'Choose an Activity:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedActivity,
              items: activities.map((String activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: gameMessage.isEmpty ? _performActivity : null,
              child: Text('Do Activity'),
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
