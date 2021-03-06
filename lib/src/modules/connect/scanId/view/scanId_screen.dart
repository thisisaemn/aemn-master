//import 'package:flutter/material.dart';

//import 'package:aemn/src/assets/sample_data/aemn-interest-0.png';

// Handle this screen if permission is not given
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';

import '../../connect.dart';

class ScanIdScreen extends StatelessWidget {
  final String text;

  ScanIdScreen({required this.text}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: QRViewExample(),
    );
  }
}

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  late Barcode result;
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    result = Barcode(null, BarcodeFormat.qrcode, null);
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: Builder(
              ////NOT CLEAN!!!!!!!
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                  ),
                  onPressed: () => BlocProvider.of<NavigationBloc>(context).add(
                    NavigationRequested(
                        destination: NavigationDestinations.back),
                  ),
                  tooltip: 'back',
                );
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.flip_camera_ios_outlined),
                tooltip: 'Flip Camera',
                onPressed: () async {
                  await controller.flipCamera();
                  setState(() {});
                },
              )
            ]),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: const Alignment(0.6, 0.6),
              children: [
                _buildQrView(context),
                 FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //if (result != null)
                        Text(
                            /*'Barcode Type: ${describeEnum(result.format)}\n*/'Data: ${result.code}')
                        //else
                        //Text('Scan a code'),
                      ],
                    ),
                  ),

              ],
            )));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  String scannedUserId = "";

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && scanData.code!.split(',').length == 2) {
        List<String> c = scanData.code!.split(',');
        String username = c[0];
        String userId = c[1];
        if (userId != "" && scannedUserId != userId) {
          scannedUserId = userId;
          BlocProvider.of<ConnectBloc>(context).add(
              InviteToNewSession(inviteeUsername: username, inviteeId: userId));
          controller.pauseCamera();
          BlocProvider.of<NavigationBloc>(context).add(NavigationRequested(destination: NavigationDestinations.connect));
        }
      }

      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
