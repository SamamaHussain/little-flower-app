import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/announcement_controller.dart';
import 'package:little_flower_app/controllers/weather_controller.dart';
import 'package:little_flower_app/routes/app_pages.dart';
import 'package:little_flower_app/utils/colors.dart';

class GuestPage extends GetView<AnnouncementsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Top Section (same as dashboard)
              _buildCustomTopBar(),

              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // School Profile Section (similar to user profile in dashboard)
                    _buildSchoolProfileSection(),
                    SizedBox(height: 24.h),

                    // Quick Stats (similar to overview cards)
                    _buildQuickPreview(),
                    SizedBox(height: 24.h),

                    // Live Announcements (same style as dashboard)
                    _buildLiveAnnouncements(),
                    SizedBox(height: 24.h),

                    // School Information (similar to management tiles)
                    Text(
                      'School Information',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildSchoolInfoTiles(),
                  ],
                ),
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
                // Login Button (simple and clean like dashboard menu)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.toNamed(Routes.AUTH),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: Text(
                          'Staff Login',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSchoolProfileSection() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        children: [
          // School Logo on Left with JPEG image
          Container(
            width: 80.w,
            height: 80.w, // Use same value for perfect circle
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
              child: Image.asset(
                'lfs_logo2.jpeg',
                fit: BoxFit.cover, // Ensures image fills the circle
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
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 30.w,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 22.w),
          // School Info (similar to user info)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF718096),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Little Flower School',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 3.h),
                Container(height: 0.8, width: 185.w, color: Colors.black),
                SizedBox(height: 3.h),
                Text(
                  'Excellence in Education',
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

  Widget _buildQuickPreview() {
    return Row(
      children: [
        Expanded(
          child: _buildPreviewCard(
            'Expert Faculty',
            'assets/icons/teacher1.png',
            AppColors.lightBlue, // Icon background color
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildPreviewCard(
            'Modern Facilities',
            'assets/icons/building.png',
            AppColors.green,
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildPreviewCard(
            'Quality Education',
            'assets/icons/graduation.png',
            AppColors.yellow,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard(String title, String imagePath, Color iconBgColor) {
    return Container(
      height: 150, // Increased height ✔
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white, // No color on card ✔
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // BIGGER Icon with rounded colored background ✔
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: iconBgColor, // Icon background color ✔
              borderRadius: BorderRadius.circular(23),
            ),
            padding: EdgeInsets.all(22),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),

          SizedBox(height: 10.h),

          // Text under icon with black color ✔
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black, // Black text ✔
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveAnnouncements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Announcements',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          // Loading state
          if (controller.announcements.isEmpty) {
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
              // Format date like in top section
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
                        fontSize: 17.sp, // Bigger text
                        fontWeight: FontWeight.w700, // Bolder title
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    // Divider for separation
                    Container(height: 1.h, color: Color(0xFFE2E8F0)),
                    SizedBox(height: 8.h),
                    // Content - focused color, reduced weight
                    Text(
                      announcement.content,
                      style: TextStyle(
                        fontSize: 15.sp, // Bigger text
                        fontWeight: FontWeight
                            .w400, // Reduced weight instead of dim color
                        color: Color(
                          0xFF2D3748,
                        ), // Same color as title but with reduced weight
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

  Widget _buildSchoolInfoTiles() {
    final infoItems = [
      SchoolInfoItem(
        title: 'School Hours',
        subtitle: '7:30 AM - 2:30 PM',
        imagePath: 'assets/icons/info/clock.png', // PNG path
        color: AppColors.green,
      ),
      SchoolInfoItem(
        title: 'Office Hours',
        subtitle: '7:00 AM - 4:00 PM',
        imagePath: 'assets/icons/info/working-time.png', // PNG path
        color: AppColors.lightBlue,
      ),
      SchoolInfoItem(
        title: 'Contact Information',
        subtitle: '+1 (555) 123-4567\ninfo@school.edu',
        imagePath: 'assets/icons/info/contact-us.png', // PNG path
        color: AppColors.pink,
      ),
      SchoolInfoItem(
        title: 'Visit Our Campus',
        subtitle: '123 Education Street, City',
        imagePath: 'assets/icons/info/location.png', // PNG path
        color: AppColors.yellow,
      ),
    ];

    return Column(
      children: infoItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _buildInfoTile(item, index),
        );
      }).toList(),
    );
  }

  Widget _buildInfoTile(SchoolInfoItem item, int index) {
    // Define color palette for shuffling backgrounds
    final colors = [
      AppColors.lightBlue,
      AppColors.pink,
      AppColors.green,
      AppColors.yellow,
    ];
    final iconBgColor = colors[index % colors.length];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // PNG ICON WITH SHUFFLING COLORFUL BG
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(item.imagePath, width: 22.w, height: 22.w),
          ),

          SizedBox(width: 12.w),

          // TEXT COLUMN (everything else remains the same)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SchoolInfoItem {
  final String title;
  final String subtitle;
  final String imagePath; // Changed from IconData to String
  final Color color;

  SchoolInfoItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.color,
  });
}
