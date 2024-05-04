module space_war::combat_rule {
    const BASE_DAMAGE: u64 = 10;

    public fun calculate_damage(level: u64, base_damage: u64) -> u64 {
        // Example logic to scale damage based on level and base damage
        base_damage + (level * BASE_DAMAGE)
    }

    public fun is_player_winning(player_damage: u64, monster_health: u64) -> bool {
        player_damage >= monster_health
    }
}
