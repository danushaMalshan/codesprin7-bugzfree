import 'package:flutter/material.dart';
import 'package:together/components/appbar.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({Key? key}) : super(key: key);

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  int priceHolders = 1;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: myAppBar(),
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
                  itemCount: priceHolders,
                  itemBuilder: (context, index) {
                    return PriceHolder();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF142867),
                  ),
                  onPressed: () {
                    setState(() {
                      priceHolders += 1;
                    });
                  },
                  child: Text(
                    'Add more Tickets',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container PriceHolder() {
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
          textField(Icons.local_activity, 'Status', 1),
          const SizedBox(
            height: 10.0,
          ),
          textField(Icons.local_atm, 'Price', 1),
        ],
      ),
    );
  }
}

Widget textField(IconData icon, String hintText, int maxLines) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: TextField(
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: const Color(0xff142867),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xff142867),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xff142867),
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18.0,
          //color: Color(0xff142867),
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
    color: Color(0xff142867),
  );
}
