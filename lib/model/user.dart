class User {
  final String docId;
  final String uid;
  final String name;
  final String email;
  final int phone;
  final DateTime createdTime;
  final DateTime lastLoggedTime;

  User({
    required this.docId,
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdTime,
    required this.lastLoggedTime,
  });
}
