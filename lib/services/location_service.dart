import 'package:location/location.dart';

class LocationService{
  Location location;

  LocationService(){
    location = new Location();
  }

  Future<LocationData> getLocation() async{
    bool serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled){
      serviceEnabled = await location.requestService();
      if(!serviceEnabled){
        return null;
      }
    }
    var pos = await location.getLocation();
    return pos;
  }







}