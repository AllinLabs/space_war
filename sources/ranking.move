module space_war::ranking {
    use sui::object::{Self, UID};
    use sui::event;
    use sui::tx_context::{Self, TxContext};

    // Structure for storing individual player scores in the leaderboard
    public struct LeaderboardEntry has key, store {
        id: UID,
        player_address: address,
        score: u64,
    }

    // Main leaderboard structure containing all player entries
    public struct Leaderboard has key, store {
        id: UID,
        entries: vector<LeaderboardEntry>,
    }

    // Event for when the leaderboard is updated
    struct LeaderboardUpdateEvent has copy, drop {
        player_address: address,
        new_score: u64,
    }

    // Create a new leaderboard structure
    public fun create_leaderboard(ctx: &mut TxContext) -> Leaderboard {
        Leaderboard {
            id: object::new(ctx),
            entries: vector::empty(),
        }
    }

    // Add or update a player's score in the leaderboard
    public fun update_leaderboard(leaderboard: &mut Leaderboard, player_address: address, score: u64) {
        // Search for the player's existing entry
        let mut updated = false;
        let mut i = 0;
        while (i < vector::length(&leaderboard.entries)) {
            let entry = vector::borrow_mut(&mut leaderboard.entries, i);
            if (entry.player_address == player_address) {
                // Update the existing score entry
                entry.score = score;
                updated = true;
                break;
            }
            i = i + 1;
        }

        // If the player is not found, create a new entry
        if (!updated) {
            let new_entry = LeaderboardEntry {
                id: object::new(&mut leaderboard.id),
                player_address,
                score,
            };
            vector::push_back(&mut leaderboard.entries, new_entry);
        }

        // Emit an event indicating that the leaderboard has been updated
        event::emit(LeaderboardUpdateEvent {
            player_address,
            new_score: score,
        });
    }

    // Retrieve a sorted vector of leaderboard entries, ordered by score
    public fun get_ranking(leaderboard: &Leaderboard) -> vector<LeaderboardEntry> {
        // Clone the entries and sort them by score in descending order
        let mut sorted_entries = vector::clone(&leaderboard.entries);
        vector::sort_by(&mut sorted_entries, compare_scores);
        sorted_entries
    }

    // Comparison function to sort leaderboard entries by score
    fun compare_scores(entry1: &LeaderboardEntry, entry2: &LeaderboardEntry) -> bool {
        entry1.score > entry2.score
    }
}
