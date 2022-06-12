
import 'package:flutter/material.dart';

import 'package:aemn/src/modules/swipe/swipe.dart';
import 'package:flutter/physics.dart';
import 'package:interest_repository/interest_repository.dart';
import 'package:swipe_repository/swipe_repository.dart';

import 'package:aemn/src/modules/search/search.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aemn/src/core/navigation/navigation/navigation.dart';



//I feel as if this structure is wrong, will it update accordingly, is it not wasteful?
class SwipeMainScreen extends StatelessWidget { //Is this Wraparound class really neccessary?
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SwipeMainScreen());
  }

  SwipeMainScreen({Key? key}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => BlocProvider.of<SwipeNavigationBloc>(context).add(
                NavigationRequested(to: ProfileNavigationDestinations.show),
              ),
              tooltip: 'Settings',
            );
          },
        ),
      ),*/
      body: Builder( //Should this buildedr be in a staeful widget so that it can update accordingly?
        builder: (context) {
          final swipes = context.select(
                (SwipeBloc bloc) => bloc.swipes,
          );

          return SwipeMainViewScreen(swipes: swipes);
        },
      ),
    );
  }
}



class SwipeMainViewScreen extends StatefulWidget {
  final List<SwipeSuggestion> swipes;

  SwipeMainViewScreen({Key? key, required this.swipes}) : super();

  @override
  State<StatefulWidget> createState() => _SwipeMainViewScreenState();
}


class _SwipeMainViewScreenState extends State<SwipeMainViewScreen> {
  late List<SwipeSuggestion> _swipes; //Should these be final?

  @override
  void initState() {
    super.initState();
    if (widget.swipes == null) {
      _swipes = [];
    } else {
      _swipes = widget.swipes;
    }
  }


  Widget swipesReactionIcon(index){
    if(_swipes[index].reaction==1 ){
      return Icon(Icons.favorite, size: 18,);
    }else if(_swipes[index].reaction==-1){
      return Icon(Icons.sentiment_neutral, size:18);
    }else{
      return Icon(Icons.favorite_border_outlined, size:18);
    }
  }

  @override
  Widget build(BuildContext context) {
    _swipes= context.select(
          (SwipeBloc bloc) => bloc.swipes,
    );

    Widget SwipeListItem(int index){
      return /*GestureDetector(
          /*onTap: () {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return Scaffold(appBar: AppBar(), body: SwipeOptionDetailScreen(),);
              },
            ));
          },*/
        //later spring back drag animation
          onHorizontalDragStart: (details){},
          onHorizontalDragUpdate: (details){},
          onHorizontalDragEnd: (details) {},
          onHorizontalDragCancel: (){},
          onDoubleTapDown: (details) {
            print('double tapped');
            if (details.localPosition.direction >
                1.0) {
              print('Left');
              if(_swipes[index].reaction > -1) {
                BlocProvider.of<SwipeBloc>(context).add(
                  ReduceFavor(tags: _swipes[index].tags),
                );
                setState(() {
                  _swipes[index].reaction--;
                });
              }
            }else
            /*if (details.localPosition.direction <
                0.0) */{
              print('Right');
              if(_swipes[index].reaction < 1) {
                BlocProvider.of<SwipeBloc>(context).add(
                  AddFavor(tags: _swipes[index].tags),
                );
                setState(() {
                  _swipes[index].reaction++;
                });
              }
            };
          },
          onDoubleTap: () {
            print('do double tap thing');
          },
          child: */Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: /*Image.asset(_swipes[index].src,
                          fit: BoxFit.cover)*/
                      Image.network(
                        _swipes[index].src,
                        fit: BoxFit.cover,
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //IconButton(icon: (_swipes[index].reaction==-1) ? Icon(Icons.sentiment_neutral/*IconData(0xf0328, fontFamily: 'MaterialIcons')*/) : Icon(Icons.exposure_zero_outlined /*IconData(0xf0609, fontFamily: 'MaterialIcons')*/, color: Colors.white,), onPressed: () {  },),
                      //IconButton(icon: (_swipes[index].reaction==1) ? Icon(Icons.favorite) :  Icon(Icons.favorite_border_outlined), onPressed: () {  }),
                      swipesReactionIcon(index)
                    ],
                  )
                ]
            ),
          //)
      );
    }



    Widget SwipeList(){
      return RefreshIndicator(
          onRefresh: () {
        //Set List to zero during loading, make loading connect
        BlocProvider.of<SwipeBloc>(context).add(
            LoadSwipes(bias: []));
        return Future.delayed(Duration(milliseconds: 1000));
      }, child:
        ListView.builder(
        itemCount: _swipes.length,
        itemBuilder: (BuildContext context, int index) {
          //return SwipeListItem(index);
          return DraggableCard(child: SwipeListItem(index));
          /*Dismissible(
            key: Key('$index'),
            child: SwipeListItem(index),*/

            /*onDismissed: (direction) {
              // Remove the item from the data source.
              /*setState(() {
                              interests[index]['intensity']removeAt(index);
                            });*/
            },
          );*/
        },
      )
     );
    }

    Widget SwipeViewContent(){
      if(_swipes.length == 0){
        return RefreshIndicator(
            onRefresh: () {
          //Set List to zero during loading, make loading connect
          BlocProvider.of<SwipeBloc>(context).add(
              LoadSwipes(bias: []));
          return Future.delayed(Duration(milliseconds: 1000));
        }, child: Center(
            child: Image.asset('lib/src/assets/images/swipe-in-progress.png',
            height: 220,)
        )
          /*child: ListView(
          children: [Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Text("no swipes loaded", textAlign: TextAlign.center, style: TextStyle(color: Colors.black45),))],
        )*/
        );
      }else{
        return SwipeList();
      }
    }


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
          /*leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'swipe left = not interested,\n\nswipe right = very interested,\n\ndouble click = yeah i like,\n\nnothing: idc')));
                },
                tooltip: 'Help for the Swipe Screen',
              );
            },
          ),*/
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, size: 18,),
              tooltip: 'Search Interests',
              onPressed: /*() {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return SwipeSearchScreen();
                  },
                ));
              },*/
                  () => BlocProvider.of<NavigationBloc>(context).add(
                NavigationRequested(destination: NavigationDestinations.searchInterests),
              ),

              //onPressed: () {
              //showSearch(context: context, delegate: DataSearch(listWords));
              //https://stackoverflow.com/questions/58908968/how-to-implement-a-flutter-search-app-bar
              //}
            )
          ]),
      body: SwipeViewContent(),//Center( child:

      // ),
    );


  }

}

//https://docs.flutter.dev/cookbook/animation/physics-simulation

/// A draggable card that moves back to [Alignment.center] when it's
/// released.
class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  _DraggableCardState createState() => _DraggableCardState();

}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  Alignment _dragAlignment = Alignment.center;

  late Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          elevation: 0,
          child: widget.child,
        ),
      ),
    );
  }
}


