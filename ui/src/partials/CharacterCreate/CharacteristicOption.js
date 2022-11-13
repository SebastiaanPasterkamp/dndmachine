import React from 'react';
import PropTypes from 'prop-types';

import types from './types';
import Typography from '@mui/material/Typography';
import Markdown from '../Markdown';
import { useCharacteristicsContext } from '../../context/CharacteristicsContext';

const CharacteristicOption = ({ uuid }) => {
  const { getCharacteristic } = useCharacteristicsContext();

  const {
    characteristic: { name = "", description = "", type, config },
  } = getCharacteristic(uuid);

  const Component = types[type];
  if (!Component) {
    return null;
  }
  const props = (!!config && config.constructor === Object) ? config : { config };

  return (
    <span>
      {name ? (
        <Typography
          variant="h6"
          component="div"
        >
          {name}
        </Typography>
      ) : null}

      <Markdown description={description} />

      <Component
        uuid={uuid}
        {...props}
      />
    </span>
  )
};

CharacteristicOption.propTypes = {
  uuid: PropTypes.string.isRequired,
};

export default CharacteristicOption;