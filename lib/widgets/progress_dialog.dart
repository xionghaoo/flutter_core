import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen_adaptation.dart';

class ProgressDialog {
  BuildContext context;
  String message;

  ProgressDialog(this.context, {this.message = "加载中..."});

  show() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          // 允许用户点返回关闭
          onWillPop: () async => true,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(xdp(4))
            ),
            child: Container(
              height: xdp(80),
              alignment: Alignment.center,
              child: Container(
                width: xdp(80),
                height: xdp(80),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(xdp(4))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      strokeWidth: 2,
                    ),
                    SizedBox(height: xdp(8),),
                    Text(message, style: TextStyle(color: Colors.grey, fontSize: xdp(12)),),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  dismiss() {
    Navigator.of(context).pop();
  }
}