const sortMethod = {
  default: (a, b) => (a < b ? -1 : (a > b ? 1 : 0)),
};

sortMethod.cost = (a, b) => {
  a = { cp: 0, sp: 0, ep: 0, gp: 0, pp: 0, ...a };
  b = { cp: 0, sp: 0, ep: 0, gp: 0, pp: 0, ...b };
  a = a.cp + a.sp * 10 + a.ep * 50 + a.gp * 100 + a.pp * 1000;
  b = b.cp + b.sp * 10 + b.ep * 50 + b.gp * 100 + b.pp * 1000;
  return sortMethod.default(a, b);
};

sortMethod.value = sortMethod.cost;

sortMethod.weight = (a, b) => {
  a = { lb: 0, oz: 0, ...a };
  b = { lb: 0, oz: 0, ...b };
  a = a.lb * 16 + a.oz;
  b = b.lb * 16 + b.oz;
  return sortMethod.default(a, b);
};

sortMethod.armor = (a, b) => {
  a = { value: 0, bonus: 0, ...a };
  b = { value: 0, bonus: 0, ...b };
  a = a.value + a.bonus;
  b = b.value + b.bonus;
  return sortMethod.default(a, b);
};

sortMethod.damage = (a, b) => {
  a = { value: 0, bonus: 0, dice_size: 0, dice_count: 0, ...a };
  b = { value: 0, bonus: 0, dice_size: 0, dice_count: 0, ...b };
  a = a.value + a.bonus + a.dice_count * ((a.dice_size + 1) / 2);
  b = b.value + b.bonus + b.dice_count * ((b.dice_size + 1) / 2);
  return sortMethod.default(a, b);
};

sortMethod.versatile = sortMethod.damage;

sortMethod.range = (a, b) => {
  a = { min: 0, max: 0, ...a };
  b = { min: 0, max: 0, ...b };

  const max = sortMethod.default(a.max, b.max);
  if (max !== 0) {
    return max;
  }

  return sortMethod.default(a.min, b.min);
};

export default sortMethod;