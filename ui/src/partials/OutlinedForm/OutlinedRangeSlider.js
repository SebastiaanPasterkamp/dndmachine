import FormControl from '@mui/material/FormControl';
import FormHelperText from '@mui/material/FormHelperText';
import InputLabel from '@mui/material/InputLabel';
import Slider from '@mui/material/Slider';
import * as React from 'react';

export default function OutlinedRangeSlider({ helper, label, options, error = null, multiple = false, allowEmpty = false, ...rest }) {
  return (
    <FormControl
      variant="outlined"
      fullWidth
      margin="normal"
      sx={{ minHeight: 56, px: 1 }}
      error={!!error}
    >
      <InputLabel>{label}</InputLabel>
      <Slider {...rest} />
      {(error || helper) && (
        < FormHelperText > {error || helper}</FormHelperText >
      )}
    </FormControl>
  );
}
