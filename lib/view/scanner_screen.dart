import 'dart:io';

import 'package:document_text_scanner/controller/scanner_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecognizerScreen extends HookConsumerWidget {
  const RecognizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final scannerState = ref.watch(scannerProvider);
    final scannerCtrl = ref.read(scannerProvider.notifier);

    useEffect((){
      Future.microtask(()=> scannerCtrl.recognizeText());
      return null;
    },[]);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Scan Result",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async => await Clipboard.setData(
                  ClipboardData(text: scannerState.scannedResult ?? "")),
              icon: const Icon(Icons.copy_rounded,color: Colors.white,)
          ),

          IconButton(
              onPressed: ()=> scannerCtrl.addScannedData(),
              icon: const Icon(Icons.save,color: Colors.white,)
          ),

        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Visibility(
          visible: scannerState.isLoading,
          replacement: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: [
                Image.file(
                  File(scannerState.document ?? ""),
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 20),

                Text(
                  scannerState.scannedResult ?? "Something is Wrong!"
                )

              ],
            ),
          ),
          child: const CircularProgressIndicator(color: Colors.blue),
        ),
      ),
    );
  }
}
