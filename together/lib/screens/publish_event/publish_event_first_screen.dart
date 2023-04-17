import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/screens/publish_event/publish_event_second_screen.dart';
import 'package:together/utils/colors.dart';
import '../../components/appbar.dart';

class PublishEventFirstScreen extends StatefulWidget {
  const PublishEventFirstScreen({Key? key}) : super(key: key);

  @override
  State<PublishEventFirstScreen> createState() =>
      _PublishEventFirstScreenState();
}

class _PublishEventFirstScreenState extends State<PublishEventFirstScreen> {
  TextEditingController _ctrlName = TextEditingController();
  TextEditingController _ctrlDescription = TextEditingController();
  TextEditingController _ctrlStartDate = TextEditingController();
  TextEditingController _ctrlEndDate = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime? startDateTime;
  DateTime? endDateTime;
  ShowSnackBar snackBar = ShowSnackBar();
  bool loading = false;

  FirebaseAuth? _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future pickDateTime(BuildContext context, int status) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      if (status == 0) {
        startDateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        _ctrlStartDate.text =
            DateFormat('yyyy-MM-dd HH:mm').format(startDateTime!);
      } else if (status == 1) {
        endDateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        _ctrlEndDate.text = DateFormat('yyyy-MM-dd HH:mm').format(endDateTime!);
      }
    });
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
        context: context,
        initialTime: startDateTime != null
            ? TimeOfDay(
                hour: startDateTime!.hour, minute: startDateTime!.minute)
            : initialTime);
    if (newTime == null) return null;

    return newTime;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: myAppBar(context, true),
      body: loading
          ? Center(
              child: SpinKitWave(
                color: AppColor.primaryColor,
                size: 50,
              ),
            )
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Title(width),
                    textField(Icons.festival_outlined, 'Name of the Event', 1,
                        _ctrlName),
                    textField(
                        Icons.description, 'Description', 4, _ctrlDescription),
                    textFieldWithButtons(Icons.edit_calendar,
                        'Start Date & Time', _ctrlStartDate, 0),
                    textFieldWithButtons(Icons.edit_calendar, 'End Date & Time',
                        _ctrlEndDate, 1),
                    nextButton(context),
                  ],
                ),
              ),
            ),
    );
  }

  Padding nextButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 60.0),
      child: SizedBox(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: AppColor.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
            

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PublishEventSecondScreen(
                            description: _ctrlDescription.text,
                            eventName: _ctrlName.text,
                            startDate: startDateTime!,
                            endDate: endDateTime!,
                          )));
            }
          },
          child: const Text('Next'),
        ),
      ),
    );
  }

  Container Title(double width) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'It\'s good to see you as a Organizer!',
            style: messagePreviewTextStyle(),
          ),
          Text(
            'Tell us about your Event',
            style: messagePreviewTextStyle(),
          ),
        ],
      ),
    );
  }

  Widget textField(IconData icon, String hintText, int maxLines,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 25.0,
        right: 25.0,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: AppColor.primaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              width: 2,
              color: AppColor.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              width: 2,
              color: AppColor.primaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 18.0,
            //color: AppColor.primaryColor,
          ),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value!.isEmpty) {
            return "$hintText Cannot be Empty";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget textFieldWithButtons(IconData icon, String hintText,
      TextEditingController controller, int status) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 25.0,
        right: 25.0,
      ),
      child: TextFormField(
        onTap: () async {
          await pickDateTime(context, status);
        },
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: AppColor.primaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              width: 2,
              color: AppColor.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              width: 2,
              color: AppColor.primaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 18.0,
            //color: AppColor.primaryColor,
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "$hintText Cannot be Empty";
          } else {
            return null;
          }
        },
      ),
    );
  }

  TextStyle messagePreviewTextStyle() {
    return const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: AppColor.primaryColor,
    );
  }
}
