import 'package:permission_handler/permission_handler.dart';
import 'package:tourlao/model/user_model.dart';

class Params {
  static UserModel currentModel = UserModel();
}

Future<bool> checkImagePermission() async {
  var statusPhoto = await Permission.photos.status;
  var statusCamera = await Permission.camera.status;
  if (!statusPhoto.isGranted ||
      !statusCamera.isGranted) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.camera,
    ].request();
    print('[PERMISSION] ${statuses[Permission.photos]}');
    print('[PERMISSION] ${statuses[Permission.camera]}');
    if (statuses[Permission.photos] != PermissionStatus.denied &&
        statuses[Permission.camera] != PermissionStatus.denied) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}