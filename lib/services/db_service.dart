import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reviews_dashboard/models/review.dart';

abstract class IDbService {
  Stream<List<Review>> reviewsStream();
  Future<void> addReview(Review review);
}

class FirestoreDbService implements IDbService {
  const FirestoreDbService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Review>> reviewsStream() => _firestore.collection('reviews').snapshots().map(
        (event) => event.docs
            .map(
              (e) => Review.fromJson(e.data()),
            )
            .toList(),
      );

  @override
  Future<void> addReview(Review review) => _firestore.collection('reviews').add(review.toJson());
}
