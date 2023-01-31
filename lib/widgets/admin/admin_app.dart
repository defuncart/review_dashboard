import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
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
                  width: 80,
                  height: 80,
                  point: LatLng(
                    review.location.latitude,
                    review.location.longitude,
                  ),
                  builder: (context) => const _Marker(),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _Marker extends StatefulWidget {
  const _Marker();

  @override
  State<_Marker> createState() => _MarkerState();
}

class _MarkerState extends State<_Marker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        late OverlayEntry entry;

        entry = OverlayEntry(
          builder: (context) => Positioned(
            left: details.globalPosition.dx,
            top: details.globalPosition.dy - 16 - 64,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () => entry.remove(),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text('hello'),
                  ),
                ),
              ),
            ),
          ),
        );
        Overlay.of(context).insert(entry);
      },
      child: Icon(
        Icons.location_on,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
