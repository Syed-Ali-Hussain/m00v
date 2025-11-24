import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/components/dropoff/dropoff_widget.dart';
import '/components/pick_up/pick_up_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/passenger/select_ride_type/select_ride_type_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'where_to_model.dart';
export 'where_to_model.dart';

class WhereToWidget extends StatefulWidget {
  const WhereToWidget({
    super.key,
    this.rideType,
  });

  final RideTypesRecord? rideType;

  static String routeName = 'whereTo';
  static String routePath = '/whereTo';

  @override
  State<WhereToWidget> createState() => _WhereToWidgetState();
}

class _WhereToWidgetState extends State<WhereToWidget>
    with TickerProviderStateMixin {
  late WhereToModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WhereToModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.sessionToken = await actions.randomNumber();
      _model.sessionTokenUUID = _model.sessionToken;
      safeSetState(() {});
      if (widget.rideType != null) {
        _model.rideType = widget.rideType;
        safeSetState(() {});
      }
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
              child: PickUpWidget(
                token: _model.sessionTokenUUID!,
              ),
            ),
          );
        },
      ).then((value) => safeSetState(() => _model.pickUpGot = value));

      _model.pickup = _model.pickUpGot;
      safeSetState(() {});
      _model.inArea = await actions.geofence();
      if (_model.inArea!) {
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
                child: DropoffWidget(
                  token: _model.sessionTokenUUID!,
                ),
              ),
            );
          },
        ).then((value) => safeSetState(() => _model.firstDropoff = value));

        if (_model.firstDropoff != null) {
          _model.addToLocations(_model.firstDropoff!);
          safeSetState(() {});
        } else {
          context.goNamed(
            HomeWidget.routeName,
            extra: <String, dynamic>{
              kTransitionInfoKey: TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.fade,
              ),
            },
          );
        }
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Outside Service Area'),
              content: Text(
                  'Your pickup point currently outside Central Park. Pedicab rides can only be booked from within the park boundaries.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );

        context.goNamed(
          HomeWidget.routeName,
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
            ),
          },
        );
      }
    });

    animationsMap.addAll({
      'iconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          TiltEffect(
            curve: Curves.easeInOutQuint,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0, 0),
            end: Offset(0, 3.142),
          ),
          TintEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: FlutterFlowTheme.of(context).error,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Where to?',
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
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          final dropoffs = _model.locations.toList();

                          return ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: dropoffs.length,
                            separatorBuilder: (_, __) => SizedBox(height: 15.0),
                            itemBuilder: (context, dropoffsIndex) {
                              final dropoffsItem = dropoffs[dropoffsIndex];
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    valueOrDefault<String>(
                                      (valueOrDefault<int>(
                                                dropoffsIndex,
                                                1,
                                              ) +
                                              1)
                                          .toString(),
                                      '1',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 100.0,
                                      constraints: BoxConstraints(
                                        minHeight: 40.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15.0, 10.0, 15.0, 10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                valueOrDefault<String>(
                                                  dropoffsItem.name,
                                                  'Dropoff',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
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
                                                          letterSpacing: 0.0,
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
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 10.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderRadius: 12.0,
                                    borderWidth: 2.0,
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: FlutterFlowTheme.of(context).error,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      _model.removeAtIndexFromLocations(
                                          dropoffsIndex);
                                      safeSetState(() {});
                                    },
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              );
                            },
                          );
                        },
                      ),
                      FFButtonWidget(
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
                                  child: DropoffWidget(
                                    token: _model.sessionTokenUUID!,
                                  ),
                                ),
                              );
                            },
                          ).then((value) =>
                              safeSetState(() => _model.dropoffgot = value));

                          if (_model.dropoffgot != null) {
                            _model.addToLocations(_model.dropoffgot!);
                            safeSetState(() {});
                          }

                          safeSetState(() {});
                        },
                        text: 'Add dropoff',
                        icon: Icon(
                          Icons.add_location_alt_outlined,
                          size: 18.0,
                        ),
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconAlignment: IconAlignment.end,
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconColor: FlutterFlowTheme.of(context).accent1,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).accent1,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  var _shouldSetState = false;
                                  if (_model.locations.isNotEmpty) {
                                    _model.tapped = true;
                                    safeSetState(() {});
                                    if (animationsMap[
                                            'iconOnActionTriggerAnimation'] !=
                                        null) {
                                      await animationsMap[
                                              'iconOnActionTriggerAnimation']!
                                          .controller
                                        ..reset()
                                        ..repeat(reverse: true);
                                    }
                                    if (!(widget.rideType != null)) {
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
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: SelectRideTypeWidget(),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() =>
                                          _model.rideTypeSelectedNow = value));

                                      _shouldSetState = true;
                                      if (_model
                                              .rideTypeSelectedNow?.reference !=
                                          null) {
                                        _model.rideType =
                                            _model.rideTypeSelectedNow;
                                        safeSetState(() {});
                                      } else {
                                        if (animationsMap[
                                                'iconOnActionTriggerAnimation'] !=
                                            null) {
                                          animationsMap[
                                                  'iconOnActionTriggerAnimation']!
                                              .controller
                                              .stop();
                                        }
                                        _model.tapped = false;
                                        safeSetState(() {});
                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      }
                                    }

                                    var ridesRecordReference =
                                        RidesRecord.collection.doc();
                                    await ridesRecordReference.set({
                                      ...createRidesRecordData(
                                        paid: false,
                                        startTime: getCurrentTimestamp,
                                        customer: currentUserReference,
                                        rideType: _model.rideType?.reference,
                                        accepted: false,
                                        start: _model.pickup,
                                        completedButNotPaid: false,
                                        started: false,
                                        canceled: false,
                                      ),
                                      ...mapToFirestore(
                                        {
                                          'dropoffPoints':
                                              convertToGeoPointList(_model
                                                  .locations
                                                  .map((e) => e.location)
                                                  .withoutNulls
                                                  .toList()),
                                          'dropoffNames': _model.locations
                                              .map((e) => e.name)
                                              .toList(),
                                        },
                                      ),
                                    });
                                    _model.rideCreated =
                                        RidesRecord.getDocumentFromData({
                                      ...createRidesRecordData(
                                        paid: false,
                                        startTime: getCurrentTimestamp,
                                        customer: currentUserReference,
                                        rideType: _model.rideType?.reference,
                                        accepted: false,
                                        start: _model.pickup,
                                        completedButNotPaid: false,
                                        started: false,
                                        canceled: false,
                                      ),
                                      ...mapToFirestore(
                                        {
                                          'dropoffPoints':
                                              convertToGeoPointList(_model
                                                  .locations
                                                  .map((e) => e.location)
                                                  .withoutNulls
                                                  .toList()),
                                          'dropoffNames': _model.locations
                                              .map((e) => e.name)
                                              .toList(),
                                        },
                                      ),
                                    }, ridesRecordReference);
                                    _shouldSetState = true;
                                    FFAppState().destinationReached = false;
                                    FFAppState().remainingDistance = 0.0;
                                    FFAppState().ridePlaced = true;
                                    FFAppState().rideRef =
                                        _model.rideCreated?.reference;
                                    safeSetState(() {});

                                    await currentUserReference!.update({
                                      ...mapToFirestore(
                                        {
                                          'rideHistory': FieldValue.arrayUnion(
                                              [_model.rideCreated?.reference]),
                                        },
                                      ),
                                    });
                                    _model.driversGot =
                                        await actions.queryAllDrivers();
                                    _shouldSetState = true;
                                    triggerPushNotification(
                                      notificationTitle: 'New Ride!',
                                      notificationText:
                                          'A new ride is available for you.',
                                      notificationSound: 'default',
                                      userRefs: _model.driversGot!
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
                                          _model.driversGot,
                                          ParamType.Document,
                                          isList: true,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        'rideDocument': _model.rideCreated,
                                        'allDrivers': _model.driversGot,
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.fade,
                                        ),
                                      },
                                    );
                                  } else {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text('Destination'),
                                          content: Text(
                                              'Please make sure to choose your dropoff point'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                  if (_shouldSetState) safeSetState(() {});
                                },
                                child: Container(
                                  width: 200.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (!_model.tapped)
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Text(
                                              'Place Ride',
                                              style: FlutterFlowTheme.of(
                                                      context)
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
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
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
                                            ),
                                          ),
                                        if (_model.tapped)
                                          Text(
                                            'Placing ride...',
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
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
                                          ),
                                        Icon(
                                          FFIcons.kflowArrowThin,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          size: 24.0,
                                        ).animateOnActionTrigger(
                                          animationsMap[
                                              'iconOnActionTriggerAnimation']!,
                                        ),
                                      ].divide(SizedBox(width: 10.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(height: 20.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
