import 'dart:async';

import 'package:flutter_assiment/models/giveaway_detail.dart';
import 'package:flutter_assiment/models/giveaway_model.dart';
import 'package:flutter_assiment/services/giveaway_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _giveawayServiceProvider = Provider<GiveawayService>((ref) {
  return GiveawayService();
});

class GiveawayProvider extends AsyncNotifier<List<GiveawayModel>> {
  @override
  FutureOr<List<GiveawayModel>> build() {
    final service = ref.watch(_giveawayServiceProvider);
    return service.fetchGieaWay();
  }

  Future<void> refreshGiveaways() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(_giveawayServiceProvider);
      return service.fetchGieaWay();
    });
  }
}

final giveawayNotifierProvider = AsyncNotifierProvider(GiveawayProvider.new);

final gieavDetailProvider = FutureProvider.autoDispose
    .family<GiweawayDetail, int>((
      // final mealDetailProvider = FutureProvider.family<MealElement, String>((
      ref,
      id,
    ) {
      final service = ref.watch(_giveawayServiceProvider);
      return service.get(id);
    });
