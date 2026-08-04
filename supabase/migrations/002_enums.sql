DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'game_status_enum'
    ) THEN
        CREATE TYPE game_status_enum AS ENUM (
            'waiting',
            'playing',
            'finished'
        );
    END IF;
END $$;


DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'turn_phase_enum'
    ) THEN
        CREATE TYPE turn_phase_enum AS ENUM (
            'must_draw',
            'must_discard'
        );
    END IF;
END $$;


DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type WHERE typname = 'card_zone_enum'
    ) THEN
        CREATE TYPE card_zone_enum AS ENUM (
            'draw_pile',
            'discard_pile',
            'player_hand',
            'joker'
        );
    END IF;
END $$;