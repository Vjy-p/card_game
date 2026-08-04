create or replace function set_updated_at()
returns trigger
language plpgsql
as
$$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists trg_rooms_updated on rooms;

create trigger trg_rooms_updated
before update
on rooms
for each row
execute function set_updated_at();