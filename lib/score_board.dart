import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conclave/custom/spacers.dart';
import 'package:flutter/material.dart';

import 'services/storage_services.dart';

class ScoreBoard extends StatefulWidget {
  final int score;
  final String quiz;
  const ScoreBoard({super.key, required this.score, required this.quiz});
  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  Future<void> addViewToFeatures() async {
    final pf = await LocalStorageService().loadData('Pfnum') ?? '';
    final name = await LocalStorageService().loadData('name') ?? '';
    final docRef = FirebaseFirestore.instance
        .collection('conclaveQuizAnswer')
        .doc(widget.quiz);

    // Create the map for the view
    final view = {
      'empid': pf,
      'name': name,
      'score': (widget.score).toString(),
      'time': DateTime.now()
    };

    print("--------------->");

    // Update the document with the new view
    await docRef.update({
      'users': FieldValue.arrayUnion([view]), // Add the view to the array
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    addViewToFeatures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            VerticalSpacer(height: 40),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: Text('You scored ${widget.score} points'),
            ),
          ],
        ),
      ),
    );
  }
}
