import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scv_app/pages/EPAS/style.dart';

class EPASAdminQRScanner extends StatefulWidget {
  EPASAdminQRScanner(this.setCode, {Key key}) : super(key: key);
  final Function setCode;
  @override
  _EPASAdminQRScannerState createState() => _EPASAdminQRScannerState();
}

class _EPASAdminQRScannerState extends State<EPASAdminQRScanner> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EPASStyle.backgroundColor,
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final code = barcode.rawValue;
            if (code.length != 6) {
              continue;
            }
            try {
              widget.setCode(int.parse(code));
              Navigator.pop(context);
            } catch (e) {
              continue;
            }
          }
        },
      ),
    );
  }
}
