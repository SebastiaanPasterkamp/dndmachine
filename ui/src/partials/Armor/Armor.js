import * as React from 'react';
import PropTypes from 'prop-types';
import Tooltip from '@mui/material/Tooltip';
import Typography from '@mui/material/Typography';

const labels = {
  'AC': 'Armor Class',
  'D': 'Disadvantage on Stealth',
};

const formulas = [
  [/min\((\d+),\s*([^)]+)\)/, '$2 (max $1)', '$2 (maximum of $1)'],
  ['statistics.modifiers.strength', 'Str', 'Strength Modifier'],
  ['statistics.modifiers.dexterity', 'Dex', 'Dexterity Modifier'],
  ['statistics.modifiers.constitution', 'Con', 'Constitution Modifier'],
  ['statistics.modifiers.intelligence', 'Int', 'Intelligence Modifier'],
  ['statistics.modifiers.wisdom', 'Wis', 'Wisdom Modifier'],
  ['statistics.modifiers.charisma', 'Char', 'Charisma Modifier'],
];

export default function Armor({ formula, value, bonus, disadvantage }) {
  const text = [], title = [];

  if (value > 0) {
    text.push(`${value}AC`);
    title.push(`${value} ${labels['AC']}`)
  }

  if (formula) {
    const { short, long } = formulas.reduce(({ short, long }, [attr, replShort, replLong]) => {
      return {
        short: short.replace(attr, replShort),
        long: long.replace(attr, replLong),
      }
    }, { short: formula, long: formula });

    if (!value && !bonus) {
      text.push(`${short} AC`);
      title.push(`${long} ${labels['AC']}`)
    } else {
      title.push(`(${long})`)
    }
  }

  if (bonus > 0) {
    text.push(`+${bonus}AC`);
    title.push(`+${bonus} ${labels['AC']}`)
  } else if (bonus < 0) {
    text.push(`${bonus}AC`);
    title.push(`${bonus} ${labels['AC']}`)
  }

  if (disadvantage) {
    text.push(`(D)`);
    title.push(`(${labels['D']})`)
  }

  if (text.length === 0) {
    return null;
  }

  return (
    <Tooltip
      arrow
      component={'span'}
      title={title.join(' ')}
    >
      <Typography>{text.join(' ')}</Typography>
    </Tooltip >
  );
}

Armor.propTypes = {
  formula: PropTypes.string,
  value: PropTypes.number,
  bonus: PropTypes.number,
  disadvantage: PropTypes.bool,
};
