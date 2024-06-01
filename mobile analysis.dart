
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:io';
import 'dart:typed_data';

class MobileAnalysisPage extends StatefulWidget {
  const MobileAnalysisPage({Key? key}) : super(key: key);

  @override
  State<MobileAnalysisPage> createState() => _MobileAnalysisPageState();
}

class _MobileAnalysisPageState extends State<MobileAnalysisPage> {
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      Tflite.close();
      String? res = await Tflite.loadModel(
          model: "assets/model_float32.tflite",
          labels: "assets/label.txt");
      print("Models loading status: $res");
    } on PlatformException catch (e) {
      print("Failed to load model: '${e.message}'.");
    }
  }

  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg', 'jpeg', 'png', // Image formats
        'pdf', // PDF documents
        'doc', 'docx', // Word documents
        'xls', 'xlsx', // Excel spreadsheets
        'ppt', 'pptx', // PowerPoint presentations
        'txt', // Text files
        'csv', // CSV files
        'mp4', 'mov', // Video formats
        'mp3', // Audio formats
        'zip', // ZIP archives
        'apk', // Android application package files
        'dex', // Dalvik Executable files (Android executable files)
        'py',
        // Add more extensions here as needed
      ],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      print('Name: ${file.name}');
      print('Bytes: ${file.bytes}');
      print('Size: ${file.size}');
      print('Extension: ${file.extension}');
      print('Path: ${file.path}');
      scanFile(file);
    } else {
    // User canceled the picker
    print('User canceled the picker');
    }
  }

  void scanFile(PlatformFile file) async {
    // Read content of the file
    List<int> bytes = await File(file.path!).readAsBytes();

    // Use the loaded model to classify the file
    bool isMalware = await classifyWithModel(bytes);

    // Display the scan result to the user
    if (isMalware) {
      // File is detected as malware
      showMalwareDetectedDialog(context);
    } else {
      // File is not detected as malware
      showFileSafeDialog(context);
    }
  }


  Future<bool> classifyWithModel(List<int> features) async {
    try {
      // Convert the List<int> to Uint8List
      Uint8List uint8List = Uint8List.fromList(features);

      // Perform inference with the model
      var prediction = await Tflite.runModelOnBinary(binary: uint8List);

      // Handle potential null value of prediction
      if (prediction != null && prediction.isNotEmpty) {
        // Assuming the model returns a label indicating malware or benign
        bool isMalware = prediction[0]['label'] == 'malware';

        // Return the classification result
        return isMalware;
      } else {
        // Handle null or empty prediction
        print('Prediction is null or empty.');
        return false; // Or handle accordingly based on your use case
      }
    } catch (e, stackTrace) {
      // Handle exceptions
      print('Error: $e');
      print('Stack trace: $stackTrace');
      return false; // Or handle accordingly based on your use case
    }
  }
  void showMalwareDetectedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Malware Detected'),
          content: Text('The selected file is detected as malware.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showFileSafeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File Safe'),
          content: Text('The selected file is safe.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Analysis'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: pickFiles,
          child: Text('Pick Files'),
        ),
      ),
    );
  }
}
class PermissionsHandlerPage extends StatefulWidget {
  @override
  _PermissionsHandlerPageState createState() => _PermissionsHandlerPageState();
}

class _PermissionsHandlerPageState extends State<PermissionsHandlerPage> {
  static const platform = MethodChannel('permissions_handler');

