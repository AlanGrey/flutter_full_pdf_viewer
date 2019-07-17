import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';

class PDFViewerWidget extends StatefulWidget {
  final String path;
  final bool hasAppBar;
  final bool hasStateBar;

  const PDFViewerWidget({
    Key key,
    @required this.path,
    this.hasAppBar = true,
    this.hasStateBar = true,
  }) : super(key: key);

  @override
  _PDFViewWidgetState createState() => _PDFViewWidgetState();
}

class _PDFViewWidgetState extends State<PDFViewerWidget> {
  final pdfViwerRef = PDFViewerPlugin();
  Rect _rect;
  Timer _resizeTimer;
  double _stateHeight = 0.0;

  @override
  void initState() {
    super.initState();
    pdfViwerRef.close();
    _stateHeight = MediaQueryData.fromWindow(window).padding.top;
  }

  @override
  void dispose() {
    super.dispose();
    pdfViwerRef.close();
    pdfViwerRef.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_rect == null) {
      _rect = _buildRect(context);
      pdfViwerRef.launch(
        widget.path,
        rect: _rect,
      );
    } else {
      final rect = _buildRect(context);
      if (_rect != rect) {
        _rect = rect;
        _resizeTimer?.cancel();
        _resizeTimer = Timer(Duration(milliseconds: 300), () {
          pdfViwerRef.resize(_rect);
        });
      }
    }
    return Container();
  }

  Rect _buildRect(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = widget.hasStateBar ? _stateHeight : 0.0;
    final top = (widget.hasAppBar ? kToolbarHeight : 0.0) + topPadding;
    var height = mediaQuery.size.height - top;
    if (height < 0.0) {
      height = 0.0;
    }
    return new Rect.fromLTWH(0.0, top, mediaQuery.size.width, height);
  }
}
