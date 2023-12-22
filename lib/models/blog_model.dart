import 'dart:typed_data';

class Blog {
  final int id; // Ajout de l'identifiant
  final String titre;
  final String description;
  final String lieu;
  final Uint8List image;
  final String date;
  final double prix;

  Blog({
    required this.id,
    required this.titre,
    required this.description,
    required this.lieu,
    required this.image,
    required this.date,
    required this.prix,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] != null ? json['id'] as int : 0, // Si id est null, utilisez 0 comme valeur par défaut
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      lieu: json['lieu'] ?? '',
      image: json['image'] ?? Uint8List(0), // Assurez-vous d'avoir une valeur par défaut appropriée
      date: json['date'] ?? '',
      prix: (json['prix'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Ajout de l'identifiant lors de la conversion vers JSON
      'titre': titre,
      'description': description,
      'lieu': lieu,
      'image': image,
      'date': date,
      'prix': prix,
    };
  }
}
