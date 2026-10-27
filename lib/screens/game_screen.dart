
import 'package:flutter_assiment/models/giveaway_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_assiment/providers/giveaway_provider.dart';

import 'package:cached_network_image/cached_network_image.dart';




class MealScreen extends ConsumerStatefulWidget {
  const MealScreen({super.key});

  @override
  ConsumerState<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends ConsumerState<MealScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:buildAppbar() ,
      body: buildBody(),
      floatingActionButton: _showButton ? _buildFloating() : null,
    );
  }




  bool _showButton = false;

@override
void initState() {
  super.initState();
  _scroller.addListener(() {
    if (_scroller.position.pixels < 500) {
      setState(() {
        _showButton = false;
      });
    } else {
      setState(() {
        _showButton = true;
      });
    }
  });
}

  AppBar buildAppbar() {
    return AppBar(
        centerTitle: true,
        title: Text("Meal Menu"),
        backgroundColor: Colors.pink,
         bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Well, it is cool, right?",
              style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold),
            ),
          ),
        ),

    );
  }
  Widget buildBody() {
    final mealAsync = ref.watch(mealNotifierProvider);
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.watch(mealNotifierProvider.notifier).refreshMeals();
        },
        child: mealAsync.when(
          data: (items) {
            return _buildGridView(items);
          },
          error: (e, s) {
            debugPrint("Error : ${e.toString()}");
            debugPrint("TrackTrace : ${s.toString()}");
            return Text("Error : ${e.toString()}");
          },
          loading: () {
            return _buildSkeleton();
          },
        ),
      ),
    );
  }


  Widget _buildFloating() {
  return FloatingActionButton(
    shape: const CircleBorder(),
    onPressed: () {
      _scroller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    },
    child: const Icon(Icons.arrow_upward),
  );
}


Widget _buildSkeleton() {
  return Skeletonizer(
    child: GridView.builder(
      itemCount: 40,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "asdsadasd sadassa",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

final ScrollController _scroller = ScrollController();


  Widget _buildGridView(List<GiveawayModel> items) {
    if (items.isEmpty) {
      return Text("No items");
    }
    return GridView.builder(
      controller: _scroller,
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItem(item);
      },
    );
  }

  Widget _buildItem(GiveawayModel item) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed("/detail",arguments: item.id);
      },
   
    child:Card(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: .circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.title, maxLines: 1, overflow: .ellipsis),
          ),
        ],
      ),
    ),
    );
  }
}
