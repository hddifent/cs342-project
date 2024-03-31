import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  final String collectionPath;
  final CollectionReference collection;

  FirestoreDatabase(this.collectionPath) : 
    collection = FirebaseFirestore.instance.collection(collectionPath);

  Future<void> addDocument(String? docID, Map<String, dynamic> data) { 
    return collection.doc(docID).set(data);
  }

  Stream<QuerySnapshot> getStream(String orderCondition) {
    final collectionStream = collection.orderBy(
      orderCondition, descending: false).snapshots();

    return collectionStream;
  }

  DocumentReference getDocumentReference(String docID) { return collection.doc(docID); }

  Future<void> updateDocument(String docID, Map<String, dynamic> data) {
    return collection.doc(docID).update(data); 
  }

}
