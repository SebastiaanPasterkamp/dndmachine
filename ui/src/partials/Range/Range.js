import * as React from 'react';
import PropTypes from 'prop-types';
import Tooltip from '@mui/material/Tooltip';
import Typography from '@mui/material/Typography';

const labels = {
  'ft': 'Feet',
};

export default function Range({ min = 0, max = 0 }) {
  const text = [], title = [];

  if (min > 0) {
    text.push(`${min}ft.`);
    title.push(`${min} ${labels['ft']}`)
  }

  if (max > min) {
    text.push(`${max}ft.`);
    title.push(`${max} ${labels['ft']}${min > 0 ? ' with disadvantage' : ''}`)
  }

  if (text.length === 0) {
    return null;
  }

  return (
    <Tooltip
      arrow
      component={'span'}
      title={title.join(' - ')}
    >
      <Typography>{text.join(' - ')}</Typography>
    </Tooltip >
  );
}

Range.propTypes = {
  min: PropTypes.number,
  max: PropTypes.number,
};
