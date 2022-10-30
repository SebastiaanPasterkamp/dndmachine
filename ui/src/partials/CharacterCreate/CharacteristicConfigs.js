import React from 'react';
import PropTypes from 'prop-types';

import types from './types';
import Typography from '@mui/material/Typography';
import Markdown from '../Markdown';
import { useCharacteristicsContext } from '../../context/CharacteristicsContext';

const CharacteristicConfigs = ({ config }) => {
  const { getCharacteristic } = useCharacteristicsContext();

  return (
    <span>
      {config.map((uuid) => {
        const {
          loading,
          characteristic: { name = "", description = "", type, ...config },
        } = getCharacteristic(uuid);

        console.log({ loading, name, description, type, config, uuid });

        if (loading) return null;

        const Component = types[type];
        if (!Component) return null;

        return (
          <span key={uuid} >
            {name ? (
              <Typography
                variant="h6"
                component="div"
              >
                {name}
              </Typography>
            ) : null}

            <Markdown description={description} />

            <Component {...config} />
          </span>
        )
      })}
    </span>
  );
}

CharacteristicConfigs.propTypes = {
  config: PropTypes.arrayOf(PropTypes.string).isRequired,
};

export default CharacteristicConfigs;