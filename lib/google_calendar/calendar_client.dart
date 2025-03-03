import 'package:googleapis/calendar/v3.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class CalendarClient {
  static CalendarApi? calendar;

  Future<Map<String, String>> insert({
    required String title,
    required String description,
    required String location,
    required List<EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    bool hasConferenceSupport = false,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    Map<String, String> eventData = {};

    String calendarId = "primary";
    Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    if (hasConferenceSupport) {
      ConferenceData conferenceData = ConferenceData();
      CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
      conferenceRequest.requestId = "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
      conferenceData.createRequest = conferenceRequest;

      event.conferenceData = conferenceData;
    }

    EventDateTime start = EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    EventDateTime end = EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    try {
      await calendar?.events.insert(event, calendarId, conferenceDataVersion: hasConferenceSupport ? 1 : 0, sendUpdates: shouldNotifyAttendees ? "all" : "none").then((value) {
        log("${locale.value.eventStatus}: ${value.status}");
        if (value.status == "confirmed") {
          toast(locale.value.eventAddedSuccessfully);

          if (hasConferenceSupport) {
            String eventId;
            eventId = value.id!;
            String joiningLink = "https://meet.google.com/${value.conferenceData?.conferenceId}";
            eventData = {'id': eventId, 'link': joiningLink};
          } else {
            eventData = {"status": value.status.validate()};
          }

          log('Event updated in google calendar');
        } else {
          log("Unable to update event in google calendar");
        }
      });
    } catch (e) {
      toast(e.toString());
      log('Error creating event $e');
    }

    return eventData;
  }

  Future<Map<String, String>> modify({
    required String id,
    required String title,
    required String description,
    required String location,
    required List<EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    bool hasConferenceSupport = false,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    Map<String, String> eventData = {};

    String calendarId = "primary";
    Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    EventDateTime start = EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    EventDateTime end = EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    try {
      await calendar?.events.patch(event, calendarId, id, conferenceDataVersion: hasConferenceSupport ? 1 : 0, sendUpdates: shouldNotifyAttendees ? "all" : "none").then((value) {
        log("${locale.value.eventStatus} : ${value.status}");
        if (value.status == "confirmed") {
          toast(locale.value.eventAddedSuccessfully);

          if (hasConferenceSupport) {
            String eventId;
            eventId = value.id!;
            String joiningLink = "https://meet.google.com/${value.conferenceData?.conferenceId}";
            eventData = {'id': eventId, 'link': joiningLink};
          } else {
            eventData = {"status": value.status.validate()};
          }

          log('Event updated in google calendar');
        } else {
          log("Unable to update event in google calendar");
        }
      });
    } catch (e) {
      toast(e.toString());
      log('Error updating event $e');
    }

    return eventData;
  }

  Future<void> delete(String eventId, bool shouldNotify) async {
    String calendarId = "primary";

    try {
      await calendar?.events.delete(calendarId, eventId, sendUpdates: shouldNotify ? "all" : "none").then((value) {
        log('Event deleted from Google Calendar');
      });
    } catch (e) {
      log('Error deleting event: $e');
    }
  }
}
