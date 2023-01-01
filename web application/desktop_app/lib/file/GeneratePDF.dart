// // ignore_for_file: use_function_type_syntax_for_parameters

// import 'dart:html';
// import 'dart:typed_data';

// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class PDF{
//   final pdf = pw.Document();

//   pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text("Hello World"),
//           ); // Center
//         })); // Page

// final Uint8List fontData = File('open-sans.ttf').readAsBytesSync();
// final ttf = pw.Font.ttf(fontData.buffer.asByteData());

// final font = await PdfGoogleFonts.nunitoExtraLight();

// pdf.addPage(pw.Page(
//     pageFormat: PdfPageFormat.a4,
//     build: (pw.Context context) {
//       return pw.Center(
//         child: pw.Text('Hello World', style: pw.TextStyle(font: font, fontSize: 40)),
//       ); // Center
//     })); // Page

// }