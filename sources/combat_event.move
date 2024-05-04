module space_war::game_objects {
    use sui::object::{UID, Self};
    use sui::tx_context::{Self, TxContext};
    use sui::event;
    use sui::dynamic_object_field as dof;
    use space_war::combat_event::{emit_combat_outcome};
    use space_war::combat_rule::{calculate_damage, is_player_winning};
    use space_war::leaderboard::{Leaderboard, update_leaderboard};
    use space_war::ranking::{LeaderboardEntry};
    use space_war::pilot::{mint_pilot};
    use space_war::score_event::{emit_score_update};
    use space_war::space_fighter::{mint_fighter, SpaceFighter};
    use space_war::resource_rule::{calculate_gold_reward};

    // Constants
    const INITIAL_PLAYER_LEVEL: u64 = 1;
    const INITIAL_GOLD: u64 = 0;
    const FIGHTER_UPGRADE_HEALTH: u64 = 30;
    const FIGHTER_UPGRADE_DAMAGE: u64 = 15;
    const PILOT_XP_GAIN: u64 = 10;
    const MAX_PILOT_UPGRADE_LEVEL: u64 = 5;

    // Admin Cap Structure (to manage admin-only upgrades)
    public struct AdminCap has key {
        id: UID,
    }

    // Owner Cap Structure (to manage ownership and permissions)
    public struct OwnerCap has key, store {
        id: UID,
        owner: address,
    }

    // Player Structure
    public struct Player has key, store {
        id: UID,
        address: address,
        level: u64,
        gold: u64,
        fighter: UID, // Links to a Space Fighter
    }

    // Monster Structure
    public struct Monster has copy, drop {
        health: u64,
        damage: u64,
    }

    // Public Functions

    // Create a new Player with Admin and Owner Cap
    public entry fun create_player(ctx: &mut TxContext) -> (Player, AdminCap, OwnerCap) {
        let fighter = mint_fighter(ctx);
        let player_id = object::new(ctx);
        let address = tx_context::sender(ctx);

        let player = Player {
            id: player_id,
            address,
            level: INITIAL_PLAYER_LEVEL,
            gold: INITIAL_GOLD,
            fighter: fighter.id,
        };

        let admin_cap = AdminCap {
            id: object::new(ctx),
        };

        let owner_cap = OwnerCap {
            id: object::new(ctx),
            owner: address,
        };

        (player, admin_cap, owner_cap)
    }

    // Mint a Pilot and link to a Space Fighter
    public entry fun assign_pilot_to_fighter(ctx: &mut TxContext, owner_cap: &OwnerCap, player: &mut Player, name: string) {
        assert!(tx_context::sender(ctx) == owner_cap.owner, "Unauthorized: Only the owner can assign a pilot");
        let pilot = mint_pilot(ctx, name);
        dof::add(&player.fighter, b"pilot", pilot);
    }

    // Upgrade Space Fighter attributes using Admin Cap
    public entry fun upgrade_space_fighter(ctx: &mut TxContext, admin_cap: &AdminCap, fighter: &mut SpaceFighter, player: &mut Player) {
        assert!(admin_cap.id != UID::default(), "Invalid admin cap");
        assert!(player.gold >= FIGHTER_UPGRADE_HEALTH, "Not enough gold for fighter upgrade");

        // Deduct gold
        player.gold -= FIGHTER_UPGRADE_HEALTH;

        // Upgrade health and damage
        fighter.health += FIGHTER_UPGRADE_HEALTH;
        fighter.damage += FIGHTER_UPGRADE_DAMAGE;

        event::emit(UpgradeFighterEvent {
            fighter_id: fighter.id,
            new_health: fighter.health,
            new_damage: fighter.damage,
        });
    }

    // Upgrade Pilot attributes with permission check
    public entry fun upgrade_pilot(ctx: &mut TxContext, owner_cap: &OwnerCap, player: &mut Player) {
        assert!(tx_context::sender(ctx) == owner_cap.owner, "Unauthorized: Only the owner can upgrade a pilot");
        assert!(player.gold >= PILOT_XP_GAIN, "Not enough gold for pilot upgrade");

        // Retrieve pilot information via dynamic object field
        let pilot = dof::borrow_mut<vector<u8>, space_war::pilot::Pilot>(&mut player.fighter, b"pilot");

        // Check pilot's level
        assert!(pilot.experience / PILOT_XP_GAIN < MAX_PILOT_UPGRADE_LEVEL, "Max pilot upgrade level reached");

        // Deduct gold and increase pilot experience
        player.gold -= PILOT_XP_GAIN;
        pilot.experience += PILOT_XP_GAIN;

        event::emit(UpgradePilotEvent {
            pilot_id: pilot.id,
            new_experience: pilot.experience,
        });
    }

    // Event Structures
    struct UpgradeFighterEvent has copy, drop {
        fighter_id: UID,
        new_health: u64,
        new_damage: u64,
    }

    struct UpgradePilotEvent has copy, drop {
        pilot_id: UID,
        new_experience: u64,
    }
}
