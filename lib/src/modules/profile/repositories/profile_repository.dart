import 'dart:math';

class ProfileRepository {
  int _data=100;

  Future<void> fetchData() async {
    // simulate real data fetching
    await Future.delayed(Duration(milliseconds: 600));
    // store dummy data
    _data = Random().nextInt(1000);
  }

  int get data => _data;
}