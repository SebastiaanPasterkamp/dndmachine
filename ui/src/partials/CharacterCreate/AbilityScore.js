import React from 'react';
import PropTypes from 'prop-types';
import StatisticsEdit from '../StatisticsEdit/StatisticsEdit';
import { useCharacterContext } from '../../context/CharacterContext';

export default function AbilityScore({ uuid, hidden, increase, bonuses }) {
  const { loading, character, getDecision, updateDecision } = useCharacterContext();

  if (hidden || loading) {
    return null;
  }

  const { statistics } = character || {};

  if (!statistics) return null;

  const decision = getDecision(uuid);

  const onChange = async (field, change) => updateDecision(uuid, field, change);

  return (
    <StatisticsEdit
      onChange={onChange}
      statistics={statistics}
      bonuses={bonuses}
      increase={increase}
      {...decision}
    />
  );
}

AbilityScore.defaultProps = {
  bonuses: {},
  hidden: false,
  increase: 0,
}

AbilityScore.propTypes = {
  uuid: PropTypes.string.isRequired,
  bonuses: PropTypes.objectOf(PropTypes.number),
  hidden: PropTypes.bool,
  increase: PropTypes.number,
};
