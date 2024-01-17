import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseContact {
  String name;
  String number;

  DatabaseContact({required this.name, required this.number});

  DatabaseContact.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          number: json['number']! as String,
        );

  DatabaseContact copyWith({
    String? name,
    String? number,
  }) {
    return DatabaseContact(
        name: name ?? this.name, number: number ?? this.number);
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'number': number,
    };
  }
}
