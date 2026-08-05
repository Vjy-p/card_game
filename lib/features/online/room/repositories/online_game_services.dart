import 'dart:developer';

import 'package:card_game/features/online/room/models/card_model.dart';
import 'package:card_game/features/online/room/models/online_player_model.dart';
import 'package:card_game/utils/custom_toast.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnlineGameService extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Stream<List<CardModel>> watchMyHand(String roomId, String myPlayerId) {
  //   return _supabase
  //       .from('game_cards')
  //       .stream(primaryKey: ['id'])
  //       .eq('room_id', roomId)
  //       .map(
  //         (data) => data
  //             .where(
  //               (row) =>
  //                   row['owner_player_id'].toString() == myPlayerId &&
  //                   row['zone'] == 'player_hand',
  //             )
  //             .map((json) => CardModel.fromJson(json))
  //             .toList(),
  //       );
  // }

  Stream<List<CardModel>> watchMyHand(String roomId, String myPlayerId) {
    return _supabase
        .from('game_cards')
        .stream(primaryKey: ['id'])
        .map(
          (data) => data
              .where(
                (row) =>
                    row['room_id'].toString() == roomId && // Filter room here
                    row['owner_player_id'].toString() ==
                        myPlayerId && // Filter player here
                    row['zone'] == 'player_hand',
              ) // Filter zone here
              .map((json) => CardModel.fromJson(json))
              .toList(),
        );
  }

  Stream<List<CardModel>> watchAllRoomCards(String roomId) {
    return _supabase
        .from('game_cards')
        .stream(primaryKey: ['id'])
        .map(
          (data) => data
              .where((row) => row['room_id'].toString() == roomId)
              .map((json) => CardModel.fromJson(json))
              .toList(),
        );
  }

  Stream<Map<String, dynamic>> watchTableState(String roomId) {
    return _supabase
        .from('rooms')
        .stream(primaryKey: ['id'])
        .eq('id', roomId)
        .map((data) => data.first);
  }

  // Future drawFromDeck({required String roomId}) async {
  //   final resp = await _supabase.rpc(
  //     'draw_card',
  //     params: {'p_room_id': roomId},
  //   );
  //   log('draw from deck $resp');
  //   return resp;
  // }
  // Inside OnlineGameService
  Future<Map<String, dynamic>> drawFromDeck({required String roomId}) async {
    try {
      final response = await _supabase.rpc(
        'draw_from_deck',
        params: {'p_room_id': roomId},
      );
      return Map<String, dynamic>.from(response);
    } catch (e) {
      log('Draw Deck Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> drawFromOpenCard({
    required String roomId,
  }) async {
    try {
      final response = await _supabase.rpc(
        'draw_from_open_card',
        params: {'p_room_id': roomId},
      );
      return Map<String, dynamic>.from(response);
    } catch (e) {
      log('Draw Deck Error: $e');
      rethrow;
    }
  }

  Future<bool> unlockJoker({
    required String roomId,
    required List<String> cardIds,
  }) async {
    final Map response = await _supabase.rpc(
      'unlock_joker_with_set',
      params: {
        'p_room_id': roomId,
        'p_card_ids': cardIds.map((id) => int.parse(id)).toList(),
      },
    );
    log('4th card resp $response');
    return response['success'] == true;
  }

  Future<bool> declareEndGame({
    required String roomId,
    required List<List<int>> sets,
  }) async {
    final Map response = await _supabase.rpc(
      'declare_and_end_game',
      params: {'p_room_id': roomId, 'p_grouped_card_ids': sets},
    );
    log('end game resp $response');
    return response['success'] == true;
  }

  // Inside OnlineGameService
  Stream<CardModel?> watchOpenCard(String roomId) {
    return _supabase
        .from('game_cards')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .map((data) {
          log('Realtime fired');
          // 1. Filter cards in the discard pile
          final discardCards = data
              .where((row) => row['zone'] == 'discard_pile')
              .toList();

          // 2. If empty, no card to show
          if (discardCards.isEmpty) return null;

          for (final card in discardCards) {
            log(
              'id=${card['id']} pile=${card['pile_position']} zone=${card['zone']} rank=${card['rank']}',
            );
          }

          // 3. Find the card with the HIGHEST pile_position (the top-most card)
          final topCard = discardCards.reduce((current, next) {
            final currentPos = current['pile_position'] as int? ?? 0;
            final nextPos = next['pile_position'] as int? ?? 0;
            return currentPos > nextPos ? current : next;
          });

          log(
            'TOP -> id=${topCard['id']} pile=${topCard['pile_position']} rank=${topCard['rank']}',
          );

          return CardModel.fromJson(topCard);
        });
  }

  Future<void> discardCard({
    required String roomId,
    required String cardId,
  }) async {
    try {
      await _supabase.rpc(
        'discard_card',
        params: {'p_room_id': roomId, 'p_card_id': int.parse(cardId)},
      );
    } catch (e) {
      customToast(message: e.toString());
      log('Error discard $e');
    }
  }

  Future reorderHand({
    required String roomId,
    required List<String> cardIds,
  }) async {
    try {
      log('room id $roomId');
      await _supabase.rpc(
        'reorder_hand',
        params: {'p_room_id': roomId, 'p_card_ids': cardIds},
      );
    } catch (e) {
      customToast(message: e.toString());
      log('Error discard $e');
    }
  }

  // Stream<List<OnlinePlayerModel>> watchRankings(String roomId) {
  //   return _supabase
  //       .from('players')
  //       .stream(primaryKey: ['id'])
  //       .eq('room_id', roomId)
  //       .map((rows) {
  //         log('rows $rows');
  //         return rows.map(OnlinePlayerModel.fromJson).toList()
  //           ..sort((a, b) => a.rank.compareTo(b.rank));
  //       });
  //   return _supabase
  //       .from('player_results')
  //       .stream(primaryKey: ['id'])
  //       .eq('room_id', roomId)
  //       .map((rows) {
  //         log('rows $rows');
  //         return rows.map(OnlinePlayerModel.fromJson).toList()
  //           ..sort((a, b) => a.rank.compareTo(b.rank));
  //       });
  // }

  Future<List<OnlinePlayerModel>> watchRankings(String roomId) async {
    final rows = await _supabase
        .from('player_results')
        .select()
        .eq('room_id', roomId);

    return (rows as List)
        .map((e) => OnlinePlayerModel.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));
  }

  Future<void> clearData() async {
    await _supabase.rpc('cleanup_finished_games');
  }
}
