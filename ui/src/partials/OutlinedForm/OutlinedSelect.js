import PropTypes from 'prop-types';
import React from 'react';

import FormControl from '@mui/material/FormControl';
import FormHelperText from '@mui/material/FormHelperText';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import Select from '@mui/material/Select';

export default function OutlinedSelect({ helper, label, options, error = null, multiple = false, allowEmpty = false, ...rest }) {
  return (
    <FormControl
      variant="outlined"
      fullWidth
      margin="normal"
      error={!!error}
    >
      <InputLabel>{label}</InputLabel>
      <Select {...rest} multiple={multiple}>
        {allowEmpty && <MenuItem value={null}>None</MenuItem>}
        {
          options.map(
            ({ id, name }) => (<MenuItem key={id} value={id}>{name}</MenuItem>)
          )
        }
      </Select>
      {(error || helper) && (
        < FormHelperText > {error || helper}</FormHelperText >
      )}
    </FormControl>
  )
}

OutlinedSelect.propTypes = {
  name: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
  value: PropTypes.oneOfType([
    PropTypes.number,
    PropTypes.string,
    PropTypes.arrayOf(PropTypes.oneOfType([
      PropTypes.number.isRequired,
      PropTypes.string.isRequired,
    ])),
  ]).isRequired,
  options: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.oneOfType([
        PropTypes.number.isRequired,
        PropTypes.string.isRequired,
      ]),
      name: PropTypes.string.isRequired,
    })
  ),
  onChange: PropTypes.func.isRequired,
  helper: PropTypes.string,
  error: PropTypes.string,
  allowEmpty: PropTypes.bool,
}