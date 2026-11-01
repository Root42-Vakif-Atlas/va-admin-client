Map<String, dynamic> memoryJson({
  String id = 'mem_1',
  String status = 'pending',
  List<String> decisions = const ['approve', 'reject'],
  Map<String, dynamic>? ai = const {
    'verdict': 'review',
    'score': 0.62,
    'scores': {
      'toxicity': 0.62,
      'severe_toxicity': 0.0,
      'obscene': 0.1,
      'identity_attack': 0.0,
      'insult': 0.55,
      'threat': 0.01,
      'sexual_explicit': 0.0,
    },
    'topCategory': 'insult',
    'reviewCause': 'score',
    'lexiconMatched': false,
    'modelVersion': '0.4-int8',
    'scoredAt': '2026-10-23T09:00:01Z',
  },
  String? decidedBy,
}) => {
  'id': id,
  'monument': {
    'id': 'selimiye-camii',
    'name': 'Selimiye Camii',
    'city': 'Edirne',
  },
  'author': {'id': 'usr_1', 'displayName': 'Ayşe Y.'},
  'text': 'Rehber berbattı, hiçbir şey anlatmadı.',
  'visitedOn': null,
  'photos': <Object>[],
  'createdAt': '2026-10-23T09:00:00Z',
  'memoryDate': '2026-10-23',
  'status': status,
  'publiclyVisible': status == 'approved',
  'openReports': 0,
  'reportReasons': <String, Object>{},
  'moderation': {
    'reason': status == 'rejected' ? 'offensive' : null,
    'note': null,
    'by': decidedBy == null
        ? null
        : {
            'id': decidedBy == 'ai' ? 'system:ai-moderation' : 'usr_staff_003',
            'displayName': decidedBy == 'ai' ? 'YZ moderasyonu' : 'Moderatör',
          },
    'at': decidedBy == null ? null : '2026-10-23T09:00:01Z',
    'decidedBy': decidedBy,
  },
  'ai': ai,
  'allowedDecisions': decisions,
  'reports': <Object>[],
};

Map<String, dynamic> metricsJson({String mode = 'ai', int days = 30}) => {
  'mode': mode,
  'modelVersion': '0.4-int8',
  'days': days,
  'thresholds': {
    'approveBelow': 0.31,
    'rejectFrom': 0.96,
    'reviewPhotos': false,
  },
  'totals': {
    'shared': 120,
    'scored': 118,
    'autoApproved': 96,
    'review': 14,
    'autoRejected': 8,
    'unscored': 2,
  },
  'humanReview': {
    'waiting': 5,
    'oldestWaitingMinutes': 95,
    'decided': 10,
    'approved': 7,
    'rejected': 3,
    'medianDecisionMinutes': 42,
  },
  'overrides': {'autoRejectRestored': 1, 'autoApproveRemoved': 0},
  'scoreHistogram': [
    for (var i = 0; i < 10; i++)
      {
        'from': i / 10,
        'to': (i + 1) / 10,
        'total': i == 0 ? 96 : (i == 9 ? 8 : 2),
        'approved': i == 0 ? 96 : 1,
        'pending': i == 9 ? 0 : 1,
        'rejected': i == 9 ? 7 : 0,
      },
  ],
  'categories': {'insult': 9, 'obscene': 5, 'unknown_future': 1},
  'latency': {'p50Ms': 41, 'p95Ms': 180},
  'daily': [
    {'date': '2026-10-22', 'autoApproved': 40, 'review': 6, 'autoRejected': 3},
    {'date': '2026-10-23', 'autoApproved': 56, 'review': 8, 'autoRejected': 5},
  ],
};
