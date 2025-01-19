import 'dart:io';

import 'package:document_text_scanner/controller/scanner_state.dart';
import 'package:document_text_scanner/local_database/local_database.dart';
import 'package:document_text_scanner/model/scanned_document.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scannerProvider = StateNotifierProvider<ScannerStateNotifier,ScannerState>(
        (ref)=> ScannerStateNotifier()..setScannedDocumentData());


class ScannerStateNotifier extends StateNotifier<ScannerState>{

  ScannerStateNotifier():super(ScannerState.init());

  void stateMaker(ScannerState newState)=> state = newState;

  Future<bool> captureDocument()async{

    DocumentScannerOptions documentOptions = DocumentScannerOptions(
      documentFormat: DocumentFormat.jpeg,
      mode: ScannerMode.filter,
      pageLimit: 1,
      isGalleryImport: true,
    );

    bool documentScanSuccess = false;
    await DocumentScanner(options: documentOptions).scanDocument().then((result){
      stateMaker(state.copyWith(
        document: result.images.first
      ));
      documentScanSuccess = true;
    });

    return documentScanSuccess;

  }

  Future<void> recognizeText()async{
    stateMaker(state.copyWith(isLoading: true));
    if(state.document != null){
      await TextRecognizer(
          script: TextRecognitionScript.devanagiri
      ).processImage(
          InputImage.fromFile(File(state.document ?? ""))
      ).then((result){
        stateMaker(state.copyWith(
          scannedResult: result.text
        ));
      });
    }
    stateMaker(state.copyWith(isLoading: false));
  }

  Future<void> addScannedData() async {

    List<ScannedDocument> scannedData = List.from(state.scannedDocument ?? []);
    scannedData.add(ScannedDocument(
      text: state.scannedResult
    ));

    print(scannedData);

    stateMaker(state.copyWith(
      scannedDocument: scannedData
    ));

    storeScannedDocumentData();

  }

  void storeScannedDocumentData(){
    LocalDatabase().setScannedData(
      state.scannedDocument?.map((scannedDocument)=> scannedDocument.toRawJson()).toList().join()
    );
  }

  void setScannedDocumentData(){

    stateMaker(state.copyWith(isLoading: true));
    print(LocalDatabase().getScannedData());

      List? scannedDocument = LocalDatabase().getScannedData()?.split(",")
          .map((data)=> ScannedDocument.fromRawJson(data)).toList();
      if(scannedDocument != null){
        // stateMaker(
        //     state.copyWith(
        //         scannedDocument: scannedDocument
        //     )
        // );
      }

    stateMaker(state.copyWith(isLoading: false));
  }

}