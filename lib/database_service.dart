import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_crud_1/database.dart';

const String CONTACT_COLLECTION_REF = "contact";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _contactRef;

  DatabaseService() {
    _contactRef = _firestore
        .collection(CONTACT_COLLECTION_REF)
        .withConverter<DatabaseContact>(
            fromFirestore: (snapshots, _) => DatabaseContact.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (database, _) => database.toJson());
  }

  Stream<QuerySnapshot> getContact() {
    return _contactRef.snapshots();
  }

  void addContact(DatabaseContact database) async {
    _contactRef.add(database);
  }

  void updateContact(String databaseId, DatabaseContact database) {
    _contactRef.doc(databaseId).update(database.toJson());
  }

  void deleteContact(String databaseId) {
    _contactRef.doc(databaseId).delete();
  }
}
