class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final String description;
  final String coverImage;
  final int publishYear;
  int availableCopies;
  final int totalCopies;
  final double rating;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    required this.description,
    required this.coverImage,
    required this.publishYear,
    required this.availableCopies,
    required this.totalCopies,
    required this.rating,
  });

  bool get isAvailable => availableCopies > 0;

  // تحويل من JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      publishYear: json['publishYear'] ?? 0,
      availableCopies: json['availableCopies'] ?? 0,
      totalCopies: json['totalCopies'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'category': category,
      'description': description,
      'coverImage': coverImage,
      'publishYear': publishYear,
      'availableCopies': availableCopies,
      'totalCopies': totalCopies,
      'rating': rating,
    };
  }
}