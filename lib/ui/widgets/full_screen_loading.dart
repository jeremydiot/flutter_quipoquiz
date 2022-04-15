import 'package:flutter/material.dart';

void fullScreenLoading(BuildContext parentContext){
  bool onceTap = true;
  showDialog(
    barrierColor: Colors.grey.withOpacity(0.3),
    barrierDismissible: false,
    context: parentContext,
    builder: (BuildContext context){
      return WillPopScope(
        onWillPop: () async => false,
        child: const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 7,
              ),
              height: 70,
              width: 70,
            )
          )
        ),
      );
    },
  );
}