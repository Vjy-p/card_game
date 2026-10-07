/// Purchasable Coin Package model
class CoinPackage {
  final String id;
  final String title;
  final int coins;
  final double price;
  final String currency;
  final String? badge;
  final String description;

  const CoinPackage({
    required this.id,
    required this.title,
    required this.coins,
    double? price,
    double? priceUsd,
    this.currency = 'INR',
    this.badge,
    this.description = '',
  }) : price = price ?? priceUsd ?? 0.0;

  double get priceUsd => price;

  String get formattedPrice {
    if (currency.toUpperCase() == 'INR') {
      final isWhole = price.truncateToDouble() == price;
      return '₹${isWhole ? price.toInt() : price.toStringAsFixed(2)}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Smallest unit of currency (paise for INR, cents for USD)
  int get amountInSubunits => (price * 100).round();
  int get amountInPaise => amountInSubunits;
  int get amountInCents => amountInSubunits;

  static const List<CoinPackage> defaultPackages = [
    CoinPackage(
      id: 'coins_500',
      title: 'Pocket Stash',
      coins: 500,
      price: 80,
      currency: 'INR',
      description: 'Quick top-up for friendly matches',
    ),
    CoinPackage(
      id: 'coins_1500',
      title: 'Player Stack',
      coins: 1500,
      price: 240,
      currency: 'INR',
      badge: 'Popular',
      description: 'Great for weekly tournament entries',
    ),
    CoinPackage(
      id: 'coins_4000',
      title: 'High Roller Vault',
      coins: 4000,
      price: 599,
      currency: 'INR',
      badge: '+15% Bonus',
      description: 'Includes 500 bonus coins',
    ),
    CoinPackage(
      id: 'coins_10000',
      title: 'Grand Casino Chest',
      coins: 10000,
      price: 1299,
      currency: 'INR',
      badge: 'Best Value',
      description: 'Includes 2,000 bonus coins',
    ),
    CoinPackage(
      id: 'coins_25000',
      title: 'Champion Trove',
      coins: 25000,
      price: 2499,
      currency: 'INR',
      badge: '+30% Bonus',
      description: 'Maximum value for champion players',
    ),
  ];
}
