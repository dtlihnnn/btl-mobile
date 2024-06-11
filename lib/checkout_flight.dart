import 'package:btl_mobile/success_booking_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:dotted_line/dotted_line.dart';
class Checkout_Flight extends StatelessWidget {
  final Map<String, dynamic> flightData;

  Checkout_Flight({required this.flightData});
  Future<void> saveBookingToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }
    String userId = user.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference bookings = firestore.collection('users').doc(userId).collection('flight_bookings');

    Map<String, dynamic> bookingData = {
      'origin': flightData['origin'],
      'destination': flightData['destination'],
      'departure_time': flightData['departure_time'],
      'total_price': flightData['price'],
      'timestamp': FieldValue.serverTimestamp(),
      'user_id': userId,
    };

    try {
      await bookings.add(bookingData);
      print('Booking added to Firestore');
    } catch (e) {
      print('Error adding booking: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child:Text('Confirm'),
          ),
        ),
        body: MultiStepForm(

          flightData: flightData,
        ),
      ),
    );
  }
}

class MultiStepForm extends StatefulWidget {
  final Map<String, dynamic> flightData;
  MultiStepForm({required this.flightData});
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 2;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  void _resetForm() {
    setState(() {
      _formKey1.currentState!.reset();
      _formKey2.currentState!.reset();
      _currentStep = 0;
    });
  }

  final Map<String, String> countryAbbreviations = {
    'Viet Nam': 'VN',
    'Han Quoc': 'KR',
    'Nhat Ban': 'JP',
    'Hoa Ky': 'US',
    'Trung Quoc': 'CN',
    'Nga': 'RUS',
    'Thai Lan': 'Thai',
    'Malaysia': 'MLS',
    'Campuchia': 'Cam',
    'Lao': 'Lao',
  };
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String originAbbr = countryAbbreviations[widget.flightData['origin']] ?? '';
    String destinationAbbr =
        countryAbbreviations[widget.flightData['destination']] ?? '';

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.grey.shade200,
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) {
          if (step > _currentStep) {
            setState(() => _currentStep = step);
          }
        },
        onStepContinue: _currentStep < 2
            ? () {
                if (_currentStep == 0 && _formKey1.currentState!.validate()) {
                  _formKey1.currentState!.save();
                  setState(() => _currentStep += 1);
                } else if (_currentStep == 1 &&
                    _formKey2.currentState!.validate()) {
                  _formKey2.currentState!.save();
                  setState(() => _currentStep += 1);
                }
              }
            : null,
        onStepCancel:
            _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (_currentStep < 2)
                TextButton(
                  onPressed: controls.onStepContinue,
                  child: const Text(''),
                ),
              if (_currentStep >= 1)
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size.width * 0.8,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SuccessfulBookingFlightPage(flightData: widget.flightData,)));
                        },
                        child: Text(
                          'Pay Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(118, 94, 216, 1)),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        steps: [
          Step(
            title: Text(
              'Book and Review',
              style: TextStyle(fontSize: size.width * 0.03),
            ),
            content: Form(
              key: _formKey1,
              child: Column(
                children: <Widget>[],
              ),
            ),
          ),
          Step(
            title: Text(
              'Payment',
              style: TextStyle(fontSize: size.width * 0.03),
            ),
            content: Form(key: _formKey2, child: Container()),
          ),
          Step(
              title: Text(
                'Confirm',
                style: TextStyle(fontSize: size.width * 0.03),
              ),
              content: Column(
                children: [
                  TicketWidget(
                    width: size.width * 0.9,
                    height: size.height * 0.2,
                    isCornerRounded: true,
                    padding: EdgeInsets.all(20),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        originAbbr,
                                        style: TextStyle(
                                            fontSize: size.width * 0.08,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.flightData['origin'] ?? '',
                                      )
                                    ],
                                  ),
                                  _buildLine(
                                      size.width * 0.002, size.height * 0.03),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/plane.png',
                                        width: size.width * 0.1,
                                        height: size.height * 0.06,
                                      )
                                    ],
                                  ),
                                  _buildLine(
                                      size.width * 0.002, size.height * 0.03),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        destinationAbbr,
                                        style: TextStyle(
                                            fontSize: size.width * 0.08,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.flightData['destination'] ?? '',
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  '1 Passenger',
                                  style: TextStyle(fontSize: 16),
                                )),
                            Expanded(flex: 3, child: Text(' ')),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  widget.flightData['price'] ?? '',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text('Ensurance',
                                    style: TextStyle(fontSize: 16))),
                            Expanded(flex: 3, child: Text(' ')),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  '-',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        DottedLine(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          lineLength: size.width * 0.7,
                          lineThickness: 1.0,
                          dashLength: size.width * 0.01,
                          dashColor: Colors.black,
                          dashRadius: 0.0,
                          dashGapLength: size.width * 0.01,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.06),
                                )),
                            Expanded(flex: 3, child: Text(' ')),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  widget.flightData['price'] ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.width * 0.05),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/master.png',
                            width: size.width * 0.13,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Align children to the center
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Credit / Debit Card'),
                              Text(
                                'Master Card',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                'Change',
                                style: TextStyle(
                                    color: Color.fromRGBO(118, 94, 216, 1)),
                              ))
                        ],
                      )),
                ],
              )),
        ],
      ),
    );
  }
}

Widget _buildLine(double width, double height) {
  return Transform.rotate(
    angle: -1.5708,
    child: Container(
      width: width,
      height: height,
      color: Colors.black,
    ),
  );
}