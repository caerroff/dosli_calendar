import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class EventCreatePage extends StatefulWidget {
  @override
  _EventCreatePageState createState() => _EventCreatePageState();
}

class _EventCreatePageState extends State<EventCreatePage> {
  final _formKey = GlobalKey<FormState>();
  Database? db;
  
  final TextEditingController _eventNameController = TextEditingController();
  DateTime _eventDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();
  }

  Future<Database> getDb() async {
    if (this.db != null) {
      return Future<Database>.value(this.db);
    }
    final db = await openDatabase('events.db', version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(
        'CREATE TABLE events (id INTEGER PRIMARY KEY, name TEXT, date DATETIME)');
  });
    return db;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CalendarDatePicker(
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
                onDateChanged:(value) => setState(() => _eventDate = value),
              ),
              const SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform event creation logic here
                    String eventName = _eventNameController.text;
                    //FIXME: This is a hack to convert the string to a DateTime object
                    DateTime eventDate = _eventDate;
                    // Call a function to create the event with the provided data
                    createEvent(eventName, eventDate);
                  }
                },
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createEvent(String eventName, DateTime eventDate) {
    // Implement your event creation logic here
    // This function will be called when the form is submitted
    // You can use the provided event name and event date to create the event
    // For now, we will just print the event name and event date
    print('Event Name: $eventName');
    print('Event Date: $eventDate');
    // Save it to sqlite using sqflite
    // Implement saving
    getDb().then((db) {
      db.execute(
        "INSERT INTO events (name, date) VALUES ('$eventName', '${eventDate.toLocal().toString().replaceAll('Z', '')}')"
      );
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event added'),
      ),
    );
    // And then return to the main page
    Navigator.pop(context);
  }
}