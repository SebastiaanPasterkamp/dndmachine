import React from 'react';
import PropTypes from 'prop-types';

import CharacteristicOption from './CharacteristicOption';

const CharacteristicConfigs = ({ config }) => config.map(uuid => (
  <CharacteristicOption
    key={uuid}
    uuid={uuid}
  />
))

CharacteristicConfigs.defaultProps = {
  config: [],
}

CharacteristicConfigs.propTypes = {
  config: PropTypes.arrayOf(PropTypes.string).isRequired,
};

export default CharacteristicConfigs;