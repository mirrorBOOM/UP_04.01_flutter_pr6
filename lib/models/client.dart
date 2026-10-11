class MembershipCard {
  final String cardNumber;
  final String validUntil;
  final String status;

  const MembershipCard({
    required this.cardNumber,
    required this.validUntil,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'cardNumber': cardNumber,
    'validUntil': validUntil,
    'status': status,
  };

  factory MembershipCard.fromJson(Map<String, dynamic> json) => MembershipCard(
    cardNumber: json['cardNumber'] as String? ?? '',
    validUntil: json['validUntil'] as String? ?? '',
    status: json['status'] as String? ?? 'ACTIVE',
  );
}

class Client {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final MembershipCard card;

  const Client({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.card,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'card': card.toJson(),
  };

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json['id'] as int? ?? 0,
    fullName: json['fullName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    card: MembershipCard.fromJson(json['card'] as Map<String, dynamic>? ?? {}),
  );
}
