class Exercise {
  final int? id;
  final String name;
  final String description;

  Exercise({
    this.id,
    required this.name,
    required this.description,
  });

  Exercise.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        description = res["description"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
