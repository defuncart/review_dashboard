import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reviews_dashboard/models/review.dart';
import 'package:reviews_dashboard/state/state.dart';
import 'package:reviews_dashboard/widgets/common/auth_wrapper.dart';

final userRatingProvider = StateProvider<int?>(
  (_) => null,
);

final userCanSubmitProvider = Provider(
  (ref) => ref.watch(userRatingProvider) != null,
);

class ClientApp extends ConsumerWidget {
  const ClientApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canSubmit = ref.watch(userCanSubmitProvider);

    return AuthWrapper(
      onBuildDashboard: (context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Theme.of(context).primaryColor,
                ),
                onRatingUpdate: (rating) => ref.read(userRatingProvider.notifier).state = rating.toInt(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: canSubmit
                    ? () {
                        ref.read(dbProvider).addReview(
                              Review(
                                createdAt: DateTime.now(),
                                rating: ref.read(userRatingProvider)!,
                                location: ref.read(locationProvider).location,
                              ),
                            );
                        ref.read(userRatingProvider.notifier).state = null;
                      }
                    : null,
                child: const Text('Add review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
