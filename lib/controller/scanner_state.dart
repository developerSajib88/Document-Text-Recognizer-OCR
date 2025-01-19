import 'package:document_text_scanner/model/scanned_document.dart';
import 'package:equatable/equatable.dart';

class ScannerState extends Equatable{

  final bool isLoading;
  final String? document;
  final String? scannedResult;
  final List<ScannedDocument>? scannedDocument;

  const ScannerState({
    required this.isLoading,
    required this.document,
    required this.scannedResult,
    required this.scannedDocument
  });

  @override
  List<Object?> get props => [
    isLoading,
    document,
    scannedResult
  ];

  factory ScannerState.init()=> const ScannerState(
    isLoading: false,
    document: null,
    scannedResult: null,
    scannedDocument: null
  );

  ScannerState copyWith({
    bool? isLoading,
    String? document,
    String? scannedResult,
    List<ScannedDocument>? scannedDocument
  })=> ScannerState(
    isLoading: isLoading ?? this.isLoading,
    document: document ?? this.document,
    scannedResult: scannedResult ?? this.scannedResult,
    scannedDocument: scannedDocument ?? this.scannedDocument
  );

}