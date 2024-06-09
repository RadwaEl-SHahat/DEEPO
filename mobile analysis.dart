mport 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home.dart';

List<double> extractFeatures(List<int> fileBytes) {
  List<double> features = [];

  // Assuming the dataset uses DEX files within the APK
  if (fileBytes.length < 8) {
    print('File is too small to be a valid APK');
    return features;
  }

  // Check for magic number (dex file indicator) at offset 0-3
  if (fileBytes[0] != 0x64 || fileBytes[1] != 0x6E || fileBytes[2] != 0x78 || fileBytes[3] != 0x0A) {
    print('File does not appear to be a DEX file');
    return features;
  }

  // Example features based on the dataset description:
  // 1. Number of methods (32-bit integer at offset 20-23)
  int numMethods = (fileBytes[20] << 24) | (fileBytes[21] << 16) | (fileBytes[22] << 8) | fileBytes[23];
  features.add(numMethods.toDouble());

  // 2. Number of classes (32-bit integer at offset 36-39)
  int numClasses = (fileBytes[36] << 24) | (fileBytes[37] << 16) | (fileBytes[38] << 8) | fileBytes[39];
  features.add(numClasses.toDouble());

  // ... (add more features based on the dataset description)

  return features;
}

class MobileAnalysisPage extends StatefulWidget {
  const MobileAnalysisPage({Key? key}) : super(key: key);

  @override
  State<MobileAnalysisPage> createState() => _MobileAnalysisPageState();
}

class _MobileAnalysisPageState extends State<MobileAnalysisPage> {
  bool _isFilePickerActive = false;

  @override
  void initState() {
    super.initState();
    loadModel();
    checkStoragePermission();
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model_float32.tflite",
        labels: "assets/label.txt",
      );
      print("Models loaded successfully");
    } on PlatformException catch (e) {
      print("Failed to load model: '${e.message}'.");
    } catch (e) {
      print("An unknown error occurred while loading the model: $e");
    }
  }

  Future<void> checkStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void pickSingleFile(BuildContext context) async {
    if (_isFilePickerActive) {
      print("FilePicker is already active");
      return;
    }

    setState(() {
      _isFilePickerActive = true;
    });

    try {
      print("Opening FilePicker...");
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print("File selected: ${file.name}");
        processFile(file, context);
      } else {
        // User canceled the picker or no file selected
        print('No file selected');
      }
    } catch (e) {
      print("An error occurred while picking files: $e");
      showErrorDialog(context, "Error", "An error occurred while picking files: $e");
    } finally {
      setState(() {
        _isFilePickerActive = false;
      });
    }
  }

  void processFile(PlatformFile file, BuildContext context) async {
    try {
      if (file.bytes == null || file.bytes!.isEmpty) {
        print('File has no content or is empty');
        showErrorDialog(context, "Error", "File has no content or is empty");
        return;
      }

      // Extract bytes from the file
      List<int> fileBytes = file.bytes!;
      print("File bytes extracted, length: ${fileBytes.length}");

      // Extract features from the file bytes
      List<double> features = extractFeatures(fileBytes);
      print("Features extracted: $features");

      // Convert features to Float32List
      Float32List floatFeatures = Float32List.fromList(features);

      // Convert Float32List to Uint8List
      Uint8List uintFeatures = Uint8List.fromList(floatFeatures.buffer.asUint8List());
      print("Features converted to Uint8List");

      // Pass the converted uintFeatures to runModelOnBinary
      final output = await Tflite.runModelOnBinary(binary: uintFeatures);
      print("Model output: $output");

      // Interpret the model output
      if (output != null && output.isNotEmpty) {
        double prediction = output[0]; // Assuming the model outputs a single value
        String classification = prediction > 0.5 ? 'Malicious' : 'Benign'; // Threshold for classification
        print('Classification: $classification');

        // Display classification to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('File Analysis Result'),
              content: Text('The APK file is classified as: $classification'),
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
      } else {
        print('Failed to run inference');
        showErrorDialog(context, "Error", "Failed to run inference");
      }
    } catch (e) {
      print("An error occurred while processing the file: $e");
      showErrorDialog(context, "Error", "An error occurred while processing the file: $e");
    }
  }

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),

        title: Text(
          'Scan System',
          style: GoogleFonts.robotoCondensed(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Image.asset('assets/logo.png', height: 60, width: 60),
        ],
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: () => pickSingleFile(context),
          child: Text('Select File'),
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
    } catch (e) {
      print("An unknown error occurred while checking or requesting permissions: $e");
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
