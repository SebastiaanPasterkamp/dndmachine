import * as React from 'react';
import PropTypes from 'prop-types';
import Tooltip from '@mui/material/Tooltip';
import Typography from '@mui/material/Typography';

const labels = {
  'pp': 'Platinum',
  'gp': 'Gold',
  'ep': 'Electrum',
  'sp': 'Silver',
  'cp': 'Copper',
};

const order = ['pp', 'gp', 'ep', 'sp', 'cp'];

export default function Coinage(props) {
  const { text, title } = order.reduce(({ text, title }, coin) => {
    if (props[coin] > 0) {
      text.push(`${props[coin]}${coin}`);
      title.push(`${props[coin]} ${labels[coin]}`)
    }

    return { text, title };
  }, { text: [], title: [] });

  if (text.length === 0) {
    return null;
  }

  return (
    <Tooltip
      arrow
      component={'span'}
      title={title.join(', ')}
    >
      <Typography>{text.join(' ')}</Typography>
    </Tooltip>
  );
}

Coinage.propTypes = {
  pp: PropTypes.number,
  gp: PropTypes.number,
  ep: PropTypes.number,
  sp: PropTypes.number,
  cp: PropTypes.number,
};
