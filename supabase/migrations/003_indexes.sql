create index if not exists idx_rooms_join_code
on rooms(join_code);

create index if not exists idx_rooms_status
on rooms(game_status);

create index if not exists idx_players_room
on players(room_id);

create index if not exists idx_players_user
on players(user_id);

create index if not exists idx_players_room_seat
on players(room_id, seat_index);

create index if not exists idx_cards_room
on game_cards(room_id);

create index if not exists idx_cards_owner
on game_cards(owner_player_id);

create index if not exists idx_cards_zone
on game_cards(zone);

create index if not exists idx_cards_room_zone
on game_cards(room_id, zone);

create index if not exists idx_cards_room_position
on game_cards(room_id, pile_position);