import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/announcement_controller.dart';
import 'package:little_flower_app/controllers/staff_controller.dart';
import 'package:little_flower_app/controllers/students_controller.dart';
import 'package:little_flower_app/controllers/weather_controller.dart';
import 'package:little_flower_app/routes/app_pages.dart';
import 'package:little_flower_app/utils/colors.dart';
import '../../controllers/auth_controller.dart';

class DashboardPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final StaffController staffController = Get.find<StaffController>();
    final AnnouncementsController announcementsController =
        Get.find<AnnouncementsController>();
    final StudentsController studentsController =
        Get.find<StudentsController>();

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Obx(() {
          // Check if any data is still loading
          final bool isLoading =
              staffController.isLoading.value ||
              announcementsController.isLoading.value ||
              studentsController.isLoading.value;

          return Stack(
            children: [
              SingleChildScrollView(
                physics: isLoading
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Top Section (replacing AppBar)
                    _buildCustomTopBar(),

                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Profile Section
                          _buildUserProfileSection(
                            authController,
                            staffController,
                          ),
                          SizedBox(height: 24.h),

                          // Quick Overview with loading state
                          _buildQuickOverview(
                            studentsController,
                            staffController,
                          ),
                          SizedBox(height: 24.h),

                          // Live Announcements with loading state
                          _buildLiveAnnouncements(announcementsController),
                          SizedBox(height: 24.h),

                          // Management Heading and Horizontal Tiles
                          Text(
                            'Management',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _buildManagementTiles(authController),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCustomTopBar() {
    // Initialize WeatherController
    final WeatherController weatherController = Get.find<WeatherController>();

    // Get current date and day
    final now = DateTime.now();
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final dayName = days[now.weekday - 1];
    final dateStr = '${now.day} ${months[now.month - 1]}';

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day and Date in Row
          Row(
            children: [
              Text(
                '$dayName,',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),

          // Weather and Temperature - Dynamic with Obx
          Obx(() {
            final weather = weatherController.weather.value;
            final isLoading = weatherController.isLoading.value;

            // Default values if no weather data
            String temperature = '--°C';
            IconData weatherIcon = Icons.wb_sunny_rounded;
            Color iconColor = Color(0xFFFFD166);

            if (weather != null) {
              temperature = '${weather.tempC.toStringAsFixed(0)}°C';

              // Determine icon based on weather condition text
              final condition = weather.conditionText.toLowerCase();

              if (condition.contains('rain') || condition.contains('drizzle')) {
                weatherIcon = Icons.water_drop_rounded;
                iconColor = Color(0xFF4299E1);
              } else if (condition.contains('cloud') ||
                  condition.contains('overcast')) {
                weatherIcon = Icons.cloud_rounded;
                iconColor = Color(0xFF94A3B8);
              } else if (condition.contains('snow') ||
                  condition.contains('blizzard')) {
                weatherIcon = Icons.ac_unit_rounded;
                iconColor = Color(0xFF93C5FD);
              } else if (condition.contains('thunder') ||
                  condition.contains('storm')) {
                weatherIcon = Icons.thunderstorm_rounded;
                iconColor = Color(0xFF7C3AED);
              } else if (condition.contains('fog') ||
                  condition.contains('mist')) {
                weatherIcon = Icons.blur_on_rounded;
                iconColor = Color(0xFF9CA3AF);
              } else if (condition.contains('clear') ||
                  condition.contains('sunny')) {
                // Use day/night indicator
                if (weather.isDay == 1) {
                  weatherIcon = Icons.wb_sunny_rounded;
                  iconColor = Color(0xFFFFD166);
                } else {
                  weatherIcon = Icons.nights_stay_rounded;
                  iconColor = Color(0xFF818CF8);
                }
              } else if (condition.contains('partly cloudy')) {
                if (weather.isDay == 1) {
                  weatherIcon = Icons.wb_cloudy_rounded;
                  iconColor = Color(0xFFFBBF24);
                } else {
                  weatherIcon = Icons.cloud_outlined;
                  iconColor = Color(0xFF818CF8);
                }
              }
            }

            return Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? Padding(
                          padding: EdgeInsets.all(8.w),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF4299E1),
                            ),
                          ),
                        )
                      : Icon(weatherIcon, color: iconColor, size: 20.w),
                ),
                SizedBox(width: 8.w),
                Text(
                  temperature,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(width: 12.w),
                // Menu Button
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, color: Color(0xFF4A5568)),
                  onSelected: (value) {
                    if (value == 'logout') {
                      controller.logout();
                    } else if (value == 'profile') {
                      _showProfile();
                    } else if (value == 'notifications') {
                      _showNotifications();
                    } else if (value == 'refresh_weather') {
                      weatherController.refreshWeather();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'refresh_weather',
                      child: Row(
                        children: [
                          Icon(Icons.refresh_rounded, color: Colors.blue[700]),
                          SizedBox(width: 8.w),
                          Text('Refresh Weather'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'notifications',
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.blue[700],
                          ),
                          SizedBox(width: 8.w),
                          Text('Notifications'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_rounded, color: Colors.blue[700]),
                          SizedBox(width: 8.w),
                          Text('My Profile'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout_rounded, color: Colors.red),
                          SizedBox(width: 8.w),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection(
    AuthController authController,
    StaffController staffController,
  ) {
    return Obx(() {
      final isLoading = staffController.isLoading.value;

      return Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Row(
          children: [
            // Profile Picture on Left
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: isLoading
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.grey[500],
                          size: 30.w,
                        ),
                      )
                    : Image.network(
                        'https://via.placeholder.com/150', // Replace with actual profile image URL
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF3F4072), Color(0xFF3F4072)],
                              ),
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 30.w,
                            ),
                          );
                        },
                      ),
              ),
            ),
            SizedBox(width: 22.w),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF718096),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  isLoading
                      ? Container(
                          width: 120.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        )
                      : Text(
                          '${staffController.currentStaff.value?.firstName} ${staffController.currentStaff.value?.lastName}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                  SizedBox(height: 3.h),
                  Container(height: 0.8, width: 120.w, color: Colors.black),
                  SizedBox(height: 3.h),
                  isLoading
                      ? Container(
                          width: 80.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        )
                      : Text(
                          authController.isAdmin ? 'Principal' : 'Teacher',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLiveAnnouncements(AnnouncementsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Announcements',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          // Loading state
          if (controller.isLoading.value) {
            return _buildAnnouncementsLoading();
          }

          // Empty state
          if (controller.announcements.isEmpty) {
            return Container(
              padding: EdgeInsets.all(25.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'No announcements available',
                  style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
                ),
              ),
            );
          }

          // Show only the latest 3 announcements
          final latestAnnouncements = controller.announcements.take(3).toList();

          return Column(
            children: latestAnnouncements.map((announcement) {
              // Format date like in guest page
              final months = [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ];
              final dateStr =
                  '${announcement.date.day} ${months[announcement.date.month - 1]}';

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with icon and date in same background container
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.yellow.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Small icon
                          Icon(
                            Icons.campaign_rounded,
                            color: AppColors.darkBlue,
                            size: 14.w,
                          ),
                          SizedBox(width: 6.w),
                          // Date
                          Text(
                            dateStr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Title
                    Text(
                      announcement.title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    // Divider for separation
                    Container(height: 1.h, color: Color(0xFFE2E8F0)),
                    SizedBox(height: 8.h),
                    // Content
                    Text(
                      announcement.content,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2D3748),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildAnnouncementsLoading() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loading header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      width: 40.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              // Loading title
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 8.h),
              // Divider
              Container(height: 1.h, color: Color(0xFFE2E8F0)),
              SizedBox(height: 8.h),
              // Loading content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 200.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuickOverview(
    StudentsController studentsController,
    StaffController staffController,
  ) {
    return Obx(() {
      final bool isLoading =
          studentsController.isLoading.value || staffController.isLoading.value;

      // Get real data from controllers
      // final totalStudents = studentsController.students.length;
      final activeStudents = studentsController.students
          .where((s) => s.isActive)
          .length;
      final totalStaff = staffController.staffList.length;

      return Row(
        children: [
          Expanded(
            child: isLoading
                ? _buildOverviewCardLoading(AppColors.pink)
                : _buildOverviewCard(
                    'Total Students',
                    activeStudents.toString(),
                    'assets/icons/students.png',
                    AppColors.pink,
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: isLoading
                ? _buildOverviewCardLoading(AppColors.lightBlue)
                : _buildOverviewCard(
                    'Teaching Staff',
                    totalStaff.toString(),
                    'assets/icons/staff.png',
                    AppColors.lightBlue,
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildOverviewCardLoading(Color backgroundColor) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [backgroundColor.withOpacity(0.4), backgroundColor],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: backgroundColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: 60.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            width: 100.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
    String title,
    String value,
    String imagePath,
    Color backgroundColor,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [backgroundColor.withOpacity(0.4), backgroundColor],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: backgroundColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.asset(imagePath, width: 22.w, height: 22.w),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A202C),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementTiles(AuthController authController) {
    return Obx(() {
      final menuItems = _getMenuItems(authController.isAdmin);

      return Column(
        children: menuItems.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildHorizontalTile(item),
          );
        }).toList(),
      );
    });
  }

  List<DashboardItem> _getMenuItems(bool isAdmin) {
    final baseItems = [
      DashboardItem(
        title: 'Student Management',
        imagePath: 'assets/icons/students.png',
        route: '/students',
        color: AppColors.pink,
      ),
      DashboardItem(
        title: 'Attendance Tracker',
        imagePath: 'assets/icons/checklist.png',
        route: '/attendance',
        color: AppColors.green,
      ),
      DashboardItem(
        title: 'Timetable Management',
        imagePath: 'assets/icons/schedule.png',
        route: '/fees',
        color: AppColors.yellow,
      ),
    ];

    if (isAdmin) {
      baseItems.insert(
        3,
        DashboardItem(
          title: 'School Announcements',
          imagePath: 'assets/icons/advertisement.png',
          route: '/announcements',
          color: Color(0xFFFECBE2),
        ),
      );
    }

    if (isAdmin) {
      baseItems.add(
        DashboardItem(
          title: 'Staff Management',
          imagePath: 'assets/icons/staff.png',
          route: '/staff-manage',
          color: Color(0xFFB0F5FF),
        ),
      );
    }

    return baseItems;
  }

  Widget _buildHorizontalTile(DashboardItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToModule(item.route),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              // Colorful image background
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Image.asset(
                  item.imagePath,
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              // Colored rounded background for forward arrow
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.w,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToModule(String route) {
    switch (route) {
      case '/students':
        Get.toNamed(Routes.STUDENT);
        break;
      case '/attendance':
        Get.toNamed(Routes.ATTENDANCE);
        break;
      case '/fees':
        Get.toNamed(Routes.TIMETABLE);
        break;
      case '/announcements':
        Get.toNamed(Routes.ANOUNCEMENT);
        break;
      case '/staff-manage':
        Get.toNamed(Routes.STAFF_MANAGEMENT);
        break;
      case '/exam-results':
        _showComingSoon('Exam Results');
        break;
      default:
        _showComingSoon('This Module');
    }
  }

  void _showComingSoon(String moduleName) {
    Get.snackbar(
      'Coming Soon',
      '$moduleName module is under development',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue[800],
      colorText: Colors.white,
      borderRadius: 12.r,
      margin: EdgeInsets.all(16.w),
    );
  }

  void _showNotifications() {
    Get.snackbar(
      'Notifications',
      'No new notifications',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[800]!,
      colorText: Colors.white,
    );
  }

  void _showProfile() {
    Get.snackbar(
      'Profile',
      'Profile section coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class DashboardItem {
  final String title;
  final String imagePath;
  final String route;
  final Color color;

  DashboardItem({
    required this.title,
    required this.imagePath,
    required this.route,
    required this.color,
  });
}
