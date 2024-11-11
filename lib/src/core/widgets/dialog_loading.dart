import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dialogLoading(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      )),
    );
  } else {
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(child: CupertinoActivityIndicator()),
    );
  }
}
