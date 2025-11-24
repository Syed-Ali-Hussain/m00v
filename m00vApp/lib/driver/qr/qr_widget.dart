import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'qr_model.dart';
export 'qr_model.dart';

class QrWidget extends StatefulWidget {
  const QrWidget({
    super.key,
    required this.rideRef,
  });

  final DocumentReference? rideRef;

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {
  late QrModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QrModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: StreamBuilder<RidesRecord>(
        stream: RidesRecord.getDocument(widget.rideRef!)
          ..listen((containerRidesRecord) async {
            if (_model.containerPreviousSnapshot != null &&
                !RidesRecordDocumentEquality().equals(
                    containerRidesRecord, _model.containerPreviousSnapshot)) {
              await Future.delayed(
                Duration(
                  milliseconds: 500,
                ),
              );

              context.goNamed(
                TravelStartWidget.routeName,
                queryParameters: {
                  'rideDoc': serializeParam(
                    containerRidesRecord,
                    ParamType.Document,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  'rideDoc': containerRidesRecord,
                  kTransitionInfoKey: TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                  ),
                },
              );

              safeSetState(() {});
            }
            _model.containerPreviousSnapshot = containerRidesRecord;
          }),
        builder: (context, snapshot) {
          // Customize what your widget looks like when it's loading.
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            );
          }

          final containerRidesRecord = snapshot.data!;

          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: 300.0,
            ),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'For passenger',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 20.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Container(
                    width: 200.0,
                    height: 200.0,
                    child: custom_widgets.GenerateQRCode(
                      width: 200.0,
                      height: 200.0,
                      inputText: widget.rideRef!.id,
                      qrMainColor: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  Text(
                    'Please ask the passenger to scan this QR code to begin the ride',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.raleway(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ].divide(SizedBox(height: 15.0)).around(SizedBox(height: 15.0)),
              ),
            ),
          );
        },
      ),
    );
  }
}
