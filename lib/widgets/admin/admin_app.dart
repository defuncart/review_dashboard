import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:reviews_dashboard/models/review.dart';
import 'package:reviews_dashboard/state/state.dart';
import 'package:reviews_dashboard/widgets/common/auth_wrapper.dart';

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsStream = ref.watch(reviewsStreamProvider);

    return AuthWrapper(
      onBuildDashboard: (context) => Scaffold(
        body: reviewsStream.map(
          loading: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error) => Center(
            child: Text(error.toString()),
          ),
          data: (data) => data.hasValue
              ? data.value.isEmpty
                  ? const Center(
                      child: Text('No data available'),
                    )
                  : AdminDashboard(reviews: data.value)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({
    required this.reviews,
    super.key,
  });

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.5, -0.09),
        zoom: 5,
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: () {},
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(
          markers: reviews
              .map(
                (review) => Marker(
                  width: 90 + 24,
                  height: 60 + 24,
                  point: LatLng(
                    review.location.latitude,
                    review.location.longitude,
                  ),
                  builder: (context) => _Marker(review: review),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _Marker extends StatefulWidget {
  const _Marker({
    required this.review,
  });

  final Review review;

  @override
  State<_Marker> createState() => _MarkerState();
}

class _MarkerState extends State<_Marker> {
  var _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Stack(
          children: [
            if (_isHovering)
              Positioned(
                left: 24,
                child: _Overlay(
                  review: widget.review,
                ),
              ),
            Icon(
              Icons.location_on,
              size: 24,
              color: _isHovering ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColor,
            ),
          ],
        ));
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({
    required this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              review.rating,
              (_) => Icon(
                Icons.star,
                color: Theme.of(context).primaryColor,
                size: 16,
              ),
            ),
          ),
          Text(
            DateFormat.MMMEd().format(review.createdAt),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
