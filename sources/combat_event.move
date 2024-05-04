module space_war::combat_event {
    struct CombatOutcomeEvent has copy, drop {
        player_address: address,
        outcome: string, // e.g., "win", "loss"
        opponent_type: string, // e.g., "monster", "space_pirate"
    }

    public fun emit_combat_outcome(player_address: address, outcome: string, opponent_type: string) {
        event::emit(CombatOutcomeEvent {
            player_address,
            outcome,
            opponent_type,
        });
    }
}