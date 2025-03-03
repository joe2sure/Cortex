import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'calendar_client.dart';
import 'package:url_launcher/url_launcher.dart';

GoogleSignInAccount? _currentUser;

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    cal.CalendarApi.calendarScope,
    cal.CalendarApi.calendarEventsScope,
  ],
);

Future<void> handleSignIn() async {
  try {
    _currentUser = await _googleSignIn.signInSilently();
    _currentUser ??= await _googleSignIn.signIn();
  } catch (error) {
    log('handleSignIn ERROR: $error');
  }
}

Future<bool> addToGoogleCalendar({
  required String title,
  required String description,
  required String location,
  List<EventAttendee> attendeeEmailList = const <EventAttendee>[],
  bool shouldNotifyAttendees = false,
  bool hasConferenceSupport = false,
  required DateTime startTime,
  required DateTime endTime,
}) async {
  bool isSuccess = false;
  await handleSignIn().then((value) async {
    // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
    if (client == null) {
      toast("Something went wrong! Please try again!");
    } else {
      cal.CalendarApi calsd = cal.CalendarApi(client);
      CalendarClient calendarClient = CalendarClient();
      CalendarClient.calendar = calsd;
      try {
        await calendarClient
            .insert(
          title: title,
          description: description,
          location: location,
          attendeeEmailList: attendeeEmailList,
          shouldNotifyAttendees: shouldNotifyAttendees,
          hasConferenceSupport: hasConferenceSupport,
          startTime: startTime.toUtc(),
          endTime: endTime.toUtc(),
        )
            .then((value) {
          log('------> calendarClient.insert VALUE: $value');
          if (hasConferenceSupport) {
            if (value.isNotEmpty) {
              log('Event added to Google Calendar');
              return value["link"];
            } else {
              log("Unable to add event to Google Calendar +-+-+-+-+-+-+-");
            }
          } else {
            log('VALUE["STATUS"]: ${value["status"]}');
            isSuccess = value["status"] == "confirmed";
          }
        });
      } catch (e) {
        toast(e.toString());
        log('Error creating event $e');
      }
    }
  }).catchError((e) {
    toast(e.toString());
    log("=>>>>$e");
  });
  return isSuccess;
}

void prompt(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
