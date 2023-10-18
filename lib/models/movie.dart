import 'package:cloud_firestore/cloud_firestore.dart';

class VacationBean {
  String key;
  String coverUrl;
  String title;
  String description;
  DateTime showtime;
  DateTime startDate;
  DateTime endDate;
  double price;
  double rate;

  VacationBean({
    required this.key,
    required this.coverUrl,
    required this.title,
    required this.description,
    required this.showtime,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.rate,
  });
  
  static Future<List<VacationBean>> fetchFromFirestore() async {
    List<VacationBean> vacationBeans = [];

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('movies').get();

    snapshot.docs.forEach((doc) {
      String key = doc.id;
      String coverUrl = doc['coverUrl'];
      String title = doc['title'];
      String description = doc['description'];
      DateTime showtime = doc['startDateTime'].toDate();
      DateTime startDate = doc['startDateTime'].toDate();
      DateTime endDate = doc['endDateTime'].toDate();
      double price = doc['price'].toDouble();
      double rate = doc['rate'].toDouble();

      VacationBean vacationBean = VacationBean(
        key: key,
        coverUrl: coverUrl,
        title: title,
        description: description,
        showtime: showtime,
        startDate: startDate,
        endDate: endDate,
        price: price,
        rate: rate,
      );
      vacationBeans.add(vacationBean);
    });

    return vacationBeans;
  }
}
