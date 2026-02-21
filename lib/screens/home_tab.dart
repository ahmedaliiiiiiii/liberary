// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/book.dart';
import '../widgets/book_details_sheet.dart';
import '../widgets/mobile_book_card.dart';

class HomeTab extends StatelessWidget {
  final List<Book> books;
  final Set<String> checkedOutBookIds;
  final Set<String> favoriteBookIds;
  final Function(Book) onCheckout;
  final Function(String) onToggleFavorite;

  const HomeTab({
    super.key,
    required this.books,
    required this.checkedOutBookIds,
    required this.favoriteBookIds,
    required this.onCheckout,
    required this.onToggleFavorite,
  });

  void _showBookDetails(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookDetailsSheet(
        book: book,
        isCheckedOut: checkedOutBookIds.contains(book.id),
        isFavorite: favoriteBookIds.contains(book.id),
        onCheckout: () {
          Navigator.pop(context);
          onCheckout(book);
        },
        onToggleFavorite: () {
          onToggleFavorite(book.id);
        },
      ),
    );
  }

  List<Book> _getRecommendedBooks() {
    // Get categories from checked out and favorited books
    final userCategories = <String>{};
    for (final bookId in [...checkedOutBookIds, ...favoriteBookIds]) {
      final book =
          books.firstWhere((b) => b.id == bookId, orElse: () => books.first);
      userCategories.add(book.category);
    }

    // If user has no activity, recommend top rated books
    if (userCategories.isEmpty) {
      final topRated = [...books]..sort((a, b) => b.rating.compareTo(a.rating));
      return topRated.take(4).toList();
    }

    // Recommend books from user's favorite categories that aren't checked out or favorited
    final recommendations = books.where((book) {
      return userCategories.contains(book.category) &&
          !checkedOutBookIds.contains(book.id) &&
          !favoriteBookIds.contains(book.id) &&
          book.isAvailable;
    }).toList();

    // Sort by rating
    recommendations.sort((a, b) => b.rating.compareTo(a.rating));

    // If not enough recommendations, add other high-rated books
    if (recommendations.length < 4) {
      final otherBooks = books.where((book) {
        return !checkedOutBookIds.contains(book.id) &&
            !favoriteBookIds.contains(book.id) &&
            book.isAvailable &&
            !recommendations.contains(book);
      }).toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));

      recommendations.addAll(otherBooks.take(4 - recommendations.length));
    }

    return recommendations.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topRatedBooks = [...books]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final featuredBooks = topRatedBooks.take(5).toList();
    final popularBooks = books
        .where((b) => b.availableCopies > 0 && b.availableCopies < 3)
        .take(4)
        .toList();
    final recentBooks = [...books]
      ..sort((a, b) => b.publishYear.compareTo(a.publishYear));
    final recentAdditions = recentBooks.take(4).toList();
    final recommendedBooks = _getRecommendedBooks();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        MockData.mockUser.initials,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${MockData.mockUser.firstName}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'What will you read today?',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    if (checkedOutBookIds.isNotEmpty)
                      Badge(
                        label: Text('${checkedOutBookIds.length}'),
                        child: const Icon(Icons.notifications_outlined),
                      ),
                  ],
                ),
              ),
            ),

            // Hero Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withBlue(200),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.trending_up,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Discover Amazing Books',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse our collection of ${books.length} books across multiple genres',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top Rated Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade700, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Top Rated',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MobileBookCard(
                      book: featuredBooks[index],
                      isCheckedOut:
                          checkedOutBookIds.contains(featuredBooks[index].id),
                      isFavorite:
                          favoriteBookIds.contains(featuredBooks[index].id),
                      onTap: () =>
                          _showBookDetails(context, featuredBooks[index]),
                    ),
                  ),
                  childCount: featuredBooks.length,
                ),
              ),
            ),

            // Popular Now Section
            if (popularBooks.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      Icon(Icons.local_fire_department,
                          color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Popular Now',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MobileBookCard(
                        book: popularBooks[index],
                        isCheckedOut:
                            checkedOutBookIds.contains(popularBooks[index].id),
                        isFavorite:
                            favoriteBookIds.contains(popularBooks[index].id),
                        onTap: () =>
                            _showBookDetails(context, popularBooks[index]),
                      ),
                    ),
                    childCount: popularBooks.length,
                  ),
                ),
              ),
            ],

            // Recommended Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Icon(Icons.recommend,
                        color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Recommended for You',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MobileBookCard(
                      book: recommendedBooks[index],
                      isCheckedOut: checkedOutBookIds
                          .contains(recommendedBooks[index].id),
                      isFavorite:
                          favoriteBookIds.contains(recommendedBooks[index].id),
                      onTap: () =>
                          _showBookDetails(context, recommendedBooks[index]),
                    ),
                  ),
                  childCount: recommendedBooks.length,
                ),
              ),
            ),

            // Recent Additions Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Icon(Icons.schedule,
                        color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Recent Additions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MobileBookCard(
                      book: recentAdditions[index],
                      isCheckedOut:
                          checkedOutBookIds.contains(recentAdditions[index].id),
                      isFavorite:
                          favoriteBookIds.contains(recentAdditions[index].id),
                      onTap: () =>
                          _showBookDetails(context, recentAdditions[index]),
                    ),
                  ),
                  childCount: recentAdditions.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
