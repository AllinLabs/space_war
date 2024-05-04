module space_war::score_event {
    struct ScoreUpdateEvent has copy, drop {
        player_address: address,
        new_score: u64,
    }

    public fun emit_score_update(player_address: address, new_score: u64) {
        event::emit(ScoreUpdateEvent {
            player_address,
            new_score,
        });
    }
}
