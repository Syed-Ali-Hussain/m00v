import '/flutter_flow/flutter_flow_util.dart';
import 'wallet_widget.dart' show WalletWidget;
import 'package:flutter/material.dart';

class WalletModel extends FlutterFlowModel<WalletWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Bottom Sheet - RechargeAmount] action in Button widget.
  double? amountGot;
  // Stores action output result for [Bottom Sheet - email] action in Button widget.
  String? emailGot;
  // Stores action output result for [Stripe Payment] action in Button widget.
  String? paymentId;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
