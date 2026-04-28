import 'package:permission_handler/permission_handler.dart';

Future HandleHealthPermissions() async{
  var activityRecognitionStatus = await Permission.activityRecognition.status;
  var locationStatus = await Permission.location.status;

  if(activityRecognitionStatus.isDenied){
    await Permission.activityRecognition.request();
  }

  if(locationStatus.isDenied){
    await Permission.location.request();
  }
}