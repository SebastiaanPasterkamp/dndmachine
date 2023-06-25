import * as React from 'react';
import FormControl from '@mui/material/FormControl';
import FormHelperText from '@mui/material/FormHelperText';
import InputLabel from '@mui/material/InputLabel';
import Slider from '@mui/material/Slider';

export default function OutlinedRangeSlider({ helper, label, options, name, error = null, multiple = false, allowEmpty = false, ...rest }) {
  return (
    <FormControl
      variant="outlined"
      fullWidth
      margin="normal"
      sx={{ minHeight: 56, px: 1 }}
      {...(error && { error: true })}
    >
      <InputLabel>{label}</InputLabel>
      <Slider data-testid={`input-slider-${name}`} name={name} {...rest} />
      {(error || helper) && (
        < FormHelperText > {error || helper}</FormHelperText >
      )}
    </FormControl>
  );
}
