import 'dart:async';
import 'dart:developer';

import 'package:card_game/features/online/room/models/online_table_entities.dart';
import 'package:card_game/features/online/room/models/room_lobby_snapshot.dart';
import 'package:card_game/features/online/room/models/room_lobby_snapshot_dto.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRoomRepository extends GetxService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<RoomLobbySnapshot> createRoom({required String displayName}) async {
    final response = await _client.rpc(
      'create_game_room',
      params: {'p_display_name': displayName.trim()},
    );
    return _snapshot(response);
  }

  Future<RoomLobbySnapshot> createTable({
    required String displayName,
    required String tableName,
    required int maxPlayers,
    required String visibility,
  }) async {
    final response = await _client.rpc(
      'create_table',
      params: {
        'p_display_name': displayName.trim(),
        'p_table_name': tableName.trim(),
        'p_max_players': maxPlayers,
        'p_visibility': visibility,
      },
    );
    log('create table resp $response');
    return _snapshot(response);
  }

  Future<RoomLobbySnapshot> joinRoom({
    required String joinCode,
    required String displayName,
  }) async {
    final response = await _client.rpc(
      'join_game_room',
      params: {
        'p_join_code': joinCode.replaceAll(RegExp(r'\s+'), '').toUpperCase(),
        'p_display_name': displayName.trim(),
      },
    );

    return _snapshot(response);
  }

  Future<RoomLobbySnapshot> joinMatchmaking({
    required String displayName,
    required int maxPlayers,
  }) async {
    final response = await _client.rpc(
      'join_matchmaking',
      params: {
        'p_display_name': displayName.trim(),
        'p_max_players': maxPlayers,
      },
    );
    return _snapshot(response);
  }

  Future<List<PublicTableSummary>> listPublicTables({int limit = 30}) async {
    final response = await _client.rpc(
      'list_public_tables',
      params: {'p_limit': limit},
    );
    return _list(response)
        .map(
          (row) => PublicTableSummary(
            roomId: '${row['room_id'] ?? ''}',
            tableName: '${row['table_name'] ?? 'Public Table'}',
            maxPlayers: _int(row['max_players']),
            playerCount: _int(row['player_count']),
            createdAt: DateTime.tryParse('${row['created_at'] ?? ''}'),
          ),
        )
        .toList(growable: false);
  }

  Future<RoomLobbySnapshot> joinPublicTable({
    required String roomId,
    required String displayName,
  }) async {
    final response = await _client.rpc(
      'join_public_table',
      params: {'p_room_id': roomId, 'p_display_name': displayName.trim()},
    );
    return _snapshot(response);
  }

  Future<PrivateTableInvite> getPrivateInvite({required String roomId}) async {
    final row = _map(
      await _client.rpc('get_private_invite', params: {'p_room_id': roomId}),
    );
    return PrivateTableInvite(
      roomId: '${row['room_id'] ?? roomId}',
      joinCode: '${row['join_code'] ?? ''}',
      inviteToken: '${row['invite_token'] ?? ''}',
    );
  }

  Future<RoomLobbySnapshot> joinPrivateInvite({
    required String inviteToken,
    required String displayName,
  }) async {
    final response = await _client.rpc(
      'join_private_invite',
      params: {
        'p_invite_token': inviteToken,
        'p_display_name': displayName.trim(),
      },
    );
    return _snapshot(response);
  }

  Future<List<RejoinableSession>> discoverRejoinableSessions() async {
    final response = await _client.rpc('discover_rejoinable_sessions');
    return _list(response)
        .map(
          (row) => RejoinableSession(
            roomId: '${row['room_id'] ?? ''}',
            tableName: '${row['table_name'] ?? 'Card Table'}',
            status: '${row['status'] ?? 'waiting'}',
            revision: _int(row['revision']),
            seatIndex: _int(row['seat_index']),
            isHost: row['is_host'] == true,
            updatedAt: DateTime.tryParse('${row['updated_at'] ?? ''}'),
          ),
        )
        .toList(growable: false);
  }

  Future<RoomLobbySnapshot> fetchLobby({required String roomId}) async =>
      _snapshot(
        await _client.rpc(
          'get_room_lobby_snapshot',
          params: {'p_room_id': roomId},
        ),
      );

  // Stream<int> watchLobbyRevision({required String roomId}) => _client
  //     .from('rooms')
  //     .stream(primaryKey: ['id'])
  //     .eq('id', roomId)
  //     .map((rows) => rows.isEmpty ? 0 : _int(rows.first['revision']))
  //     .distinct();

  Stream<int> watchLobbyRevision({required String roomId}) {
    return _client
        .from('rooms')
        .stream(primaryKey: ['id'])
        .eq('id', roomId)
        .map((rows) {
          log('STREAM EVENT: $rows');
          return rows.isEmpty ? 0 : _int(rows.first['revision']);
        });
  }

  Future<String> startGame({
    required String roomId,
    required int expectedRevision,
  }) async {
    final response = await _client.rpc(
      'start_game',
      params: {'p_room_id': roomId, 'p_expected_revision': expectedRevision},
    );
    return _map(response)['room_id']?.toString() ?? roomId;
  }

  Future<void> leaveLobby({
    required String roomId,
    required int expectedRevision,
  }) async {
    await _client.rpc(
      'leave_game',
      params: {'p_room_id': roomId, 'p_expected_revision': expectedRevision},
    );
  }

  static RoomLobbySnapshot _snapshot(dynamic value) =>
      RoomLobbySnapshotDto(_map(value)).toDomain();
  static int _int(dynamic value) =>
      value is int ? value : int.tryParse('$value') ?? 0;
  static Map<String, dynamic> _map(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is List && value.isNotEmpty && value.first is Map) {
      return Map<String, dynamic>.from(value.first as Map);
    }
    return const {};
  }

  static List<Map<String, dynamic>> _list(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList(growable: false);
  }

  Future<RoomLobbySnapshot> toggleReady({
    required String roomId,
    required bool isReady,
  }) async {
    final response = await _client.rpc(
      'toggle_ready',
      params: {'p_room_id': roomId, 'p_is_ready': isReady},
    );
    return _snapshot(response);
  }
}
