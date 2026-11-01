import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas_admin/features/moderation/data/moderation_repository_impl.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';

/// Moderasyon servisinin spam, bağlam ve görsel sinyalleri (kök ADR 58).
void main() {
  test('spam, bağlam ve fotoğraf skorları ayrıştırılır', () {
    final ai = ModerationRepositoryImpl.parseAi({
      'verdict': 'review',
      'score': 0.6,
      'scores': {'toxicity': 0.01, 'insult': 0.0},
      'topCategory': 'spam',
      'reviewCause': 'spam',
      'lexiconMatched': false,
      'modelVersion': 'detoxify-0.4-int8',
      'scoredAt': '2026-11-01T10:00:00Z',
      'nsfw': 0.0002,
      'similarity': 0.08,
      'images': [
        {
          'photoId': 'pho_1',
          'readable': true,
          'nsfw': 0.0002,
          'similarity': 0.08,
          'references': 12,
        },
        {'photoId': 'pho_2', 'readable': false, 'references': 0},
      ],
      'visionVersion': 'vit-nsfw+dinov2',
      'spam': 0.6,
      'spamSignals': ['contact'],
      'relevance': 0.42,
      'contextVersion': 'ctx-1',
    })!;

    expect(ai.topCategory, AiCategory.spam);
    expect(ai.reviewCause, AiReviewCause.spam);
    expect(ai.scores.keys, {AiCategory.toxicity, AiCategory.insult});
    expect(ai.spam, 0.6);
    expect(ai.spamSignals, ['contact']);
    expect(ai.relevance, 0.42);
    expect(ai.images, hasLength(2));
    expect(ai.images.first.similarity, 0.08);
    expect(ai.images.last.readable, isFalse);
  });

  test('eski yanıtta yeni alanlar yoksa boş kalır', () {
    final ai = ModerationRepositoryImpl.parseAi({
      'verdict': 'unscored',
      'reviewCause': 'context',
      'lexiconMatched': false,
    })!;
    expect(ai.reviewCause, AiReviewCause.context);
    expect(ai.images, isEmpty);
    expect(ai.spamSignals, isEmpty);
    expect(ai.relevance, isNull);
  });
}
