create or replace function append_game_event(

    p_room text,

    p_player bigint,

    p_type text,

    p_payload jsonb default '{}'

)

returns void

language plpgsql

as
$$

begin

insert into game_events(

room_id,

player_id,

event_type,

payload

)

values(

p_room,

p_player,

p_type,

p_payload

);

end;

$$;