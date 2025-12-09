import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/announcement_controller.dart';
import 'package:little_flower_app/controllers/picture_controller.dart';
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

          // Show full screen loading until everything is ready
          if (isLoading) {
            return _buildFullScreenLoading();
          }

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                      _buildUserProfileSection(authController, staffController),
                      SizedBox(height: 24.h),

                      // Quick Overview
                      _buildQuickOverview(studentsController, staffController),
                      SizedBox(height: 24.h),

                      // Live Announcements
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
          );
        }),
      ),
    );
  }

  Widget _buildFullScreenLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3.w,
            color: AppColors.darkBlue,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading Dashboard...',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(AuthController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logout icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 32.w,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 12.h),

              // Message
              Text(
                'Are you sure you want to logout from your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF718096),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF718096),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day and Date in Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$dayName,',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                  height: 1,
                ),
              ),
              SizedBox(width: 5.w),
              Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF718096),
                    height: 1,
                  ),
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
                              AppColors.darkBlue,
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
                SizedBox(width: 10.w),
                // Menu Button
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.darkBlue,
                    size: 22.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 8,
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutConfirmationDialog(controller);
                    } else if (value == 'profile') {
                      Get.toNamed(Routes.PROFILE);
                    } else if (value == 'notifications') {
                      _showNotifications();
                    } else if (value == 'refresh_weather') {
                      weatherController.refreshWeather();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'refresh_weather',
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: AppColors.darkBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.refresh_rounded,
                                size: 16.w,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Refresh Weather',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'profile',
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: AppColors.darkBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 18.w,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'My Profile',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                size: 18.w,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
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
    final PictureController pictureController = Get.find<PictureController>();

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        children: [
          // Profile Picture on Left
          Obx(() {
            // If user is NOT admin, always show default image
            if (!authController.isAdmin) {
              return _buildDefaultProfileImage();
            }

            // If user IS admin, show loading/Firestore image
            if (pictureController.isLoading.value) {
              return Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.darkBlue,
                  ),
                ),
              );
            }

            return Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: Offset(0, 3),
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ClipOval(
                child: pictureController.profilePicUrl.value.isNotEmpty
                    ? Image.network(
                        pictureController.profilePicUrl.value,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.darkBlue.withOpacity(0.7),
                                  AppColors.darkBlue,
                                ],
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultProfileImage();
                        },
                      )
                    : _buildDefaultProfileImage(),
              ),
            );
          }),
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
                Text(
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
                Text(
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
  }

  Widget _buildDefaultProfileImage() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkBlue, AppColors.darkBlue],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 3),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Icon(Icons.person_rounded, color: Colors.white, size: 30.w),
    );
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
        // Empty state
        if (controller.announcements.isEmpty)
          Container(
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
          )
        else
          // Show only the latest 3 announcements
          ...controller.announcements.take(3).map((announcement) {
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
          }),
      ],
    );
  }

  Widget _buildQuickOverview(
    StudentsController studentsController,
    StaffController staffController,
  ) {
    // Get real data from controllers
    final activeStudents = studentsController.students
        .where((s) => s.isActive)
        .length;
    final totalStaff = staffController.staffList.length;

    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Total Students',
            activeStudents.toString(),
            'assets/icons/students.png',
            AppColors.pink,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildOverviewCard(
            'Teaching Staff',
            totalStaff.toString(),
            'assets/icons/staff.png',
            AppColors.lightBlue,
          ),
        ),
      ],
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
      baseItems.insert(
        3,
        DashboardItem(
          title: 'School Info',
          imagePath: 'assets/icons/edit-info.png',
          route: Routes.INFO,
          color: AppColors.lightBlue,
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
      case '/info':
        Get.toNamed(Routes.INFO);
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
