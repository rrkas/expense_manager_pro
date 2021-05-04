import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class GeneratedReports extends StatefulWidget {
  static const routeName = '/generated-reports';

  @override
  _GeneratedReportsState createState() => _GeneratedReportsState();
}

class _GeneratedReportsState extends State<GeneratedReports> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Directory>(
      future: getTemporaryDirectory(),
      builder: (_, snap) {
        Widget b;
        List<String> paths;
        if (snap.data == null)
          b = Center(
            child: Text('Loading...'),
          );
        else {
          paths = snap.data.listSync(recursive: true).where((element) => element.path.split('/').last.contains('.')).map((e) => e.path).toList();
          b = paths.isEmpty
              ? Center(
                  child: Text('Nothing to show!'),
                )
              : ListView.builder(
                  itemCount: paths.length,
                  itemBuilder: (c, idx) => _FileRow(
                    path: paths[idx],
                    refresh: () => setState(() {}),
                  ),
                );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Generated Reports'),
            actions: [
              if (paths?.isNotEmpty ?? false)
                IconButton(
                  icon: Icon(Icons.delete_sweep),
                  onPressed: () {
                    for (final f in paths) File(f).deleteSync();
                    setState(() {});
                  },
                ),
            ],
          ),
          body: b,
        );
      },
    );
  }
}

class _FileRow extends StatelessWidget {
  final String path;
  final Function refresh;

  const _FileRow({Key key, this.path, this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final f = File(path);
    return GestureDetector(
      onTap: () {
        OpenFile.open(path);
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Icon(path.endsWith('xlsx') ? FontAwesome5.file_excel : FlutterIcons.file_pdf_faw5),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(path.split('/').last, style: TextStyle(fontSize: 17)),
                  Text(DateFormat('dd MMM yyyy - HH:mm:ss').format(f.lastModifiedSync())),
                ],
              ),
            ),
            PopupMenuButton<int>(
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 1,
                  child: Text('Open'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Share'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('Delete'),
                ),
              ],
              onSelected: (idx) {
                switch (idx) {
                  case 1:
                    OpenFile.open(path);
                    break;
                  case 2:
                    Share.shareFiles([path]);
                    break;
                  case 3:
                    f.deleteSync(recursive: true);
                    refresh();
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
