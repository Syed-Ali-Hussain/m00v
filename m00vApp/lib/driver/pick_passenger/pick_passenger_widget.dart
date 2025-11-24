import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/driver/qr/qr_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pick_passenger_model.dart';
export 'pick_passenger_model.dart';

class PickPassengerWidget extends StatefulWidget {
  const PickPassengerWidget({
    super.key,
    required this.rideDoc,
  });

  final RidesRecord? rideDoc;

  static String routeName = 'pickPassenger';
  static String routePath = '/pickPassenger';

  @override
  State<PickPassengerWidget> createState() => _PickPassengerWidgetState();
}

class _PickPassengerWidgetState extends State<PickPassengerWidget> {
  late PickPassengerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PickPassengerModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 10000),
        callback: (timer) async {
          currentUserLocationValue =
              await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));

          await currentUserReference!.update(createUsersRecordData(
            location: currentUserLocationValue,
          ));
          if (FFAppState().destinationReached) {
            _model.instantTimer?.cancel();
          }
        },
        startImmediately: true,
      );
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Pick Passenger',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.montserrat(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [
            StreamBuilder<UsersRecord>(
              stream: UsersRecord.getDocument(widget.rideDoc!.customer!),
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

                final rowUsersRecord = snapshot.data!;

                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 10.0, 10.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 12.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).primaryText,
                        icon: Icon(
                          FFIcons.kchatCircleDotsThin,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.pushNamed(
                            ChatWidget.routeName,
                            queryParameters: {
                              'otherPersonDoc': serializeParam(
                                rowUsersRecord,
                                ParamType.Document,
                              ),
                              'rideRef': serializeParam(
                                widget.rideDoc?.reference,
                                ParamType.DocumentReference,
                              ),
                            }.withoutNulls,
                            extra: <String, dynamic>{
                              'otherPersonDoc': rowUsersRecord,
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                              ),
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 10.0, 10.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 12.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).primaryText,
                        icon: Icon(
                          FFIcons.kphoneThin,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          await launchUrl(Uri(
                            scheme: 'tel',
                            path: rowUsersRecord.phoneNumber,
                          ));
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 200.0,
                  child: custom_widgets.PolylineMap(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 200.0,
                    googleApiKey: FFAppConstants.mapApiKey,
                    polylineColor: FlutterFlowTheme.of(context).secondaryText,
                    polylineWidth: 4,
                    deviationThreshold: 40.0,
                    arrivalThreshold: 20.0,
                    customMapStyle: functions.mapTheme(
                        Theme.of(context).brightness == Brightness.dark),
                    darkMode: Theme.of(context).brightness == Brightness.dark,
                    markerType: 'passenger',
                    destination: widget.rideDoc!.start!,
                  ),
                ),
              ),
              if (!_model.arrived)
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      triggerPushNotification(
                        notificationTitle: 'Driver has arrived!',
                        notificationText: 'Your driver is here to pick you up.',
                        notificationSound: 'default',
                        userRefs: [widget.rideDoc!.customer!],
                        initialPageName: 'Home',
                        parameterData: {},
                      );
                      _model.instantTimer?.cancel();
                      _model.arrived = true;
                      safeSetState(() {});
                    },
                    text: 'Arrived',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primaryText,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                            font: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              if (_model.arrived)
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: QrWidget(
                              rideRef: widget.rideDoc!.reference,
                            ),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  child: Material(
                    color: Colors.transparent,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryText,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          Icons.qr_code_rounded,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ].divide(SizedBox(height: 15.0)).around(SizedBox(height: 15.0)),
          ),
        ),
      ),
    );
  }
}
