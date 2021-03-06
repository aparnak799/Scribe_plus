import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart' as localAuth;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class updatePatient extends StatefulWidget {
  
  updatePatient({Key key, }) : super(key: key);
  @override
  _updatePatientState createState() => _updatePatientState();
}

class _updatePatientState extends State<updatePatient> {
  TextEditingController symptomsController, diagnosisController, prescriptionController, remarksController, phoneNumberController, emailController;
  String _symptoms, _diagnosis, _prescription, _remarks;

  localAuth.LocalAuthentication localAuthentication=localAuth.LocalAuthentication();
  bool hasFingerPrint=false;
  bool notAuthenticatedFingerprint=true;

  Future<bool> checkBiometrics() async{
    
    try{
      bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
      return canCheckBiometrics;
      
    } on Exception catch(e){
      print(e.toString());
      
    }
    return false;
    
  }
  
  Future<void> _authenticate() async{
    bool authenticated=false;
    try{
      authenticated= await localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate to send report",
        stickyAuth: true,
      );
    } on PlatformException catch(e){
      print(e.message);
    }
    if(!mounted) return;
    setState(() {
      notAuthenticatedFingerprint=authenticated?false:true;
    });
  }

  


  @override
  void initState() {
    super.initState();
    initialiseFromJSON();
    initialiseControllers();
    symptomsController.text=_symptoms;
    diagnosisController.text=_diagnosis;
    prescriptionController.text=_prescription;
    remarksController.text=_remarks;
    print("object");
    checkBiometrics().then((bool result){
      setState(() {
        hasFingerPrint=result;
        print(this.hasFingerPrint);
      });
      
    });
    
  
    // .then((bool result){

    //   print(result);
    //   // this.setState(
    //   //   hasFingerPrint=result;
    //   // );
      
    
      
    // });
  } 

  Map toMap(){
    var map = new Map<String, dynamic>();
   
    map["symptoms"] = "symptoms";
    map["diagnosis"] = "diagnosis";
    map["remarks"] = "remarks";
    map["phoneno"] = "8939411718";
    map["email"] = "aparna.k799@gmail.com";
    return map;
  }
  Future<String> createPost(String url) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    var map = new Map<String, dynamic>();
   
    map["symptoms"] = "symptoms";
    map["diagnosis"] = "diagnosis";
    map["remarks"] = "remarks";
    map["phoneno"] = "8939411718";
    map["email"] = "aparna.k799@gmail.com";
    print("Entered");
    String req = '{symptoms":"'+symptomsController.text+'","diagnosis":"'+diagnosisController.text+'","prescription":"'+prescriptionController.text+'","advice":"'+remarksController.text+'","phno":"'+phoneNumberController.text+'","email":"'+emailController.text+'"}';
    print(req);
   http.post(url, headers: headers, body: req).then((http.Response response) {
    final int statusCode = response.statusCode;
 
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");

    }
    else
    {
      return (response.body);
    }
    
  });
}
  void initialiseFromJSON(){
    
    _symptoms="Cough\nCold";
    _diagnosis="Fever";
    _prescription="Dolo650\nCrocin";
    _remarks="remarks";
  }
  void initialiseControllers(){
    
    symptomsController=TextEditingController();
    diagnosisController=TextEditingController();
    prescriptionController=TextEditingController();
    remarksController=TextEditingController();
    phoneNumberController=TextEditingController();
    emailController=TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        centerTitle: true,
      ),
      body: Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[             
              
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               
               
                
                             
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Symptoms",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: symptomsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                ),
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Diagnosis",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: diagnosisController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                ) ,                      
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Prescription",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: prescriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                
                ),                          
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Remarks",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: remarksController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),                  
                ),                              
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Contact",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                ),              
                
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                )
                
              ],
            )
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            hasFingerPrint?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                notAuthenticatedFingerprint?
                FlatButton.icon(
                  icon: Icon(Icons.fingerprint,color:Colors.blueGrey,size:35.0),
                  label: Text("Authenticate"),
                  onPressed: _authenticate,
                ):
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  FlatButton.icon(
                  icon: Icon(Icons.fingerprint,color:Colors.green,size:35.0),
                  label: Text("Authenticated"),
                  onPressed: null,
                ),
                RaisedButton(
                  color: Colors.green,
                  child: Text("Send",style:TextStyle(color: Colors.white)),
                  onPressed:() async=> {
                    print("object"),
                    await createPost('http://3c87352c.ngrok.io/api/patient/update')
                  }
                )

                  ],
                )
                

              ],
            ):
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  child: Text("Send",style:TextStyle(color: Colors.white)),
                  onPressed:()=> print("object"),
                )
              ],
            )
            ],
        ),
      ),
    ) ,
    );
      
  }
}