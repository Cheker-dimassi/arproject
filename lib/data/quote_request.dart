/// Statut d'avancement d'un devis
enum QuoteStatus {
  sent,
  inProgress,
  processed;

  static QuoteStatus fromString(String? val) {
    switch (val?.toUpperCase()) {
      case 'IN_PROGRESS':
        return QuoteStatus.inProgress;
      case 'PROCESSED':
        return QuoteStatus.processed;
      default:
        return QuoteStatus.sent;
    }
  }

  String get backendString {
    switch (this) {
      case QuoteStatus.inProgress:
        return 'IN_PROGRESS';
      case QuoteStatus.processed:
        return 'PROCESSED';
      case QuoteStatus.sent:
        return 'SENT';
    }
  }
}

/// Payload d'envoi vers `POST /api/quotes`
class QuoteRequestPayload {
  final List<String> articleIds;
  final String name;
  final String email;
  final String phone;
  final String message;

  const QuoteRequestPayload({
    required this.articleIds,
    required this.name,
    required this.email,
    required this.phone,
    this.message = '',
  });

  Map<String, dynamic> toJson() => {
        'articleIds': articleIds,
        'name': name,
        'email': email,
        'phone': phone,
        'message': message,
      };
}

/// Representation locale et distante d'une demande de devis enregistree
class SubmittedQuote {
  final int id;
  final List<String> articleIds;
  final String name;
  final String email;
  final String phone;
  final String message;
  final QuoteStatus status;
  final DateTime createdAt;
  final double totalPrice;

  const SubmittedQuote({
    required this.id,
    required this.articleIds,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.status,
    required this.createdAt,
    this.totalPrice = 0.0,
  });

  factory SubmittedQuote.fromJson(Map<String, dynamic> json) {
    return SubmittedQuote(
      id: (json['id'] as num?)?.toInt() ?? 0,
      articleIds: (json['articleIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      message: json['message'] as String? ?? '',
      status: QuoteStatus.fromString(json['status'] as String?),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'articleIds': articleIds,
        'name': name,
        'email': email,
        'phone': phone,
        'message': message,
        'status': status.backendString,
        'createdAt': createdAt.toIso8601String(),
        'totalPrice': totalPrice,
      };
}
