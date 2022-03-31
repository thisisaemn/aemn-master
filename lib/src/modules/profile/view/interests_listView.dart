import 'package:flutter/material.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:user_repository/user_repository.dart';

class InterestsListView extends StatelessWidget {
  // 1
  final List<Interest> interests;

  const InterestsListView({
    Key? key,
    required this.interests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0,
      ),
      // 3
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4
          //Divider(height: 2,),
          const SizedBox(height: 16),
          Text('interests',
          textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,/*Colors.black26,*/ shadows: [Shadow(blurRadius: 1.5)],/*shadows: [Shadow(blurRadius: 4.0)],*//*backgroundColor: Colors.black54,*/ letterSpacing: 6.0, wordSpacing: 5), ),
          // 5
          const SizedBox(height: 16),
          //Divider(height: 2,),
          const SizedBox(height: 16),
          interestList(),
          // 6
          const SizedBox(height: 16),
        ],
      ),
    );
  }


  Widget interestList (){
    return ListView.builder(
      itemCount: interests.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        //print(interests[index].interestModel);
        return Container(
          child: interestItem(interest: interests[index],)
        );
      },
    );
  }

  Widget interestItem({required Interest interest}){
    return ListTile(
      leading:  Icon(Icons.arrow_right, //for now ti icons are ready
        //IconData(stringToInt_tryParse(interest.interestModel.icon, 57502), fontFamily: 'MaterialIcons'),
        size: 18,
      ),
      horizontalTitleGap: 0,
      title: Container(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          interest.interestModel.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: giveTags(interest.interestModel.tags),
      isThreeLine: true,
    );
  }

  int stringToInt_tryParse(String input, int def) {
    var i = int.tryParse(input);
    //print(input);
    //print(i);
    if (i == null) {
      return def;
    } else {
      return i;
    }
  }
  //https://medium.com/nextfunc/dart-flutter-how-to-parse-string-to-number-22c6e181e599

  //https://stackoverflow.com/questions/50441168/iterating-through-a-list-to-render-multiple-widgets-in-flutter , Paresh Mangukiya


  Widget listOfWidgets(List<Tag> item) {
    List<Widget> list = [];
    for (var i = 0; i < item.length; i++) {
      list.add(Container(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              item[i].name,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
              ),
            ),
          )));
    }
    return Wrap(
        spacing: 5.0, // gap between adjacent chips
        runSpacing: 2.0, // gap between lines
        children: list);
  }

  //Constraint needed
  Widget giveTags(List<Tag> tags) {
    if (tags != null && tags.length >= 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: ClipRect(
                  child: listOfWidgets(tags)
              )
          ),
        ],
      );
    } else
      return SizedBox(width: 0, height: 0);
  }
}