import 'package:flutter/material.dart';

/// Error Alert
class ErrorAlert {
  ErrorAlert(
      {Key? key,
      required BuildContext context,
      String alertTitle = "",
      bool isItForInternet = false,
      required message,
      callBackYes}) {
//    alertPopUp(context,success,msg,callback);
    errorDialog(context, isItForInternet, alertTitle, message, callBackYes);
  }

  Future<bool?> errorDialog(BuildContext context1, bool isItForInternet,
      String alertTitle, String? message, callBackYes) {
    return showDialog(
        context: context1,
        barrierDismissible: !isItForInternet,
        builder: (context1) {
          //mContext = context1;
          return AlertDialog(
            //insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
            title: Text(alertTitle,
                style: const TextStyle(color: Colors.black54, fontSize: 20.0)),
            content: Text(
              message ?? "",
              style: const TextStyle(color: Colors.black54, fontSize: 20.0),
            ),
            actions: <Widget>[
              TextButton(
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Text("OK", style: TextStyle(fontSize: 18.0)),
                ),
                onPressed: () {
                  if (callBackYes != null) {
                    callBackYes(context1);
                  } else {
                    Navigator.pop(context1);
                  }
                },
              )
            ],
          );
        });
  }
}
