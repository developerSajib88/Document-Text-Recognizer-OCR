
import 'package:document_text_scanner/view/scanner_screen.dart';
import 'package:document_text_scanner/controller/scanner_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final scannerState = ref.watch(scannerProvider);
    final scannerCtrl = ref.read(scannerProvider.notifier);

    void capturedDocument(){
      scannerCtrl.captureDocument().then((value){
        if(value) Navigator.push(context, MaterialPageRoute(builder: (context)=> const RecognizerScreen()));
      });
    }

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Document Text Scanner",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(6),
        alignment: Alignment.center,
        child: Visibility(
          visible: scannerState.isLoading == false,
          replacement: const CircularProgressIndicator(color: Colors.blue,),
          child: Visibility(
            visible: scannerState.scannedDocument != null,
            replacement: const Text("You don't have scanned data"),
            child: ListView.builder(
              itemCount: scannerState.scannedDocument?.length,
                itemBuilder: (context, index)=>
                    ListTile(
                      subtitle: Text(
                        scannerState.scannedDocument?[index].text ?? "",
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()=> capturedDocument(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.document_scanner,color: Colors.white,),
      ),

    );
  }
}
