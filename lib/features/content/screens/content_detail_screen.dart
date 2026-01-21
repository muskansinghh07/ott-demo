import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/content_model.dart';
import '../../../blocs/subscription/subscription_bloc.dart';
import '../../player/screens/player_screen.dart';
import '../../subscription/screens/subscription_screen.dart';

class ContentDetailScreen extends StatelessWidget {
  final ContentModel content;

  const ContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.grey[900]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${content.releaseYear}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(' ${content.rating}'),
                      if (content.isPremium) ...[
                        const SizedBox(width: 16),
                        const Chip(
                          label: Text('Premium', style: TextStyle(fontSize: 12)),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _playContent(context),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                  ),
                  const SizedBox(height: 16),
                  Text(content.description),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: content.genres
                        .map((g) => Chip(label: Text(g)))
                        .toList(),
                  ),
                  if (content.seasons != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Episodes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ...content.seasons!.expand((season) => season.episodes).map((ep) {
                      return ListTile(
                        leading: Container(
                          width: 100,
                          height: 60,
                          color: Colors.grey[800],
                        ),
                        title: Text('E${ep.episodeNumber}: ${ep.title}'),
                        subtitle: Text(ep.description),
                        onTap: () => _playEpisode(context, ep.id),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _playContent(BuildContext context) {
    final subscriptionState = context.read<SubscriptionBloc>().state;
    
    if (content.isPremium && subscriptionState is SubscriptionStatusState && !subscriptionState.isActive) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          contentId: content.id,
          title: content.title,
        ),
      ),
    );
  }

  void _playEpisode(BuildContext context, String episodeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          contentId: episodeId,
          title: content.title,
        ),
      ),
    );
  }
}