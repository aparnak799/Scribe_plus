import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayPatientPage extends StatefulWidget {
  final String patientAddress;

  //DisplayPatientPage(this.patientAddress);
  DisplayPatientPage({Key key, @required this.patientAddress})
      : super(key: key);
  @override
  _DisplayPatientPageState createState() =>
      _DisplayPatientPageState(this.patientAddress);
}

class _DisplayPatientPageState extends State<DisplayPatientPage> {
  String patientAddress, docAddress;
  int cards = 0;

  String patName, patAge;
  String noOfPres;
  List<dynamic> prescriptions;
  List<dynamic> dates;
  bool _fetchedResults=false;
  bool _timedOut=false;

  _DisplayPatientPageState(this.patientAddress);
  Future<String> getPatientRecords() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getKeys());
    return sharedPreferences.getString("address");
  }


  void getPrescriptionDialog(String symptoms,String diagnosis, String medicines, String advice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Material(
          type: MaterialType.transparency,
          child:Center(
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width-100,
              height: MediaQuery.of(context).size.height-100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: FlatButton.icon(
                    icon: Icon(Icons.close, size:35.0),
                    label: Text("Close"),
                    onPressed:()=> Navigator.of(context).pop(),
                  ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Symptoms",style:TextStyle(color:Colors.black,fontWeight: FontWeight.w500, fontSize: 15.0)),
                            ),                            
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text(symptoms, style: TextStyle(fontSize: 15.0,)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                            )
                            
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Diagnosis",style:TextStyle(color:Colors.black,fontWeight: FontWeight.w500, fontSize: 15.0)),
                            ), 
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text(diagnosis, style: TextStyle(fontSize: 15.0,)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Medicines",style:TextStyle(color:Colors.black,fontWeight: FontWeight.w500, fontSize: 15.0)),
                            ), 
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text(medicines, style: TextStyle(fontSize: 15.0,)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                           Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Advice",style:TextStyle(color:Colors.black,fontWeight: FontWeight.w500, fontSize: 15.0)),
                            ), 
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text(advice, style: TextStyle(fontSize: 15.0,)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                            )
                          ],
                        ),
                      )

                      ],
                    ),
                  ),
                  )
                  
                  // ListView(
                  //   children: <Widget>[
                      
                    //],
                  // )

                ],
              )
            ),

        )
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPatientRecords().then((String address) async {
      print("$address");
      setState(() {
        docAddress = address;
      });
      print('Patient:$patientAddress/nDoctor:$docAddress');
      String url =
          'http://15d08bce.ngrok.io/api/patient/get/$patientAddress/$docAddress';
      print(url);
      final response =
          await http.get(url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> user = jsonDecode(response.body);
        print(user);
        print(user['result']['0']);
        print(user['result']['1']);
        print(user['result']['5']);
        print(user['result']['1'] is String);
        print(user['result']['5'] is String);
        setState(() {
          this.patName = user['result']['0'];
          this.patAge = user['result']['1'];
          this.noOfPres = user['result']['1'];
          this.prescriptions = user['result']['2'];
          this.dates = user['result']['5'];
          this._fetchedResults=true;
        });

      } else {
        throw Exception('Failed to load post');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_fetchedResults==true)?Scaffold(
      appBar: AppBar(
        title: Text('Patient Reports'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Patient Name",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  Text(patName)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Patient Age",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  Text(patAge)
                ],
              ),
            ),
            for (int i = 0; i < dates.length; i++)
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Card(
                  elevation: 15.0,
                  child: ListTile(
                      title: Text(dates[i]),
                      onTap: () async {
                        String index = prescriptions[i];
                        print("INDEX : $index");
                        String url =
                            'http://15d08bce.ngrok.io/api/patient/prescription/$index';
                        final response = await http.get(url, headers: {"Accept": "application/json"});
                        if (response.statusCode == 200) {
                          print(response.body);
                          Map<String, dynamic> user = jsonDecode(response.body);
                          print(user['prescription']['0']);
                          getPrescriptionDialog(user['prescription']['1'],user['prescription']['2'],user['prescription']['0'],user['prescription']['3']);
                        } else {
                          throw Exception('Failed to load post');
                        }
                        //getPrescriptionDialog(index);
                      }),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: false,
        child: Icon(Icons.person_add, color: Colors.white),
        onPressed: () => print('Plus'),
      ),
    ):
    Scaffold(
      appBar: AppBar(
        title: Text('Patient Reports'),
        centerTitle: true,
      ),
      body:(_timedOut==false)?Center(
        child: SpinKitFadingGrid(
          color: Colors.green,
        ),
      ):Timer(Duration(seconds: 8),
          (){
            setState(() {
              _timedOut=true;
            });
            Center(
              child: Text('Could not load results'),
            );
          } 
      )
      
    );
  }
}
