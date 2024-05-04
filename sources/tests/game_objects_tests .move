#[test_only]
module space_war::game_objects_tests {
    use space_war::game_objects::{Self, create_player, mint_missile, add_missile_to_fighter, upgrade_space_fighter};
    use sui::test_scenario::{Self, Scenario};
    use space_war::space_fighter::{SpaceFighter};

    #[test]
    fun test_create_player_and_missiles() {
        let mut scenario_val = test_scenario::begin(@0x1);
        let scenario = &mut scenario_val;

        // Create player and caps
        let (player, admin_cap, owner_cap) = create_player(scenario);

        // Mint a missile and add to the fighter
        let missile = mint_missile(scenario);
        let mut fighter = test_scenario::take_from_sender<SpaceFighter>(scenario);

        add_missile_to_fighter(scenario, &owner_cap, &mut fighter, missile);
        assert!(vector::length(&fighter.missiles) == 1, "Failed to add missile");

        // Test upgrading space fighter
        upgrade_space_fighter(scenario, &admin_cap, &mut fighter, &mut player);
        assert!(fighter.health > 100, "Space fighter upgrade failed");

        test_scenario::end(scenario_val);
    }
}
