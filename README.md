# space_war

## Explanation
game_objects.move:
### <strong>Space Fighter</strong> and <strong>Pilot Upgrade Logic</strong>:

`upgrade_space_fighter` and `upgrade_pilot` functions consume gold and upgrade the attributes of the fighter and pilot respectively.
### Reward Distribution:

`distribute_rewards` calculates an additional bonus if a pilot is linked to a fighter and adds it to the player's total.
### Monster and Space Pirate Generation:

`generate_monster` dynamically adjusts the monster's health and damage based on the current level.
`generate_space_pirate` returns a pirate with stronger stats if the level is a multiple of 20.
### Events:

<strong>MintPilotEvent, UpgradeEvent, RewardEvent, and PirateAppearanceEvent</strong> provide visibility into the game's progress.

## Leaderboard Structure:
### LeaderboardEntry: 

Holds each player's score and address.
### Leaderboard: 

Contains the entire collection of leaderboard entries.
### Update Functionality:

`update_leaderboard`: Searches for existing player scores or creates new entries if needed.
### Ranking Retrieval:

`get_ranking`: Returns a sorted vector of leaderboard entries in descending order of score.
#### Events_Led:

LeaderboardUpdateEvent: Indicates when the leaderboard is updated.


### Tests and rules:
##### Modular Rules and Events:

The combat and resource rules focus on their specific concerns and avoid cluttering other files.
The event modules provide standardized event notifications for various game mechanics.
##### Testing Suite:

The game tests verify the correctness of core gameplay logic like upgrades and rewards.
The rule tests ensure that policies and calculations align with expected behavior.