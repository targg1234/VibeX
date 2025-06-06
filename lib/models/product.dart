class Product {
  final String? id;
  final String? name;
  final String? description;
  final String? avatar;
  final String? createdAt;

  Product({
    this.id,
    this.name,
    this.description,
    this.avatar,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }
}
