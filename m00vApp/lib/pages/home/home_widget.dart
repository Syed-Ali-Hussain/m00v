import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/components/empty_list/empty_list_widget.dart';
import '/components/famous_points/famous_points_widget.dart';
import '/components/pick_up/pick_up_widget.dart';
import '/components/start_ride/start_ride_widget.dart';
import '/components/wallet/wallet_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/passenger/select_ride_type/select_ride_type_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/permissions_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
      await authManager.refreshUser();
      await requestPermission(locationPermission);
      await requestPermission(notificationsPermission);
      await requestPermission(cameraPermission);

      await currentUserReference!.update(createUsersRecordData(
        location: currentUserLocationValue,
      ));
      if (!valueOrDefault<bool>(currentUserDocument?.phoneVerified, false)) {
        context.goNamed(
          TakePhoneNumberWidget.routeName,
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
            ),
          },
        );
      }
      if (!currentUserEmailVerified) {
        context.goNamed(
          VerifyEmailWidget.routeName,
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
            ),
          },
        );
      }
      if (valueOrDefault<bool>(currentUserDocument?.driver, false)) {
        if (currentUserDocument?.driverDoc != null) {
          _model.driverDoc = await DriversRecord.getDocumentOnce(
              currentUserDocument!.driverDoc!);
          if (_model.driverDoc!.blocked) {
            context.goNamed(
              AccountBannedWidget.routeName,
              extra: <String, dynamic>{
                kTransitionInfoKey: TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.fade,
                ),
              },
            );
          } else {
            if (_model.driverDoc!.isApproved) {
              await currentUserReference!.update(createUsersRecordData(
                location: currentUserLocationValue,
              ));
              if (FFAppState().ridePlaced) {
                _model.rideGot =
                    await RidesRecord.getDocumentOnce(FFAppState().rideRef!);
                if (_model.rideGot != null) {
                  if (_model.rideGot!.paid) {
                    FFAppState().ridePlaced = false;
                    FFAppState().destinationReached = false;
                    FFAppState().remainingDistance = 0.0;
                    FFAppState().rideRef = null;
                    safeSetState(() {});

                    context.goNamed(
                      SuccessWidget.routeName,
                      queryParameters: {
                        'rideDoc': serializeParam(
                          _model.rideGot,
                          ParamType.Document,
                        ),
                      }.withoutNulls,
                      extra: <String, dynamic>{
                        'rideDoc': _model.rideGot,
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                        ),
                      },
                    );
                  } else {
                    if (_model.rideGot!.completedButNotPaid) {
                      context.goNamed(
                        BillWidget.routeName,
                        queryParameters: {
                          'rideDoc': serializeParam(
                            _model.rideGot,
                            ParamType.Document,
                          ),
                        }.withoutNulls,
                        extra: <String, dynamic>{
                          'rideDoc': _model.rideGot,
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                          ),
                        },
                      );
                    } else {
                      if (_model.rideGot!.started) {
                        context.goNamed(
                          TravelStartWidget.routeName,
                          queryParameters: {
                            'rideDoc': serializeParam(
                              _model.rideGot,
                              ParamType.Document,
                            ),
                          }.withoutNulls,
                          extra: <String, dynamic>{
                            'rideDoc': _model.rideGot,
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                            ),
                          },
                        );
                      } else {
                        if (_model.rideGot!.accepted) {
                          context.goNamed(
                            PickPassengerWidget.routeName,
                            queryParameters: {
                              'rideDoc': serializeParam(
                                _model.rideGot,
                                ParamType.Document,
                              ),
                            }.withoutNulls,
                            extra: <String, dynamic>{
                              'rideDoc': _model.rideGot,
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                              ),
                            },
                          );
                        } else {
                          FFAppState().ridePlaced = false;
                          FFAppState().rideRef = null;
                          FFAppState().remainingDistance = 0.0;
                          FFAppState().destinationReached = false;
                          safeSetState(() {});
                        }
                      }
                    }
                  }
                } else {
                  FFAppState().rideRef = null;
                  FFAppState().remainingDistance = 0.0;
                  FFAppState().destinationReached = false;
                  FFAppState().ridePlaced = false;
                  safeSetState(() {});
                }
              }
            } else {
              context.goNamed(
                UploadFilesWidget.routeName,
                extra: <String, dynamic>{
                  kTransitionInfoKey: TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                  ),
                },
              );
            }
          }
        } else {
          var driversRecordReference2 = DriversRecord.collection.doc();
          await driversRecordReference2.set(createDriversRecordData(
            userId: currentUserReference,
            isApproved: false,
            isOnline: false,
            blocked: false,
          ));
          _model.newDriverCreated = DriversRecord.getDocumentFromData(
              createDriversRecordData(
                userId: currentUserReference,
                isApproved: false,
                isOnline: false,
                blocked: false,
              ),
              driversRecordReference2);

          await currentUserReference!.update(createUsersRecordData(
            driverDoc: _model.newDriverCreated?.reference,
          ));

          context.goNamed(
            UploadFilesWidget.routeName,
            extra: <String, dynamic>{
              kTransitionInfoKey: TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.fade,
              ),
            },
          );
        }
      } else {
        if (FFAppState().ridePlaced) {
          _model.rideGotPassenger =
              await RidesRecord.getDocumentOnce(FFAppState().rideRef!);
          if (_model.rideGotPassenger != null) {
            if (_model.rideGotPassenger!.paid) {
              FFAppState().ridePlaced = false;
              FFAppState().destinationReached = true;
              FFAppState().remainingDistance = 0.0;
              FFAppState().rideRef = null;
              safeSetState(() {});

              context.goNamed(
                SuccessWidget.routeName,
                queryParameters: {
                  'rideDoc': serializeParam(
                    _model.rideGotPassenger,
                    ParamType.Document,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  'rideDoc': _model.rideGotPassenger,
                  kTransitionInfoKey: TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.fade,
                  ),
                },
              );
            } else {
              if (_model.rideGotPassenger!.completedButNotPaid) {
                context.goNamed(
                  BillWidget.routeName,
                  queryParameters: {
                    'rideDoc': serializeParam(
                      _model.rideGotPassenger,
                      ParamType.Document,
                    ),
                  }.withoutNulls,
                  extra: <String, dynamic>{
                    'rideDoc': _model.rideGotPassenger,
                    kTransitionInfoKey: TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.fade,
                    ),
                  },
                );
              } else {
                if (_model.rideGotPassenger!.started) {
                  context.goNamed(
                    TravelStartWidget.routeName,
                    queryParameters: {
                      'rideDoc': serializeParam(
                        _model.rideGotPassenger,
                        ParamType.Document,
                      ),
                    }.withoutNulls,
                    extra: <String, dynamic>{
                      'rideDoc': _model.rideGotPassenger,
                      kTransitionInfoKey: TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.fade,
                      ),
                    },
                  );
                } else {
                  if (_model.rideGotPassenger!.accepted) {
                    context.goNamed(
                      DriverComingWidget.routeName,
                      queryParameters: {
                        'rideRef': serializeParam(
                          FFAppState().rideRef,
                          ParamType.DocumentReference,
                        ),
                      }.withoutNulls,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                        ),
                      },
                    );
                  } else {
                    _model.allDriver = await actions.queryAllDrivers();

                    context.goNamed(
                      SearchingDriverWidget.routeName,
                      queryParameters: {
                        'rideDocument': serializeParam(
                          _model.rideGotPassenger,
                          ParamType.Document,
                        ),
                        'allDrivers': serializeParam(
                          _model.allDriver,
                          ParamType.Document,
                          isList: true,
                        ),
                      }.withoutNulls,
                      extra: <String, dynamic>{
                        'rideDocument': _model.rideGotPassenger,
                        'allDrivers': _model.allDriver,
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                        ),
                      },
                    );
                  }
                }
              }
            }
          } else {
            FFAppState().ridePlaced = false;
            FFAppState().destinationReached = false;
            FFAppState().rideRef = null;
            FFAppState().remainingDistance = 0.0;
            safeSetState(() {});
          }
        }
      }
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
            'm00v',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 30.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [
            Visibility(
              visible:
                  !valueOrDefault<bool>(currentUserDocument?.driver, false),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 10.0, 10.0),
                child: AuthUserStreamWidget(
                  builder: (context) => FlutterFlowIconButton(
                    borderRadius: 12.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primaryText,
                    icon: Icon(
                      Icons.wallet_outlined,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      size: 24.0,
                    ),
                    onPressed: () async {
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
                              child: WalletWidget(),
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                  ),
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (valueOrDefault<bool>(
                        currentUserDocument?.driver, false)) {
                      return StreamBuilder<DriversRecord>(
                        stream: DriversRecord.getDocument(
                            currentUserDocument!.driverDoc!),
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

                          final containerDriversRecord = snapshot.data!;

                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Available Rides',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  if (containerDriversRecord.isOnline)
                                    Expanded(
                                      child: StreamBuilder<List<RidesRecord>>(
                                        stream: queryRidesRecord(
                                          queryBuilder: (ridesRecord) =>
                                              ridesRecord
                                                  .where(
                                                    'accepted',
                                                    isEqualTo: false,
                                                  )
                                                  .where(
                                                    'canceled',
                                                    isEqualTo: false,
                                                  )
                                                  .where(
                                                    'rideType',
                                                    isEqualTo:
                                                        containerDriversRecord
                                                            .rideType,
                                                  )
                                                  .orderBy('startTime',
                                                      descending: true),
                                        ),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          List<RidesRecord>
                                              listViewRidesRecordList =
                                              snapshot.data!;
                                          if (listViewRidesRecordList.isEmpty) {
                                            return EmptyListWidget();
                                          }

                                          return ListView.separated(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                listViewRidesRecordList.length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox(height: 10.0),
                                            itemBuilder:
                                                (context, listViewIndex) {
                                              final listViewRidesRecord =
                                                  listViewRidesRecordList[
                                                      listViewIndex];
                                              return Builder(
                                                builder: (context) => InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (dialogContext) {
                                                        return Dialog(
                                                          elevation: 0,
                                                          insetPadding:
                                                              EdgeInsets.zero,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          alignment: AlignmentDirectional(
                                                                  0.0, 0.0)
                                                              .resolve(
                                                                  Directionality.of(
                                                                      context)),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      dialogContext)
                                                                  .unfocus();
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                            },
                                                            child:
                                                                StartRideWidget(
                                                              rideDocRef:
                                                                  listViewRidesRecord
                                                                      .reference,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(7.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            FFIcons
                                                                .kmapPinSimpleThin,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            size: 20.0,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'New Ride',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .raleway(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  'At: ${dateTimeFormat("relative", listViewRidesRecord.startTime)}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .raleway(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height: 4.0)),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 7.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  Container(
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          if (containerDriversRecord.isOnline) {
                                            await containerDriversRecord
                                                .reference
                                                .update(createDriversRecordData(
                                              isOnline: false,
                                            ));
                                          } else {
                                            await containerDriversRecord
                                                .reference
                                                .update(createDriversRecordData(
                                              isOnline: true,
                                            ));
                                          }
                                        },
                                        text: containerDriversRecord.isOnline
                                            ? 'You are online'
                                            : 'You are offline',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 50.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: containerDriversRecord.isOnline
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : FlutterFlowTheme.of(context)
                                                  .error,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.montserrat(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 15.0)),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: custom_widgets.AllDriversMap(
                              width: double.infinity,
                              height: double.infinity,
                              customMapStyle: functions.mapTheme(
                                  Theme.of(context).brightness ==
                                      Brightness.dark),
                              darkMode: Theme.of(context).brightness ==
                                  Brightness.dark,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 10.0, 10.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    WhereToWidget.routeName,
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: TransitionInfo(
                                        hasTransition: true,
                                        transitionType: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 0),
                                      ),
                                    },
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 0.0, 20.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Where to...',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.raleway(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Icon(
                                          Icons.travel_explore_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 20.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Container(
                              height: 80.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: FamousPointsWidget(),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(
                                          () => _model.pointsGot = value));

                                      if (_model.pointsGot != null &&
                                          (_model.pointsGot)!.isNotEmpty) {
                                        _model.uuid =
                                            await actions.randomNumber();
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          useSafeArea: true,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: PickUpWidget(
                                                  token: _model.uuid!,
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(
                                            () => _model.pickUpGot = value));

                                        _model.inArea =
                                            await actions.geofence();
                                        if (_model.inArea!) {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            isDismissible: false,
                                            enableDrag: false,
                                            useSafeArea: true,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: SelectRideTypeWidget(),
                                                ),
                                              );
                                            },
                                          ).then((value) => safeSetState(() =>
                                              _model.vehicleType = value));

                                          if (_model.vehicleType != null) {
                                            var ridesRecordReference =
                                                RidesRecord.collection.doc();
                                            await ridesRecordReference.set({
                                              ...createRidesRecordData(
                                                startTime: getCurrentTimestamp,
                                                paid: false,
                                                customer: currentUserReference,
                                                rideType: _model
                                                    .vehicleType?.reference,
                                                accepted: false,
                                                start: _model.pickUpGot,
                                                completedButNotPaid: false,
                                                started: false,
                                                canceled: false,
                                              ),
                                              ...mapToFirestore(
                                                {
                                                  'dropoffPoints':
                                                      convertToGeoPointList(
                                                          _model.pointsGot
                                                              ?.map((e) =>
                                                                  e.latLong)
                                                              .withoutNulls
                                                              .toList()),
                                                  'dropoffNames': _model
                                                      .pointsGot
                                                      ?.map((e) => e.title)
                                                      .toList(),
                                                },
                                              ),
                                            });
                                            _model.rideCreated = RidesRecord
                                                .getDocumentFromData({
                                              ...createRidesRecordData(
                                                startTime: getCurrentTimestamp,
                                                paid: false,
                                                customer: currentUserReference,
                                                rideType: _model
                                                    .vehicleType?.reference,
                                                accepted: false,
                                                start: _model.pickUpGot,
                                                completedButNotPaid: false,
                                                started: false,
                                                canceled: false,
                                              ),
                                              ...mapToFirestore(
                                                {
                                                  'dropoffPoints':
                                                      convertToGeoPointList(
                                                          _model.pointsGot
                                                              ?.map((e) =>
                                                                  e.latLong)
                                                              .withoutNulls
                                                              .toList()),
                                                  'dropoffNames': _model
                                                      .pointsGot
                                                      ?.map((e) => e.title)
                                                      .toList(),
                                                },
                                              ),
                                            }, ridesRecordReference);
                                            FFAppState().rideRef =
                                                _model.rideCreated?.reference;
                                            FFAppState().ridePlaced = true;
                                            FFAppState().destinationReached =
                                                false;
                                            FFAppState().remainingDistance =
                                                0.0;
                                            safeSetState(() {});

                                            await currentUserReference!.update({
                                              ...mapToFirestore(
                                                {
                                                  'rideHistory':
                                                      FieldValue.arrayUnion([
                                                    _model
                                                        .rideCreated?.reference
                                                  ]),
                                                },
                                              ),
                                            });
                                            _model.allDrivers =
                                                await actions.queryAllDrivers();
                                            triggerPushNotification(
                                              notificationTitle: 'New Ride',
                                              notificationText:
                                                  'A new ride is available for you.',
                                              notificationSound: 'default',
                                              userRefs: _model.allDrivers!
                                                  .map((e) => e.reference)
                                                  .toList(),
                                              initialPageName: 'Home',
                                              parameterData: {},
                                            );

                                            context.goNamed(
                                              SearchingDriverWidget.routeName,
                                              queryParameters: {
                                                'rideDocument': serializeParam(
                                                  _model.rideCreated,
                                                  ParamType.Document,
                                                ),
                                                'allDrivers': serializeParam(
                                                  _model.allDrivers,
                                                  ParamType.Document,
                                                  isList: true,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                'rideDocument':
                                                    _model.rideCreated,
                                                'allDrivers': _model.allDrivers,
                                                kTransitionInfoKey:
                                                    TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType.fade,
                                                ),
                                              },
                                            );
                                          }
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Outside Service Area'),
                                                content: Text(
                                                    'Your pickup point currently outside Central Park. Pedicab rides can only be booked from within the park boundaries.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          context.goNamed(
                                            HomeWidget.routeName,
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.fade,
                                              ),
                                            },
                                          );
                                        }
                                      }

                                      safeSetState(() {});
                                    },
                                    text: 'Famous Points',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 50.0,
                                      padding: EdgeInsets.all(0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            fontSize: 17.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
