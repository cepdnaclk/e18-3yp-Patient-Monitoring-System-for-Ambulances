import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:desktop_app/people/Patient.dart';
import 'package:desktop_app/people/Hospital.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDF {
  Future<void> createPDF(Patient p, Hospital h, String d, bool status) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    //blue line
    page.graphics.drawImage(PdfBitmap(await readImage('blueScreen.png')),
        const Rect.fromLTWH(0, 0, 500, 50));
    //icon
    page.graphics.drawImage(PdfBitmap(await readImage('test2.png')),
        const Rect.fromLTWH(15, 10, 30, 30));

    //app name
    page.graphics.drawString(
      'LIVE RAY',
      PdfStandardFont(PdfFontFamily.helvetica, 40, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(55, 3, 0, 0),
      brush: PdfBrushes.white,
      pen: PdfPen(PdfColor.fromCMYK(0, 0, 0, 1), width: 0.5),
    );
    //Date
    page.graphics.drawString(
        'Date', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 80, 0, 0));
    page.graphics.drawString(': ${DateTime.now().toString().substring(0, 10)}',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(100, 80, 0, 0));

    //arrived time
    page.graphics.drawString(
        'Time', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 120, 0, 0));
    page.graphics.drawString(': ${DateTime.now().toString().substring(11, 19)}',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(100, 120, 0, 0));
    //hospital
    page.graphics.drawString(
        'Hospital', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 160, 0, 0));
    page.graphics.drawString(': ${h.id}-${h.name}',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(100, 160, 0, 0));

    //device
    page.graphics.drawString(
        'Device ID', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 200, 0, 0));
    page.graphics.drawString(': $d',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(100, 200, 0, 0));

    //name
    page.graphics.drawString(
        'Name', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 240, 0, 0));
    page.graphics.drawString(': ${p.name}',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(100, 240, 0, 0));

//age
    page.graphics.drawString(
        'Age', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 280, 0, 0));
    page.graphics.drawString(': ${p.age == 0 ? 'none' : p.age}',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(100, 280, 0, 0));
//condition
    page.graphics.drawString(
        'Condition', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 320, 0, 0));
    page.graphics.drawString(': ${p.condition}',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(100, 320, 0, 0));

    page.graphics.drawString(
        'Patient Status', PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: const Rect.fromLTWH(0, 400, 0, 0));

    page.graphics.drawEllipse(
      const Rect.fromLTWH(140, 400, 20, 20),
      brush: status ? PdfBrushes.red : PdfBrushes.limeGreen,
    );

    page.graphics.drawString(
        'Last Updated Health Parameters',
        PdfStandardFont(PdfFontFamily.helvetica, 15,
            multiStyle: [PdfFontStyle.bold]),
        bounds: const Rect.fromLTWH(0, 480, 0, 0));
// graphics.DrawRectangle(PdfPens.red, RectangleF(0, 20, 200, 100));
    PdfGrid grid = PdfGrid();

    grid.columns.add(count: 4);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    grid.headers[0].style = PdfGridRowStyle(
      backgroundBrush: PdfBrushes.lightGray,
    );
    header.cells[0].value = 'Temparature';
    header.cells[1].value = 'Heart Rate';
    header.cells[2].value = 'Pulse Rate';
    header.cells[3].value = 'Oxy Sat.';
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = p.temperature.toString();
    row.cells[1].value = p.heartRate.toString();
    row.cells[2].value = p.pulseRate.toString();
    row.cells[3].value = p.oxygenSaturation.toString();
    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 10, right: 3, top: 4, bottom: 5),
        font: PdfStandardFont(PdfFontFamily.helvetica, 15));
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(30, 520, 0, 0),
    );

    List<int> bytes = await document.save();
    document.dispose();
    saveAndLaunch(bytes,
        '${d}-${h.id}-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().toString().substring(0, 10)}.pdf');
  }

  Future<Uint8List> readImage(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> saveAndLaunch(List<int> bytes, String fileName) async {
    Directory docPath = await getApplicationDocumentsDirectory();

    var isThere = await Directory('${docPath.path}/patients').exists();

    if (!isThere) {
      await Directory('${docPath.path}/patients').create();
    }

    final file = File('${docPath.path}/patients/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('${docPath.path}/patients/$fileName');
  }
}
