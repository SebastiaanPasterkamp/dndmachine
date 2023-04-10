import React from 'react';
import PropTypes from 'prop-types';
import types from './types';
import Typography from '@mui/material/Typography';
import Markdown from '../Markdown';
import { useCharacteristicsContext } from '../../context/CharacteristicsContext';

const CharacteristicOption = ({ uuid }) => {
  const { subscribe, getCharacteristic } = useCharacteristicsContext();
  const [state, updateState] = React.useState({
    loading: false,
    characteristic: {},
  });
  const setState = React.useCallback(
    update => updateState(original => ({ ...original, ...update })),
    [updateState],
  );

  const callback = React.useCallback(
    (updated, update) => {
      console.log('callback', { updated, update, uuid });
      if (uuid !== updated) return;
      setState(update);
    },
    [uuid, setState],
  );

  React.useEffect(() => {
    setState(getCharacteristic(uuid));
    return subscribe(callback);
  }, [uuid, setState, getCharacteristic, subscribe, callback]);

  const { loading, characteristic } = state;
  const { name = "", description = "", type, config } = characteristic;

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