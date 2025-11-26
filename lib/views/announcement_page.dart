import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/announcement_controller.dart';
import 'package:little_flower_app/models/announcement_model.dart';
import 'package:little_flower_app/utils/colors.dart';

class AnnouncementsAdminPage extends GetView<AnnouncementsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomHeader(),
                  SizedBox(height: 30.h),
                  // Header Stats
                  _buildHeaderStats(),
                  SizedBox(height: 20.h),

                  // Announcements List
                  controller.announcements.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.announcements.length,
                          itemBuilder: (context, index) {
                            final announcement =
                                controller.announcements[index];
                            return _buildAnnouncementCard(announcement, index);
                          },
                        ),
                ],
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateAnnouncementDialog(),
        backgroundColor: Color(0xFF3F4072),
        child: Icon(Icons.add_rounded, color: Colors.white, size: 24.w),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button and title
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF2D3748)),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
            SizedBox(width: 12.w),
            Text(
              'Manage Announcements',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.announcement_rounded,
              size: 40.w,
              color: Color(0xFF3F4072),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Loading Announcements...',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Color(0xFF3F4072).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.announcement_rounded,
              color: Color(0xFF3F4072),
              size: 28.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Announcements',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Obx(
                  () => Text(
                    '${controller.announcements.length}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Color(0xFF06D6A0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Color(0xFF06D6A0).withOpacity(0.3)),
            ),
            child: Text(
              'Active',
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF06D6A0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAnnouncementsList() {
  //   return ListView.builder(
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: controller.announcements.length,
  //     itemBuilder: (context, index) {
  //       final announcement = controller.announcements[index];
  //       return _buildAnnouncementCard(announcement, index);
  //     },
  //   );
  // }

  Widget _buildAnnouncementCard(Announcement announcement, int index) {
    final isRecent = DateTime.now().difference(announcement.date).inDays < 2;

    return Container(
      key: Key(announcement.id ?? 'announcement_${announcement.hashCode}'),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: announcementColors[index % announcementColors.length]
            .withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        // border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => _showAnnouncementDetails(announcement),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isRecent)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF06D6A0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: Color(0xFF06D6A0).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Color(0xFF06D6A0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          SizedBox(height: isRecent ? 8.h : 0),
                          Text(
                            announcement.title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3748),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildPopupMenu(announcement),
                  ],
                ),
                SizedBox(height: 8.h),

                // Content
                Text(
                  announcement.content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),

                // Footer with date
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Color(0xFF3F4072).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        size: 14.w,
                        color: Color(0xFF3F4072),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _formatDate(announcement.date),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF718096),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (announcement.updatedAt != null) ...[
                      SizedBox(width: 16.w),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 12.w,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Updated ${_formatDate(announcement.updatedAt!)}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(Announcement announcement) {
    return Transform.translate(
      offset: Offset(0, -8.h), // Adjust this value to move it up
      child: PopupMenuButton<String>(
        key: Key('popup_${announcement.id}'),
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert_rounded,
          color: Color(0xFF718096),
          size: 20.w,
        ),
        onSelected: (value) {
          if (value == 'edit') {
            _showEditAnnouncementDialog(announcement);
          } else if (value == 'delete') {
            _showDeleteConfirmation(announcement);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_rounded, color: Color(0xFF3F4072), size: 18.w),
                SizedBox(width: 8.w),
                Text('Edit'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_rounded, color: Colors.red, size: 18.w),
                SizedBox(width: 8.w),
                Text('Delete'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.announcement_outlined,
              size: 48.w,
              color: Color(0xFF3F4072),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Announcements Yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create your first announcement to share\nimportant updates with everyone',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => _showCreateAnnouncementDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3F4072),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            icon: Icon(Icons.add_rounded, size: 18.w),
            label: Text(
              'Create First Announcement',
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDetails(Announcement announcement) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      announcement.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20.w),
                    onPressed: () => Get.back(),
                    color: Color(0xFF718096),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Content
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  announcement.content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF2D3748),
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Date info
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Color(0xFF3F4072).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16.w,
                          color: Color(0xFF3F4072),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Created: ${_formatDate(announcement.date)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                    if (announcement.updatedAt != null) ...[
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 14.w,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Updated: ${_formatDate(announcement.updatedAt!)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Close button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF3F4072),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Announcement announcement) {
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
              // Warning icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 32.w,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                'Delete Announcement?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 12.h),

              // Message
              Text(
                'Are you sure you want to delete this announcement? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF718096),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 8.h),

              // Announcement title
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '"${announcement.title}"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
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
                        controller.deleteAnnouncement(announcement.id!);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text('Delete'),
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

  void _showCreateAnnouncementDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Announcement',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20.w),
                    onPressed: () => Get.back(),
                    color: Color(0xFF718096),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Title field
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter announcement title',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 16.h),

              // Content field
              Text(
                'Content',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter announcement content',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 24.h),

              // Create button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        contentController.text.isNotEmpty) {
                      controller.createAnnouncement(
                        titleController.text,
                        contentController.text,
                      );
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3F4072),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Create Announcement',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditAnnouncementDialog(Announcement announcement) {
    final titleController = TextEditingController(text: announcement.title);
    final contentController = TextEditingController(text: announcement.content);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Announcement',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20.w),
                    onPressed: () => Get.back(),
                    color: Color(0xFF718096),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Title field
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter announcement title',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 16.h),

              // Content field
              Text(
                'Content',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter announcement content',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 24.h),

              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        contentController.text.isNotEmpty) {
                      controller.updateAnnouncement(
                        announcement.id!,
                        titleController.text,
                        contentController.text,
                      );
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3F4072),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Update Announcement',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  final List<Color> announcementColors = [
    AppColors.lightBlue,
    AppColors.green,
    AppColors.pink,
    AppColors.yellow,
  ];
}
