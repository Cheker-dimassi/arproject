/// Miroir de ReconstructionDto cote backend.
class ReconstructionJob {
  final String jobId;
  final String articleId;
  final String status; // PENDING | PROCESSING | DONE | FAILED
  final String message;
  final String? glbAssetUrl;

  const ReconstructionJob({
    required this.jobId,
    required this.articleId,
    required this.status,
    required this.message,
    this.glbAssetUrl,
  });

  factory ReconstructionJob.fromJson(Map<String, dynamic> json) {
    return ReconstructionJob(
      jobId: json['jobId'] as String,
      articleId: json['articleId'] as String,
      status: json['status'] as String,
      message: json['message'] as String? ?? '',
      glbAssetUrl: json['glbAssetUrl'] as String?,
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isProcessing => status == 'PROCESSING';
  bool get isDone => status == 'DONE';
  bool get isFailed => status == 'FAILED';
  bool get isInProgress => isPending || isProcessing;
}