import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overture/models/check_model_files/airportinfo_model.dart';

class FirestoreAirportinfoService {

  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('Airport_Info');

  Future<List<AirportInfoModel>> getAllAirportInfo() async{
    QuerySnapshot querySnapShot = await _collectionRef.get();

    return querySnapShot.docs.map((doc) =>
      AirportInfoModel.fromJson(doc.data() as Map<String, dynamic>)
    ).toList();

  }

  Future<void> updateAirportInfo(AirportInfoModel updatedAirportInfo) async {
    await _collectionRef.doc("Rw3kYnxkE7I4PgwXjshN").update(updatedAirportInfo.toJson());
  }

}