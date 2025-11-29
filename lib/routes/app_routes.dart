part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const GUEST = _Paths.GUEST;
  static const AUTH = _Paths.AUTH;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const STUDENT = _Paths.STUDENT;
  static const TEST = _Paths.TEST;
  static const ATTENDANCE = _Paths.ATTENDANCE;
  static const STAFF_SIGNUP = _Paths.STAFF_SIGNUP;
  static const STAFF_MANAGEMENT = _Paths.STAFF_MANAGEMENT;
  static const ANOUNCEMENT = _Paths.ANOUNCEMENT;
  static const TIMETABLE = _Paths.TIMETABLE;
  static const VIEWTIMETABLE = _Paths.VIEWTIMETABLE;
  static const NAVBAR = _Paths.NAVBAR;
  static const PROFILE = _Paths.PROFILE;
}

abstract class _Paths {
  _Paths._();

  static const NAVBAR = '/navbar';
  static const GUEST = '/guest';
  static const TEST = '/test';
  static const AUTH = '/auth';
  static const DASHBOARD = '/dashboard';
  static const STUDENT = '/student';
  static const ATTENDANCE = '/attendace';
  static const STAFF_SIGNUP = '/staff-signup';
  static const STAFF_MANAGEMENT = '/staff-management';
  static const ANOUNCEMENT = '/anounce';
  static const TIMETABLE = '/time';
  static const VIEWTIMETABLE = '/viewtime';
  static const PROFILE = '/profile';
}
