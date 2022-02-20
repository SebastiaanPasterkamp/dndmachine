import * as React from 'react';
import PropTypes from 'prop-types';
import Tooltip from '@mui/material/Tooltip';
import Typography from '@mui/material/Typography';

const labels = {
  'oz': ['Ounce', 'Ounces'],
  'lb': ['Pound', 'Pounds'],
};

const order = ['lb', 'oz'];

export default function Weight(props) {
  const { text, title } = order.reduce(({ text, title }, weight) => {
    const w = props[weight];
    if (w > 0) {
      text.push(`${w}${weight}.`);
      title.push(`${w} ${labels[weight][w === 1 ? 0 : 1]}`)
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
    </Tooltip >
  );
}

Weight.propTypes = {
  lb: PropTypes.number,
  oz: PropTypes.number,
};
