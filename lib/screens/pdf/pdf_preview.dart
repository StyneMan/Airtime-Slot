import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import 'pdf.dart';

class PDFPreview extends StatelessWidget {
  var data;
  PDFPreview({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(data),
      ),
    );
  }
}
