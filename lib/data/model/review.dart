part of 'models.dart';

class Review {
  late String id;
  late num rating;
  late String description;
  late DateTime timestamp;
  late String lawyerId;
  late String clientId;
  late String clientName;

  Review({
    required this.id,
    required this.rating,
    required this.description,
    required this.timestamp,
    required this.lawyerId,
    required this.clientId,
    required this.clientName,
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    description = json['description'];
    timestamp = DateTime.parse(json['created_at']);
    lawyerId = json['lawyer_id'];
    clientId = json['client_id'];
    clientName = json['client_name'];
  }
}

