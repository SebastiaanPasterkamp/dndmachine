import React from 'react'
import PropTypes from 'prop-types';

import FormControl from '@mui/material/FormControl';
import FormControlLabel from '@mui/material/FormControlLabel';
import FormHelperText from '@mui/material/FormHelperText';
import Checkbox from '@mui/material/Checkbox';

export default function OutlinedCheckbox({ helper, label, value = false, error = null, onChange, ...rest }) {
  const onToggle = (e) => {
    const { name, checked: value } = e.target;
    onChange({ ...e, target: { name, value } })
  }

  return (
    <FormControl
      variant="outlined"
      fullWidth
      margin="normal"
      {...(error && { error: true })}
    >
      <FormControlLabel
        control={<Checkbox
          checked={value}
          {...rest}
          onChange={onToggle}
        />}
        label={label}
      />
      {(error || helper) && (
        < FormHelperText > {error || helper}</FormHelperText >
      )}
    </FormControl >
  )
}

OutlinedCheckbox.propTypes = {
  name: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
  value: PropTypes.bool,
  onChange: PropTypes.func.isRequired,
  helper: PropTypes.string,
  error: PropTypes.string,
}