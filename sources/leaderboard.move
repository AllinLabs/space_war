module space_war::leaderboard {
    use sui::table::{Table, Self};
    use sui::tx_context::TxContext;
    //drop
    struct Leaderboard has key, store {
        id: UID,
        entries: Table<address, u64>,
    }

    public fun create_leaderboard(ctx: &mut TxContext) -> Leaderboard {
        Leaderboard {
            id: object::new(ctx),
            entries: table::new(),
        }
    }

    public entry fun update_leaderboard(leaderboard: &mut Leaderboard, player_address: address, score: u64) {
        if (table::contains(&leaderboard.entries, player_address)) {
            let current_score = *table::borrow(&leaderboard.entries, player_address);
            if (score > current_score) {
                table::add(&mut leaderboard.entries, player_address, score);
            }
        } else {
            table::add(&mut leaderboard.entries, player_address, score);
        }
    }
}
