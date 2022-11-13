import React from 'react';
import PropTypes from 'prop-types';
import { uuidv4 } from '../../utils';
import { OutlinedSelect } from '../OutlinedForm';
import CharacteristicOption from './CharacteristicOption';
import { useCharacteristicsContext } from '../../context/CharacteristicsContext';

import types from './types';

const CharacteristicConfigs = ({ config, onChange }) => {
  const { setFocus, updateCharacteristic } = useCharacteristicsContext();

  const onAdd = (e) => {
    e.preventDefault();
    const { name, value } = e.target;
    const uuid = uuidv4();

    onChange((config) => ([...(config || []), uuid]));
    updateCharacteristic(uuid, name, () => value);
    setFocus(uuid);
  }

  return (
    <span>
      {config ? config.map(uuid => (
        <CharacteristicOption
          key={uuid}
          uuid={uuid}
        />
      )) : null}

      <OutlinedSelect
        label="Add"
        name="type"
        value=""
        options={Object.values(types)}
        onChange={onAdd}
      />
    </span>
  )
};

CharacteristicConfigs.defaultProps = {
  config: [],
}

CharacteristicConfigs.propTypes = {
  config: PropTypes.arrayOf(PropTypes.string),
  onChange: PropTypes.func.isRequired,
};

export default CharacteristicConfigs;