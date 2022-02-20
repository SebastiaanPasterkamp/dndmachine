import * as React from 'react';
import PropTypes from 'prop-types';
import Tooltip from '@mui/material/Tooltip';
import Typography from '@mui/material/Typography';

const labels = {
  'acid': { label: "Acid", short: "acd" },
  'bludgeoning': { label: "Bludgeoning", short: "bldg" },
  'cold': { label: "Cold", short: "cld" },
  'fire': { label: "Fire", short: "fr" },
  'force': { label: "Force", short: "frc" },
  'lightning': { label: "Lightning", short: "ltn" },
  'necrotic': { label: "Necrotic", short: "ncr" },
  'piercing': { label: "Piercing", short: "pcn" },
  'poison': { label: "Poison", short: "psn" },
  'psychic': { label: "Psychic", short: "psy" },
  'radiant': { label: "Radiant", short: "rdnt" },
  'slashing': { label: "Slashing", short: "slsh" },
  'thunder': { label: "Thunder", short: "tndr" },
};

function notation({ dice_count, dice_size, value, bonus, type }) {
  const notation =
    (value ? value : ((dice_count && dice_size) ? `${dice_count}d${dice_size}` : ''))
    + (bonus > 0 ? `+${bonus}` : '')
    + (bonus < 0 ? `${bonus}` : '')

  if (!notation.length) {
    return { text: '', title: '' }
  }

  const label = labels[type] || { short: type, label: type };

  return { text: `${notation} ${label.short}`, title: `${notation} ${label.label}` }
}

function Render({ text, title, label }) {
  return (
    <Tooltip
      arrow
      component={'span'}
      title={`${title} ${label}`}
    >
      <Typography>{text}</Typography>
    </Tooltip >
  );
}

export default function Damage({ damage = {}, versatile = {} }) {
  const dmg = notation(damage);
  const vstl = notation(versatile);

  if (dmg.text.length === 0) {
    return null;
  }

  return (
    <>
      <Render label="damage" {...dmg} />
      {vstl.text && ' / '}
      {vstl.text && <Render label="damage if used 2-handed" {...vstl} />}
    </>
  );
}

const damageProp = PropTypes.shape({
  dice_count: PropTypes.number,
  dice_size: PropTypes.number,
  value: PropTypes.number,
  bonus: PropTypes.number,
  type: PropTypes.string,
});

Damage.propTypes = {
  damage: damageProp,
  versatile: damageProp,
};