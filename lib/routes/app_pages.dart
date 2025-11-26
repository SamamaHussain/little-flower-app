import 'package:get/route_manager.dart';
import 'package:little_flower_app/bindings/attendance_bindings.dart';
import 'package:little_flower_app/bindings/auth_bindings.dart';
import 'package:little_flower_app/bindings/dashboard_bindings.dart';
import 'package:little_flower_app/bindings/guest_bindings.dart';
import 'package:little_flower_app/bindings/staff_management_bindings.dart';
import 'package:little_flower_app/bindings/staff_signup_bindings.dart';
import 'package:little_flower_app/bindings/student_bindings.dart';
import 'package:little_flower_app/bindings/timetable_bindings.dart';
import 'package:little_flower_app/testing_view.dart';
import 'package:little_flower_app/views/announcement_page.dart';
import 'package:little_flower_app/views/attendance_home_page.dart';
import 'package:little_flower_app/views/auth_page.dart';
import 'package:little_flower_app/views/dashboard_page.dart';
import 'package:little_flower_app/views/guest_page.dart';
import 'package:little_flower_app/views/staff_management_page.dart';
import 'package:little_flower_app/views/staff_signup_page.dart';
import 'package:little_flower_app/views/students_page.dart';
import 'package:little_flower_app/views/timetable_home_page.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.GUEST;
  static const TEST = Routes.TEST;

  static final routes = [
    GetPage(
      name: _Paths.TIMETABLE,
      page: () => TimetableManagement(),
      binding: TimetableBindings(),
    ),
    GetPage(name: _Paths.ANOUNCEMENT, page: () => AnnouncementsAdminPage()),
    GetPage(
      name: _Paths.STAFF_MANAGEMENT,
      page: () => StaffManagementView(),
      binding: StaffManageBindings(),
    ),
    GetPage(
      name: _Paths.STAFF_SIGNUP,
      page: () => StaffSignUpView(),
      binding: StaffSignUpBindings(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE,
      page: () => AttendanceHomeView(),
      binding: AttendanceBindings(),
    ),
    GetPage(name: _Paths.TEST, page: () => TestingView()),
    GetPage(
      name: _Paths.GUEST,
      page: () => GuestPage(),
      binding: GuestBinding(),
    ),
    GetPage(name: _Paths.AUTH, page: () => AuthPage(), binding: AuthBinding()),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBindings(),
    ),
    GetPage(
      name: _Paths.STUDENT,
      page: () => StudentsView(),
      binding: StudentBindings(),
    ),
  ];
}
