import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:together/components/appbar.dart';
import 'package:together/components/snack_bar.dart';
import 'package:together/screens/publish_event/publish_event_third_screen.dart';
import 'package:together/utils/colors.dart';

class PublishEventSecondScreen extends StatefulWidget {
  PublishEventSecondScreen(
      {Key? key,
      required this.eventName,
      required this.description,
      required this.startDate,
      required this.endDate})
      : super(key: key);
  String eventName;
  String description;
  DateTime startDate;
  DateTime endDate;
  @override
  State<PublishEventSecondScreen> createState() =>
      _PublishEventSecondScreenState();
}

class _PublishEventSecondScreenState extends State<PublishEventSecondScreen> {
  List<Map<String, dynamic>> tickets = [
    {'ticket_id': 1, 'name': '', 'price': '0.00'}
  ];

  bool emptyFields = false;

  bool validate() {
    setState(() {});
    for (int i = 0; i < tickets.length; i++) {
      if (tickets[i]['name'] == '' ||
          tickets[i]['price'] == '0.00' ||
          tickets[i]['price'] == '') {
        emptyFields = true;
      }
    }
    return emptyFields;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: myAppBar(context, true),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              width: width,
              child: Text(
                'Tell us about Ticket Prices...',
                textAlign: TextAlign.center,
                style: messagePreviewTextStyle(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    return PriceHolder(index);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 2, color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            setState(() {
                              var ticket = {
                                'ticket_id': tickets.last['ticket_id'] + 1,
                                'name': '',
                                'price': '0.00'
                              };
                              tickets.add(ticket);
                            });
                          },
                          child: Text(
                            'Add more Tickets',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppColor.primaryColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 2, color: AppColor.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            print(!validate());
                            emptyFields = false;
                            if (!validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PublishEventThirdScreen(
                                              description: widget.description,
                                              eventName: widget.eventName,
                                              startDate: widget.startDate,
                                              endDate: widget.endDate,
                                              tickets: tickets)));
                            } else {
                              ShowSnackBar snackBar = ShowSnackBar();
                              snackBar.showSnackaBar(
                                  context, 'Fields cannot be empty');
                            }
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container PriceHolder(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          textField(
              Icons.local_activity, 'Name', 1, index, true, TextInputType.name),
          const SizedBox(
            height: 10.0,
          ),
          textField(
              Icons.local_atm, 'Price', 1, index, false, TextInputType.number),
        ],
      ),
    );
  }

  Widget textField(IconData icon, String hintText, int maxLines, int index,
      bool isName, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        keyboardType: keyboardType,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (isName) {
            tickets[index]['name'] = value;
          } else {
            tickets[index]['price'] = double.parse(value).toStringAsFixed(2);
          }
          print(tickets);
        },
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
          prefixText: !isName ? 'Rs. ' : '',
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 18.0,
            //color: AppColor.primaryColor,
          ),
        ),
        maxLines: maxLines,
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
