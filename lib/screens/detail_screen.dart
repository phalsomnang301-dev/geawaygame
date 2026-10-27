import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assiment/models/giveaway_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_assiment/providers/giveaway_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;
    final detailAsycn = ref.watch(mealDetailProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Screen $id",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(mealDetailProvider);
        },
        child: Center(
          child: detailAsycn.when(
            data: (item) {
              return _buildListView(item);
            },
            error: (e, s) {
              debugPrint("Error : ${e.toString()}");
              debugPrint("TrackTrace : ${s.toString()}");
              return Text("Error : ${e.toString()}");
            },
            loading: () {
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildListView(GiweawayDetail item) {
  //   return ListView(
  //     // physics: const ScrollPhysics(),
  //     padding: const EdgeInsets.all(8),
  //     children: [
  //       Card(
  //         child: Padding(
  //           padding: const EdgeInsets.all(8),
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(8),
  //             child: CachedNetworkImage(
  //               imageUrl: item.thumbnail,
  //               fit: BoxFit.cover,
  //               placeholder: (context, url) =>
  //                   const Center(child: CircularProgressIndicator()),
  //               errorWidget: (context, url, error) =>
  //                   const Icon(Icons.broken_image, size: 60),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Card(
  //         child: ListTile(
  //           leading: const Icon(Icons.title),
  //           title: Text(item.title),
  //         ),
  //       ),
  //       Card(
  //         child: ListTile(
  //           leading: const Icon(Icons.description),
  //           title: Text(item.description),
  //         ),
  //       ),
  //       Card(
  //         child: ListTile(
  //           leading: const Icon(Icons.category),
  //           title: Text('Type: ${item.type}'),
  //           subtitle: Text('Platform: ${item.platforms}'),
  //         ),
  //       ),
  //       Card(
  //         child: ListTile(
  //           leading: const Icon(Icons.attach_money),
  //           title: Text('Worth: ${item.worth}'),
  //         ),
  //       ),
  //       Card(
  //         child: ListTile(
  //           leading: const Icon(Icons.info_outline),
  //           title: Text(item.instructions),
  //         ),
  //       ),
   
  //       Card(
  //           child: ListTile(
  //             leading: const Icon(Icons.people),
  //             title: Text('Users: ${item.users}'),
  //             subtitle: Text('Status: ${item.status}'),
  //           ),
  //         ),
   
  //     ],
  //   );
  // }



  Widget _buildListView(GiweawayDetail item) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Card(
          child: Padding(
            padding: const .all(8.0),
            child: ClipRRect(
              borderRadius: .circular(8),
              child: CachedNetworkImage(
                imageUrl:item.thumbnail,
                fit:BoxFit.cover,
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.title),
            title: Text(item.title),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.light),
            title: Text(item.description),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.category),
            title: Text(item.worth),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.language),
            title: Text(item.instructions),
          ),
        ),

      ],
    );
  }
}
