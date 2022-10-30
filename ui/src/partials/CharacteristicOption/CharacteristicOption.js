import React from 'react';
import PropTypes from 'prop-types';
import { OutlinedInput } from '../OutlinedForm';
import { useCharacteristicsContext } from '../../context/CharacteristicsContext';

import types from './types';

export default function CharacteristicOption({ uuid }) {
  const { getCharacteristic, updateCharacteristic } = useCharacteristicsContext();

  const {
    loading,
    characteristic: { name = "", description = "", type, ...config },
  } = getCharacteristic(uuid);

  console.log({ loading, name, description, type, config, uuid });

  if (loading) return null;

  const Component = types[type]?.component;
  if (!Component) {
    return null;
  }

  const onChange = async (e) => {
    const { name, value } = e.target;

    updateCharacteristic(uuid, name, () => value);
  }

  return (
    <span>
      <OutlinedInput
        label="Name"
        name="name"
        required
        value={name}
        onChange={onChange}
      />

      <OutlinedInput
        label="Description"
        name="description"
        multiline
        maxRows={10}
        value={description}
        onChange={onChange}
      />

      <Component {...config} onChange={onChange} />
    </span>
  );
}

CharacteristicOption.propTypes = {
  uuid: PropTypes.string.isRequired,
};