  Future<void> _checkAndRequestPermissions() async {
    try {
      Map<String, dynamic> permissions = {
        'sendSMS': await platform.invokeMethod('checkSendSMSPermission'),
        'readPhoneState': await platform.invokeMethod('checkReadPhoneStatePermission'),
        'getAccounts': await platform.invokeMethod('checkGetAccountsPermission'),
        'receiveSMS': await platform.invokeMethod('checkReceiveSMSPermission'),
        'readSMS': await platform.invokeMethod('checkReadSMSPermission'),
        'writeSMS': await platform.invokeMethod('checkWriteSMSPermission'),
        'useCredentials': await platform.invokeMethod('checkUseCredentialsPermission'),
        'manageAccounts': await platform.invokeMethod('checkManageAccountsPermission'),
        'authenticateAccounts': await platform.invokeMethod('checkAuthenticateAccountsPermission'),
        'writeHistoryBookmarks': await platform.invokeMethod('checkWriteHistoryBookmarksPermission'),
        'readHistoryBookmarks': await platform.invokeMethod('checkReadHistoryBookmarksPermission'),
        'internet': await platform.invokeMethod('checkInternetPermission'),
        'recordAudio': await platform.invokeMethod('checkRecordAudioPermission'),
        'nfc': await platform.invokeMethod('checkNFCPermission'),
        'accessLocationExtraCommands': await platform.invokeMethod('checkAccessLocationExtraCommandsPermission'),
        'writeAPNSettings': await platform.invokeMethod('checkWriteAPNSettingsPermission'),
        'bindRemoteViews': await platform.invokeMethod('checkBindRemoteViewsPermission'),
        'readProfile': await platform.invokeMethod('checkReadProfilePermission'),
        'modifyAudioSettings': await platform.invokeMethod('checkModifyAudioSettingsPermission'),
        'broadcastSticky': await platform.invokeMethod('checkBroadcastStickyPermission'),
        'wakeLock': await platform.invokeMethod('checkWakeLockPermission'),
        'receiveBootCompleted': await platform.invokeMethod('checkReceiveBootCompletedPermission'),
        'restartPackages': await platform.invokeMethod('checkRestartPackagesPermission'),
        'bluetooth': await platform.invokeMethod('checkBluetoothPermission'),
        'readCalendar': await platform.invokeMethod('checkReadCalendarPermission'),
        'readCallLog': await platform.invokeMethod('checkReadCallLogPermission'),
        'subscribedFeedsWrite': await platform.invokeMethod('checkSubscribedFeedsWritePermission'),
        'readExternalStorage': await platform.invokeMethod('checkReadExternalStoragePermission'),
        'vibrate': await platform.invokeMethod('checkVibratePermission'),
        'accessNetworkState': await platform.invokeMethod('checkAccessNetworkStatePermission'),
        'subscribedFeedsRead': await platform.invokeMethod('checkSubscribedFeedsReadPermission'),
        'changeWifiMulticastState': await platform.invokeMethod('checkChangeWifiMulticastStatePermission'),
        'writeCalendar': await platform.invokeMethod('checkWriteCalendarPermission'),
        'masterClear': await platform.invokeMethod('checkMasterClearPermission'),
        'updateDeviceStats': await platform.invokeMethod('checkUpdateDeviceStatsPermission'),
        'writeCallLog': await platform.invokeMethod('checkWriteCallLogPermission'),
        'deletePackages': await platform.invokeMethod('checkDeletePackagesPermission'),
        'getTasks': await platform.invokeMethod('checkGetTasksPermission'),
        'globalSearch': await platform.invokeMethod('checkGlobalSearchPermission'),
        'deleteCacheFiles': await platform.invokeMethod('checkDeleteCacheFilesPermission'),
        'writeUserDictionary': await platform.invokeMethod('checkWriteUserDictionaryPermission'),
        'reorderTasks': await platform.invokeMethod('checkReorderTasksPermission'),
        'writeProfile': await platform.invokeMethod('checkWriteProfilePermission'),
        'setWallpaper': await platform.invokeMethod('checkSetWallpaperPermission'),
        'bindInputMethod': await platform.invokeMethod('checkBindInputMethodPermission'),
        'readSocialStream': await platform.invokeMethod('checkReadSocialStreamPermission'),
        'readUserDictionary': await platform.invokeMethod('checkReadUserDictionaryPermission'),
        'processOutgoingCalls': await platform.invokeMethod('checkProcessOutgoingCallsPermission'),
        'callPrivileged': await platform.invokeMethod('checkCallPrivilegedPermission'),
        'bindWallpaper': await platform.invokeMethod('checkBindWallpaperPermission'),
        'receiveWapPush': await platform.invokeMethod('checkReceiveWapPushPermission'),
        'dump': await platform.invokeMethod('checkDumpPermission'),
        'batteryStats': await platform.invokeMethod('checkBatteryStatsPermission'),
        'accessCoarseLocation': await platform.invokeMethod('checkAccessCoarseLocationPermission'),
        'setTime': await platform.invokeMethod('checkSetTimePermission'),
        'writeSocialStream': await platform.invokeMethod('checkWriteSocialStreamPermission'),
        'writeSettings': await platform.invokeMethod('checkWriteSettingsPermission'),
        'reboot': await platform.invokeMethod('checkRebootPermission'),
        'bluetoothAdmin': await platform.invokeMethod('checkBluetoothAdminPermission'),
        'bindDeviceAdmin': await platform.invokeMethod('checkBindDeviceAdminPermission'),
        'writeGservices': await platform.invokeMethod('checkWriteGservicesPermission'),
        'killBackgroundProcesses': await platform.invokeMethod('checkKillBackgroundProcessesPermission'),
        'setAlarm': await platform.invokeMethod('checkSetAlarmPermission'),
        'accountManager': await platform.invokeMethod('checkAccountManagerPermission'),
        'statusBar': await platform.invokeMethod('checkStatusBarPermission'),
        'persistentActivity': await platform.invokeMethod('checkPersistentActivityPermission'),
        'changeNetworkState': await platform.invokeMethod('checkChangeNetworkStatePermission'),
        'receiveMms': await platform.invokeMethod('checkReceiveMmsPermission'),
        'setTimeZone': await platform.invokeMethod('checkSetTimeZonePermission'),
        'controlLocationUpdates': await platform.invokeMethod('checkControlLocationUpdatesPermission'),
        'broadcastWapPush': await platform.invokeMethod('checkBroadcastWapPushPermission'),
        'bindAccessibilityService': await platform.invokeMethod('checkBindAccessibilityServicePermission'),
        'addVoicemail': await platform.invokeMethod('checkAddVoicemailPermission'),
        'callPhone': await platform.invokeMethod('checkCallPhonePermission'),
        'bindAppWidget': await platform.invokeMethod('checkBindAppWidgetPermission'),
        'flashlight': await platform.invokeMethod('checkFlashlightPermission'),
        'readLogs': await platform.invokeMethod('checkReadLogsPermission'),
        'setProcessLimit': await platform.invokeMethod('checkSetProcessLimitPermission'),
      };

      List<String> permissionsToRequest = [];
      permissions.forEach((key, value) {
        if (!value) {
          permissionsToRequest.add(key);
        }
      });

      if (permissionsToRequest.isNotEmpty) {
        Map<String, dynamic> permissionsMap = {};
        permissionsToRequest.forEach((permission) {
          permissionsMap[permission] = true;
        });
        await platform.invokeMethod('requestPermissions', permissionsMap);
      }
    } on PlatformException catch (e) {
      print("Failed to check or request permissions: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permissions Handler'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _checkAndRequestPermissions,
          child: Text('Check and Request Permissions'),
        ),
      ),
    );
  }
}
