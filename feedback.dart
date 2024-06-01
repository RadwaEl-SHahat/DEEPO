import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ids_deepo/screens/helpAndSupport.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  SingingCharacter? _selectedCharacter;

  TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpAndSupport()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        leadingWidth: 70,
        title: Text(
          'Feedback',
          style: GoogleFonts.robotoCondensed(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Image.asset('assets/logo.png', height: 60, width: 60),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            RadioExample(
              selectedCharacter: _selectedCharacter,
              onChanged: (character) {
                setState(() {
                  _selectedCharacter = character;
                });
              },
            ),
            if (_selectedCharacter == SingingCharacter.other)
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    labelText: 'Additional Feedback',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            SizedBox(height: 20), // Adjust spacing between the text field and the button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality for sending feedback
                },
                child: Text('Send Feedback',
                 style: GoogleFonts.robotoCondensed(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,),),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 0),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Colors.indigo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SingingCharacter { x, y, z, a, b, other }

class RadioExample extends StatelessWidget {
  final SingingCharacter? selectedCharacter;
  final ValueChanged<SingingCharacter?>? onChanged;

  const RadioExample({
    Key? key,
    this.selectedCharacter,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 17.0),
          child: ListTile(
            title: const Text('The app is slowing down my device'),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.x,
              groupValue: selectedCharacter,
              onChanged: onChanged,
            ),
          ),
        ),
        ListTile(
          title: const Text("Working well"),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.y,
            groupValue: selectedCharacter,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          title: const Text('Consuming battery more than normal'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.z,
            groupValue: selectedCharacter,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          title: const Text("Don't detect well"),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.a,
            groupValue: selectedCharacter,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          title: const Text('Other'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.other,
            groupValue: selectedCharacter,
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: 40,),
      ],
    );
  }
}


