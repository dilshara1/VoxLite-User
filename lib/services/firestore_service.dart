/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxliteapp/models/movie.dart';
import 'package:voxliteapp/models/order.dart';
import 'package:voxliteapp/models/seat.dart';
import 'package:voxliteapp/models/order.dart';

class FirestoreService {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<Movie>> getMovies() async {
    QuerySnapshot snapshot = await _db.collection('movies').get();

    List<Movie> movies =
        snapshot.docs.map((doc) => Movie.fromMap(doc.data())).toList();

    return movies;
  }

  static Future<List<Seat>> getSeats(String movieId) async {
    DocumentSnapshot snapshot =
        await _db.collection('seats').doc(movieId).get();

    List<dynamic> seatMaps = snapshot.data()!['seats'];
    List<Seat> seats =
        seatMaps.map((seatMap) => Seat.fromMap(seatMap)).toList();

    return seats;
  }

  static Future<void> updateSeats(String movieId, List<Seat> seats) async {
    List<Map<String, dynamic>> seatMaps =
        seats.map((seat) => seat.toMap()).toList();

    await _db.collection('seats').doc(movieId).update({
      'seats': seatMaps,
    });
  }

  static Future<void> createOrder(Order order) async {
    await _db.collection('orders').add(order.toMap());
  }

  static Stream<List<Order>> getOrderStream(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromMap(doc.data())).toList());
  }
}
 */