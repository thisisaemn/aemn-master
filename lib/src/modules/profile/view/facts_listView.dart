import 'package:flutter/material.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:user_repository/user_repository.dart';

//SRC: https://www.raywenderlich.com/books/flutter-apprentice/v2.0/chapters/5-scrollable-widgets#toc-chapter-011-anchor-003

class FactsListView extends StatelessWidget {
  // 2
  final List<KeyValue> facts;

  const FactsListView({
    Key? key,
    required this.facts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 3
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      // 4
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 5
          //Divider(height: 2,),
          const SizedBox(height: 16),
          Text(
              'facts',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, shadows: [Shadow(blurRadius: 1.5)],/*shadows: [Shadow(blurRadius: 4.0)],*//*backgroundColor: Colors.black54,*/ letterSpacing: 6.0, wordSpacing: 5), ),
          // 6
          const SizedBox(height: 32),

          // 7
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            alignment: Alignment.center,
            height: 50,
            // 1
            color: Colors.transparent,
// 2
            child: ListView.separated(
              // 3
              scrollDirection: Axis.horizontal,
              // 4
              itemCount: facts.length,
              // 5
              itemBuilder: (context, index) {
                // 6
                final fact = facts[index];
                return factTag(context, fact);
              },
              // 7
              separatorBuilder: (context, index) {
                // 8
                return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(width: 20),
                  VerticalDivider(thickness: 1.0, ),
                  SizedBox(width: 20),
                ]);
              },
            ),
            //color: Colors.grey,
          ),
        ],
      ),
    );
  }

  /*Widget buildCard(KeyValue fact) {
    return factTag(fact);
  }*/

  Widget factTag(BuildContext context, KeyValue fact) {
    /*return Center(
      // 1
      child: /*Container(
        constraints: const BoxConstraints.expand(
          width: 130,
          height: 130,
        ),
        decoration: BoxDecoration(
          //color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          border: Border.all(color: Colors.black12),
        ),
        // 2
        child:*/ /*Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fact.key,
              style: TextStyle(color: Colors.black26),
            ),
            Text(fact.value, style: Theme.of(context).textTheme.subtitle1),
          ],
        ), */
        /*Expanded(
          // 2
          child:*/ Stack(
            children: [
              // 3
              Positioned(
                bottom: 16,
                right: 10,
                child: Text(fact.value, style: Theme.of(context).textTheme.subtitle1),
              ),
              // 4
              Positioned(
                bottom: 40,
                left: 6,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(fact.key,
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
              ),
            ],
          ),
       // ),
     /* ),*/
    );*/
    return Column(
      children: [
        Text(fact.value, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, shadows: [Shadow(blurRadius: 2.0)],/*backgroundColor: Colors.black54,*/ letterSpacing: 6.0, wordSpacing: 5), ),
        SizedBox(height: 5),
        Text(fact.key, style: TextStyle(color: Colors.black45, wordSpacing: 4 ),),
      ],
    );
  }


}