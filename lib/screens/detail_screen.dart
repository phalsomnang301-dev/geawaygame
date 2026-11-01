import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_assiment/models/giveaway_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_assiment/providers/giveaway_provider.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // id comes from Navigator.pushNamed(..., arguments: item.id)
    final id = ModalRoute.of(context)?.settings.arguments as int;
    final detailAsync = ref.watch(gieavDetailProvider(id));

    return Scaffold(
      body: detailAsync.when(
        // keep the content on screen while pull-to-refresh reloads
        skipLoadingOnReload: true,
        data: (item) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(gieavDetailProvider(id));
            try {
              await ref.read(gieavDetailProvider(id).future);
            } catch (_) {}
          },
          child: _DetailContent(item: item),
        ),
        loading: () => const _PlainScaffold(
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, s) {
          debugPrint("Error : $e");
          debugPrint("StackTrace : $s");
          return _PlainScaffold(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 56,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Couldn't load this giveaway",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(gieavDetailProvider(id)),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Try again"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Simple AppBar + body used for the loading and error states.
class _PlainScaffold extends StatelessWidget {
  final Widget child;
  const _PlainScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giveaway")),
      body: child,
    );
  }
}

class _DetailContent extends StatelessWidget {
  final GiweawayDetail item;
  const _DetailContent({required this.item});

  bool get _hasPrice => item.worth.trim().isNotEmpty && item.worth != "N/A";
  bool get _hasEndDate => item.endDate.trim().isNotEmpty && item.endDate != "N/A";

  String _dateOnly(String value) => value.split(' ').first;

  String _withCommas(int n) => n.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => ',',
      );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final platforms = item.platforms
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 280,
          backgroundColor: scheme.surface,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: item.image,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      ColoredBox(color: scheme.surfaceContainerHighest),
                  errorWidget: (_, _, _) => ColoredBox(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: scheme.onSurfaceVariant,
                      size: 48,
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black45, Colors.transparent],
                      stops: [0, 0.4],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  item.title,
                  style: text.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                // Price: old price crossed out + FREE badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "FREE",
                        style: text.labelLarge?.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (_hasPrice) ...[
                      const SizedBox(width: 12),
                      Text(
                        item.worth,
                        style: text.titleMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Type, status and platforms
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _InfoChip(label: item.type, icon: Icons.sports_esports),
                    _InfoChip(label: item.status, icon: Icons.bolt),
                    for (final p in platforms)
                      _InfoChip(label: p, icon: Icons.devices),
                  ],
                ),
                const SizedBox(height: 24),

                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        icon: Icons.people_alt_outlined,
                        value: _withCommas(item.users),
                        label: "Claimed",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Stat(
                        icon: Icons.event_available_outlined,
                        value: _dateOnly(item.publishedDate),
                        label: "Published",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Stat(
                        icon: Icons.timer_outlined,
                        value: _hasEndDate ? _dateOnly(item.endDate) : "Open",
                        label: _hasEndDate ? "Ends" : "No end date",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // About
                const _SectionTitle("About this giveaway"),
                const SizedBox(height: 8),
                Text(item.description, style: text.bodyLarge?.copyWith(height: 1.5)),
                const SizedBox(height: 28),

                // How to claim
                const _SectionTitle("How to claim"),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item.instructions,
                    style: text.bodyMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Action
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: item.openGiveawayUrl),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Giveaway link copied")),
                        );
                      }
                    },
                    icon: const Icon(Icons.link),
                    label: const Text("Copy giveaway link"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 16, color: scheme.onSecondaryContainer),
      label: Text(label),
      labelStyle: TextStyle(color: scheme.onSecondaryContainer),
      backgroundColor: scheme.secondaryContainer,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _Stat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}