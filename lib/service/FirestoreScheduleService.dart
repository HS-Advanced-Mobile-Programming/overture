import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overture/models/schedule_model_files/schedule_model.dart';
import 'package:overture/service/ScheduleDto.dart';

class FirestoreScheduleService {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('schedules');

  // 비동기로 Schedule 생성
  Future<void> createSchedule(ScheduleDto schedule) async {
    try {
      await _collectionRef.add(schedule.toJson());
      print('Schedule created successfully');
    } catch (e) {
      print('Error creating schedule: $e');
      rethrow;
    }
  }

  // ID로 Schedule 조회
  Future<ScheduleDto?> getScheduleById(String id) async {
    try {
      DocumentSnapshot doc = await _collectionRef.doc(id).get();
      if (doc.exists) {
        return ScheduleDto.fromJson(doc.data() as Map<String, dynamic>, id);
      } else {
        print('No schedule found with ID: $id');
        return null;
      }
    } catch (e) {
      print('Error retrieving schedule: $e');
      rethrow;
    }
  }

  // Schedule 업데이트
  Future<void> updateSchedule(String id, ScheduleDto updatedSchedule) async {
    try {
      await _collectionRef.doc(id).update(updatedSchedule.toJson());
      print('Schedule updated successfully');
    } catch (e) {
      print('Error updating schedule: $e');
      rethrow;
    }
  }

  // Schedule 삭제
  Future<void> deleteSchedule(String id) async {
    try {
      await _collectionRef.doc(id).delete();
      print('Schedule deleted successfully');
    } catch (e) {
      print('Error deleting schedule: $e');
      rethrow;
    }
  }

  // 모든 Schedule 조회
  Future<List<ScheduleDto>> getAllSchedules() async {
    try {
      QuerySnapshot querySnapshot = await _collectionRef.get();
      return querySnapshot.docs
          .map((doc) =>
              ScheduleDto.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error retrieving all schedules: $e');
      rethrow;
    }
  }

  Future<void> addSchedule(ScheduleDto schedule, ScheduleModel scheduleModel) async {
    try {
        DocumentReference docRef = await _collectionRef.add(schedule.toJson());

        // 문서 ID를 scheduleId로 업데이트
        await docRef.update({"scheduleId": docRef.id});
        schedule.scheduleId = docRef.id;
        scheduleModel.addSchedule(ScheduleDto.toSchedule(schedule));

      print('All schedules added successfully');
    } catch (e) {
      print('Error adding multiple schedules: $e');
      rethrow;
    }
  }

  // 병렬 처리 예시: 여러 Schedule 삭제
  Future<void> deleteMultipleSchedules(List<String> ids) async {
    try {
      await Future.wait(
          ids.map((id) => _collectionRef.doc(id).delete())); // 병렬로 모든 스케줄 삭제
      print('All schedules deleted successfully');
    } catch (e) {
      print('Error deleting multiple schedules: $e');
      rethrow;
    }
  }
}
