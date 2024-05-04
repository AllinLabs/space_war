module space_war::resource_rule {
    const BASE_GOLD_REWARD: u64 = 100;

    public fun calculate_gold_reward(level: u64) -> u64 {
        // Example logic to calculate gold rewards based on level
        BASE_GOLD_REWARD + (level * 20)
    }

    public fun reward_gold(player: &mut space_war::game::Player, reward: u64) {
        player.gold = player.gold + reward;
    }
}
