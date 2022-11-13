import React from 'react';
import PropTypes from 'prop-types';
import { OutlinedInput, OutlinedCheckbox } from '../OutlinedForm';

const AbilityScore = ({ onChange, hidden, increase }) => {

  const updateField = async (e) => {
    const { name, value } = e.target;

    onChange((original) => ({
      ...original,
      [name]: value,
    }));
  };

  return (
    <span>
      <OutlinedCheckbox
        label="Hidden"
        name="hidden"
        value={hidden}
        onChange={updateField}
        helper="Only makes sense when granting flat bonuses."
      />

      <OutlinedInput
        label="Increase"
        name="increase"
        type="number"
        min={0}
        max={20}
        value={increase || ""}
        onChange={updateField}
        helper="Allow for one or more ability score increases."
      />
    </span>
  );
}

AbilityScore.propTypes = {
  onChange: PropTypes.func.isRequired,
  hidden: PropTypes.bool,
  increase: PropTypes.number,
  bonuses: PropTypes.objectOf(PropTypes.number),
};

export default AbilityScore;