import React, { useEffect } from 'react';
import PropTypes from 'prop-types';
import { OutlinedInput } from '../OutlinedForm';
import { uuidv4 } from '../../utils';

import types from './types';

export default function CharacteristicOption({ uuid, name, type, config, onChange }) {
  const mounted = React.useRef(true);

  useEffect(() => {
    mounted.current = true;

    if (uuid) return

    if (mounted.current) onChange({ target: { name: 'uuid', value: uuidv4() } });

    return () => mounted.current = false;
  }, [uuid]);

  const Component = types[type]?.component;

  if (!Component) {
    return null;
  }

  return (
    <span>
      <OutlinedInput
        label="Name"
        name="name"
        required
        value={name || ""}
        onChange={onChange}
      />

      <Component
        {...config}
        onChange={onChange}
      />
    </span>
  );
}

CharacteristicOption.propTypes = {
  onChange: PropTypes.func.isRequired,
  type: PropTypes.string.isRequired,
  uuid: PropTypes.string,
  name: PropTypes.string,
  config: PropTypes.object,
};
