import 'dart:async';

import 'package:flutter_assiment/models/giveaway_detail.dart';
import 'package:flutter_assiment/models/giveaway_model.dart';
import 'package:flutter_assiment/services/giveaway_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _mealServiceProvider = Provider<GiveawayService>((ref) {
  return GiveawayService();
});

class GieawayProvider extends AsyncNotifier<List<GiveawayModel>> {
  @override
  FutureOr<List<GiveawayModel>> build() {
    final service = ref.watch(_mealServiceProvider);
    return service.fetchMeals();
  }

  Future<void> refreshMeals() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(_mealServiceProvider);
      return service.fetchMeals();
    });
  }
}

final mealNotifierProvider = AsyncNotifierProvider(GieawayProvider.new);

final mealDetailProvider = FutureProvider.autoDispose.family<GiweawayDetail, int>((
      // final mealDetailProvider = FutureProvider.family<MealElement, String>((
      ref,
      id,
    ) {
      final service = ref.watch(_mealServiceProvider);
      return service.get(id);
    });
