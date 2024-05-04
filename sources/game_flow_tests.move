#[test_only]
module space_war::game_flow_tests {
    use space_war::game_objects::{Self, create_player, upgrade_space_fighter, assign_pilot_to_fighter};
    use space_war::combat_rule::{calculate_damage, is_player_winning};
    use sui::test_scenario::{Self, Scenario};
    use space_war::space_fighter::{SpaceFighter};

    #[test]
    fun test_full_gameplay_flow() {
        let mut scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;

        // Create player and caps
        let (player, admin_cap, owner_cap) = create_player(scenario);

        // Mint a pilot and assign to the space fighter
        let pilot_name = "Ace Pilot";
        assign_pilot_to_fighter(scenario, &owner_cap, &mut player, pilot_name);

        // Upgrade the space fighter
        let mut fighter = test_scenario::take_from_sender<SpaceFighter>(scenario);
        upgrade_space_fighter(scenario, &admin_cap, &mut fighter, &mut player);

        // Test combat logic against a monster (basic example)
        let player_damage = calculate_damage(player.level, 20);
        let monster_health = 80;
        assert!(is_player_winning(player_damage, monster_health), "Player should win this fight");

        test_scenario::end(scenario_val);
    }
}
