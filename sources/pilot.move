module space_war::pilot {
    use sui::dynamic_object_field as dof;
    use sui::object::{UID, Self};
    use sui::tx_context::TxContext;

    const INITIAL_PILOT_XP: u64 = 0;

    struct Pilot has key, store {
        id: UID,
        name: string,
        experience: u64,
    }

    public entry fun mint_pilot(ctx: &mut TxContext, name: string) -> Pilot {
        Pilot {
            id: object::new(ctx),
            name,
            experience: INITIAL_PILOT_XP,
        }
    }

    public entry fun assign_fighter_pilot(fighter_id: &UID, pilot: Pilot) {
        // Add pilot to fighter attributes via dynamic object field
        dof::add(fighter_id, b"pilot", pilot);
    }
}
