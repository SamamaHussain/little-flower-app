import 'package:get/get.dart';
import 'package:little_flower_app/models/timetable_model.dart';
import 'package:little_flower_app/services/timetable_services.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';

class TimetableController extends GetxController {
  final TimetableServices _timetableServices = TimetableServices();

  final RxList<ClassTimetable> classTimetables = <ClassTimetable>[].obs;
  final Rx<ClassTimetable?> selectedClassTimetable = Rx<ClassTimetable?>(null);
  final RxString selectedDay = 'Monday'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString selectedGradeForDialog = ''.obs;
  final RxString selectedSectionForDialog = ''.obs;

  // Available days of the week
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Available grades and sections
  final List<String> grades = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];
  final List<String> sections = ['A', 'B', 'C', 'D'];

  @override
  void onInit() {
    fetchAllClassTimetables();
    selectedGradeForDialog.value = grades.first;
    selectedSectionForDialog.value = sections.first;
    super.onInit();
  }

  // ---------------------------------------------------------------------------
  // FETCH ALL CLASS TIMETABLES
  // ---------------------------------------------------------------------------
  Future<void> fetchAllClassTimetables() async {
    try {
      isLoading.value = true;
      final timetables = await _timetableServices.getAllClassTimetables();
      classTimetables.assignAll(timetables);
    } catch (e) {
      AppSnackbar.error('Failed to load timetables');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // SELECT CLASS TIMETABLE
  // ---------------------------------------------------------------------------
  Future<void> selectClassTimetable(String grade, String section) async {
    try {
      isLoading.value = true;
      final timetable = await _timetableServices.getTimetableForClass(
        grade,
        section,
      );
      selectedClassTimetable.value = timetable;

      // If no timetable exists, create an empty one
      if (timetable == null) {
        selectedClassTimetable.value = ClassTimetable(
          id: '',
          grade: grade,
          section: section,
          weeklyTimetable: daysOfWeek
              .map((day) => DailyTimetable(day: day, timeSlots: []))
              .toList(),
          createdAt: DateTime.now(),
        );
      }
    } catch (e) {
      AppSnackbar.error('Failed to load timetable');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // ADD TIME SLOT TO CURRENT DAY
  // ---------------------------------------------------------------------------
  void addTimeSlotToCurrentDay() {
    if (selectedClassTimetable.value == null) return;

    final currentDayTimetable = selectedClassTimetable.value!
        .getTimetableForDay(selectedDay.value);
    final newTimeSlot = TimeSlot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: '09:00 AM',
      endTime: '10:00 AM',
      subject: '',
      teacher: '',
      isBreak: false,
    );

    final updatedTimeSlots = [...currentDayTimetable!.timeSlots, newTimeSlot];
    updateTimeSlotsForCurrentDay(updatedTimeSlots);
  }

  // ---------------------------------------------------------------------------
  // UPDATE TIME SLOTS FOR CURRENT DAY
  // ---------------------------------------------------------------------------
  void updateTimeSlotsForCurrentDay(List<TimeSlot> timeSlots) {
    if (selectedClassTimetable.value == null) return;

    final updatedWeeklyTimetable = selectedClassTimetable.value!.weeklyTimetable
        .map((daily) {
          if (daily.day == selectedDay.value) {
            return DailyTimetable(day: daily.day, timeSlots: timeSlots);
          }
          return daily;
        })
        .toList();

    selectedClassTimetable.value = selectedClassTimetable.value!.copyWith(
      weeklyTimetable: updatedWeeklyTimetable,
      updatedAt: DateTime.now(),
    );
  }

  // ---------------------------------------------------------------------------
  // UPDATE INDIVIDUAL TIME SLOT
  // ---------------------------------------------------------------------------
  void updateTimeSlot(String timeSlotId, TimeSlot updatedSlot) {
    if (selectedClassTimetable.value == null) return;

    final currentDayTimetable = selectedClassTimetable.value!
        .getTimetableForDay(selectedDay.value);
    final updatedTimeSlots = currentDayTimetable!.timeSlots.map((slot) {
      if (slot.id == timeSlotId) {
        return updatedSlot;
      }
      return slot;
    }).toList();

    updateTimeSlotsForCurrentDay(updatedTimeSlots);
  }

  // ---------------------------------------------------------------------------
  // DELETE TIME SLOT
  // ---------------------------------------------------------------------------
  void deleteTimeSlot(String timeSlotId) {
    if (selectedClassTimetable.value == null) return;

    final currentDayTimetable = selectedClassTimetable.value!
        .getTimetableForDay(selectedDay.value);
    final updatedTimeSlots = currentDayTimetable!.timeSlots
        .where((slot) => slot.id != timeSlotId)
        .toList();

    updateTimeSlotsForCurrentDay(updatedTimeSlots);
  }

  // ---------------------------------------------------------------------------
  // SAVE TIMETABLE
  // ---------------------------------------------------------------------------
  Future<bool> saveTimetable() async {
    if (selectedClassTimetable.value == null) return false;

    try {
      isSaving.value = true;
      await _timetableServices.saveClassTimetable(
        selectedClassTimetable.value!,
      );

      AppSnackbar.success('Timetable saved successfully');

      await fetchAllClassTimetables();
      return true;
    } catch (e) {
      AppSnackbar.error('Failed to save timetable');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE TIMETABLE
  // ---------------------------------------------------------------------------
  Future<void> deleteTimetable(String timetableId) async {
    try {
      isLoading.value = true;
      await _timetableServices.deleteClassTimetable(timetableId);

      AppSnackbar.success('Timetable deleted successfully');

      await fetchAllClassTimetables();
      selectedClassTimetable.value = null;
    } catch (e) {
      AppSnackbar.error('Failed to delete timetable');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // GET TIMETABLE FOR DISPLAY
  // ---------------------------------------------------------------------------
  DailyTimetable? getCurrentDayTimetable() {
    if (selectedClassTimetable.value == null) return null;
    return selectedClassTimetable.value!.getTimetableForDay(selectedDay.value);
  }

  // ---------------------------------------------------------------------------
  // CHECK IF CLASS HAS TIMETABLE
  // ---------------------------------------------------------------------------
  bool hasTimetable(String grade, String section) {
    return classTimetables.any(
      (timetable) => timetable.grade == grade && timetable.section == section,
    );
  }

  // ---------------------------------------------------------------------------
  // CREATE EMPTY TIMETABLE FOR CLASS
  // ---------------------------------------------------------------------------
  void createEmptyTimetableForClass(String grade, String section) {
    selectedClassTimetable.value = ClassTimetable(
      id: '',
      grade: grade,
      section: section,
      weeklyTimetable: daysOfWeek
          .map((day) => DailyTimetable(day: day, timeSlots: []))
          .toList(),
      createdAt: DateTime.now(),
    );
  }
}
