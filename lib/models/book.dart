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
}
