module space_war::space_fighter {
    //drop
    use sui::object::{UID, Self};
    use sui::tx_context::TxContext;
    use sui::dynamic_object_field as dof;

    const INITIAL_FIGHTER_HEALTH: u64 = 100;
    const INITIAL_FIGHTER_DAMAGE: u64 = 20;

    struct SpaceFighter has key, store {
        id: UID,
        health: u64,
        damage: u64,
        // Additional fields can be linked dynamically
        attributes: vector<u8>,
    }

    public entry fun mint_fighter(ctx: &mut TxContext) -> SpaceFighter {
        SpaceFighter {
            id: object::new(ctx),
            health: INITIAL_FIGHTER_HEALTH,
            damage: INITIAL_FIGHTER_DAMAGE,
            attributes: vector[] // Initialize empty attributes for future upgrades
        }
    }
}
