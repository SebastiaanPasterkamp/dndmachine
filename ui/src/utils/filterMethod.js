const filterMethod = {
  text: (needle, haystack) => {
    if (!needle) return true;
    if (!haystack) return true;
    return haystack.toLowerCase().includes(needle.toLowerCase());
  },
  range: ({ min = 0, max = 0 } = {}, value) => {
    if (min > 0 && value < min) return false;
    if (max > 0 && value > max) return false;
    return true
  },
};

filterMethod.armor = (range, armor) => {
  armor = { value: 0, bonus: 0, ...armor };
  armor = armor.value + armor.bonus;
  return filterMethod.range(range, armor)
};

filterMethod.damage = (range, damage) => {
  damage = { bonus: 0, dice_count: 0, dice_size: 0, ...damage };
  damage = damage.dice_count * ((1 + damage.dice_size) / 2) + damage.bonus;
  return filterMethod.range(range, damage)
};

filterMethod.cost = (range, coins) => {
  coins = { cp: 0, sp: 0, ep: 0, gp: 0, pp: 0, ...coins };
  coins = coins.cp + coins.sp * 10 + coins.ep * 50 + coins.gp * 100 + coins.pp * 1000;
  return filterMethod.range(range, coins)
}

filterMethod.value = filterMethod.cost;

filterMethod.weight = (range, weight) => {
  weight = { lb: 0, oz: 0, ...weight };
  weight = weight.lb + weight.oz * 16;
  return filterMethod.range(range, weight)
};

export default filterMethod;