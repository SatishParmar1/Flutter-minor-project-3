import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class getLocation extends StatefulWidget {
  const getLocation({super.key});

  @override
  State<getLocation> createState() => _getLocationState();
}

class _getLocationState extends State<getLocation> {

  double lat=0.0;
  double lon=0.0;

  TextEditingController city = TextEditingController();
  TextEditingController contry = TextEditingController();
String? _city;
String? _contry;

void getloc()async{
  _city = city.text;
  _contry = contry.text;

 final loc = await http.get(Uri.parse('https://api.openweathermap.org/geo/1.0/direct?q=$_city,'
     '$_contry,IN&limit=1&appid=9d108e56ea8b0656212f4fc172619eac'));

 var data = jsonDecode(loc.body.toString());
print(data);
  double lat = data[0] ['lat'];
  double lon = data [0] ['lon'];

  final nat = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=9d108e56ea8b0656212f4fc172619eac'));
  print("Temprature");
  var info = jsonDecode(nat.body.toString());
  print(info);
  }


  void location()async{
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(pos.longitude);
    print(pos.latitude);
    setState(() {
      lon=pos.longitude;
      lat=pos.latitude;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("GEO Location"),
        backgroundColor: Colors.blueAccent,
      ),
        body:
            Padding(padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
        child:
            DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back.png"),
                  fit: BoxFit.contain,
              opacity: 0.25 ),

          ),

            child: Center(
              child: Container(
                  child:Column(
                    children: [
                      SizedBox(height: 200,),
                      Icon(Icons.location_on_rounded),
                      SizedBox(height: 10,),
                      Text("Lat=$lat ,   Lon=$lon",style: TextStyle(color: Colors.black,fontSize: 16),),
                      SizedBox(height: 10,),
                   //   Image.asset('assets/hello.png',height: 200,width: 150,),
                      ElevatedButton(onPressed: (){
                        getloc();
                      }, child: Text("Location")),
                      TextField(
                        controller: city,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            hintText: ("city Name") ,
                            hintStyle: TextStyle(fontSize:20),
                            hoverColor: Colors.black,
                            contentPadding: EdgeInsets.fromLTRB(10, 13, 10, 0)

                        ),
                      ),

                      TextField(
                        controller: contry,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            hintText: ("Country Name") ,
                            hintStyle: TextStyle(fontSize:20),
                            hoverColor: Colors.black,
                            contentPadding: EdgeInsets.fromLTRB(10, 13, 10, 0)

                        ),
                      ),
                    ],
                  )
              ),
            )
        ),

    )

        );
    }
}
