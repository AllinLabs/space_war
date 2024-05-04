module space_war::rule_tests {
    use space_war::combat_rule::{Self, calculate_damage};

    #[test]
    public fun test_calculate_damage() {
        let base_damage = 10;
        let level = 5;

        let calculated_damage = calculate_damage(level, base_damage);
        assert!(calculated_damage == (base_damage + level * 10), "Damage calculation failed");
    }
}
