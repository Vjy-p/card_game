import 'dart:collection';
import 'dart:math';

import 'package:card_game/features/offline/controllers/deck/dec_builder.dart';
import 'package:card_game/features/offline/models/passed_card_record.dart';
import 'package:card_game/features/offline/models/playing_card.dart';

class DeckManager {
  DeckManager({int? seed}) : _random = seed == null ? Random() : Random(seed);

  final Random _random;

  /// Builder used to create fresh physical decks.
  final DeckBuilder _builder = DeckBuilder();

  /// Closed draw pile.
  final Queue<PlayingCard> _closedDeck = Queue<PlayingCard>();

  /// Every forwarded card except the current one.
  ///
  /// Used when reshuffling.
  final List<PassedCardRecord> _passedHistory = [];

  /// Visible forward card.
  PlayingCard? _forwardCard;

  /// Hidden joker selected at game start.
  PlayingCard? _hiddenJoker;
  PlayingCard? _openCard;

  /// Number of physical decks.
  int _deckCount = 0;

  /// Total players.
  int _playerCount = 0;

  bool _initialized = false;

  List<PassedCardRecord> get passedHistory => List.unmodifiable(_passedHistory);

  PassedCardRecord? get lastPassedCard {
    if (_passedHistory.isEmpty) {
      return null;
    }

    return _passedHistory.last;
  }

  void initialize({required int playerCount}) {
    if (playerCount < 2 || playerCount > 10) {
      throw ArgumentError('Player count must be between 2 and 10.');
    }

    _playerCount = playerCount;
    _deckCount = _calculateDeckCount(playerCount);

    _closedDeck.clear();
    _passedHistory.clear();

    _forwardCard = null;
    _hiddenJoker = null;
    _openCard = null;

    final cards = _builder.build(_deckCount);

    _shuffle(cards);

    _selectHiddenJoker(cards);
    _selectOpenCard(cards);

    _closedDeck.addAll(cards);

    _initialized = true;
  }

  Map<int, List<PlayingCard>> dealCards({int cardsPerPlayer = 13}) {
    _ensureInitialized();

    final hands = <int, List<PlayingCard>>{};

    for (int seat = 0; seat < _playerCount; seat++) {
      hands[seat] = <PlayingCard>[];
    }

    for (int round = 0; round < cardsPerPlayer; round++) {
      for (int seat = 0; seat < _playerCount; seat++) {
        if (_closedDeck.isEmpty) {
          throw StateError('Not enough cards to deal.');
        }

        hands[seat]!.add(_closedDeck.removeFirst());
      }
    }

    return hands;
  }

  PlayingCard revealInitialForwardCard() {
    _ensureInitialized();

    if (_forwardCard != null) {
      throw StateError('Forward card already exists.');
    }

    if (_closedDeck.isEmpty) {
      throw StateError('Closed deck is empty.');
    }

    _forwardCard = _closedDeck.removeFirst();

    return _forwardCard!;
  }

  PlayingCard drawCard() {
    _ensureInitialized();

    if (_closedDeck.isEmpty) {
      _reshuffle();
    }

    if (_closedDeck.isEmpty) {
      throw StateError('No cards available.');
    }

    return _closedDeck.removeFirst();
  }

  void _reshuffle() {
    if (_passedHistory.isEmpty) {
      return;
    }

    final cards = _passedHistory.map((record) => record.card).toList();

    _passedHistory.clear();

    _shuffle(cards);

    _closedDeck.addAll(cards);
  }

  PlayingCard takeForwardCard() {
    _ensureInitialized();

    if (_forwardCard == null) {
      throw StateError('Forward card does not exist.');
    }

    final card = _forwardCard!;

    _forwardCard = null;

    return card;
  }

  void passCard({required PlayingCard card, required int playerSeat}) {
    _ensureInitialized();

    if (_forwardCard != null) {
      _passedHistory.add(
        PassedCardRecord(
          card: _forwardCard!,
          playerSeat: playerSeat,
          time: DateTime.now(),
        ),
      );
    }

    _forwardCard = card;
  }

  //----------------------------------------------------------------------------
  // Deck Count
  //----------------------------------------------------------------------------

  int _calculateDeckCount(int players) {
    if (players <= 4) {
      return 2;
    }

    if (players <= 7) {
      return 3;
    }

    return 4;
  }

  //----------------------------------------------------------------------------
  // Fisher–Yates Shuffle
  //----------------------------------------------------------------------------

  void _shuffle(List<PlayingCard> cards) {
    for (int i = cards.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);

      final temp = cards[i];

      cards[i] = cards[j];

      cards[j] = temp;
    }
  }

  //----------------------------------------------------------------------------
  // Hidden Joker
  //----------------------------------------------------------------------------

  /// Selects one random card as the hidden joker.
  ///
  /// IMPORTANT:
  ///
  /// The joker REMAINS inside the deck.
  /// It is NOT removed.
  ///
  void _selectHiddenJoker(List<PlayingCard> cards) {
    final index = _random.nextInt(cards.length);

    _hiddenJoker = cards[index];
  }

  void _selectOpenCard(List<PlayingCard> cards) {
    final index = _random.nextInt(cards.length);

    _openCard = cards[index];
  }

  //----------------------------------------------------------------------------
  // Internal Validation
  //----------------------------------------------------------------------------

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('DeckManager has not been initialized.');
    }
  }

  //----------------------------------------------------------------------------
  // Read Only Getters
  //----------------------------------------------------------------------------

  int get deckCount => _deckCount;

  int get playerCount => _playerCount;

  int get closedDeckCount => _closedDeck.length;

  int get passedHistoryCount => _passedHistory.length;

  bool get isEmpty => _closedDeck.isEmpty;

  bool get hasForwardCard => _forwardCard != null;

  PlayingCard get hiddenJoker {
    _ensureInitialized();

    return _hiddenJoker!;
  }

  PlayingCard get openCard {
    _ensureInitialized();
    return _openCard!;
  }

  PlayingCard? get forwardCard => _forwardCard;

  void clearData() {
    _playerCount = 0;
    _deckCount = 0;

    _closedDeck.clear();
    _passedHistory.clear();

    _forwardCard = null;
    _hiddenJoker = null;
    _openCard = null;

    final cards = _builder.build(_deckCount);
    _shuffle(cards);
    // _selectHiddenJoker(cards);
    // _selectOpenCard(cards);
    // _closedDeck.addAll(cards);
    _initialized = false;
  }
}
