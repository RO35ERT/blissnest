class TherapistRatingResponse {
  final int therapistId;
  final double overallRating;
  final int totalRatings;

  TherapistRatingResponse({
    required this.therapistId,
    required this.overallRating,
    required this.totalRatings,
  });

  factory TherapistRatingResponse.fromJson(Map<String, dynamic> json) {
    return TherapistRatingResponse(
      therapistId: int.tryParse(json['therapistId'].toString()) ?? 0,
      overallRating: double.tryParse(json['overallRating'].toString()) ?? 0.0,
      totalRatings: int.tryParse(json['totalRatings'].toString()) ?? 0,
    );
  }
}
