import React from 'react'
import PropTypes from 'prop-types';
import InputAdornment from '@mui/material/InputAdornment';
import TextField from '@mui/material/TextField';
import IconButton from '@mui/material/IconButton';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';

export default function OutlinedInput({ helper, value, type = null, unit = null, error = null, ...rest }) {
  const [showPassword, setShowPassword] = React.useState(false);

  const toggleShowPassword = () => {
    setShowPassword(!showPassword);
  }

  const cancelEvent = (event) => {
    event.preventDefault();
  };

  return (
    <TextField
      variant="outlined"
      fullWidth
      margin="normal"
      type={showPassword ? 'text' : type}
      value={value}
      {...rest}
      helperText={helper}
      InputProps={{
        startAdornment: unit && <InputAdornment position="start">{unit}</InputAdornment>,
        endAdornment: type === 'password' && (
          <InputAdornment position="end">
            <IconButton
              aria-label="toggle password visibility"
              onClick={toggleShowPassword}
              onMouseDown={cancelEvent}
              edge="end"
            >
              {showPassword ? <VisibilityOffIcon /> : <VisibilityIcon />}
            </IconButton>
          </InputAdornment>
        )
      }}
      {...(error && { error: true, helperText: error })}
    />
  )
}

OutlinedInput.propTypes = {
  name: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
  value: PropTypes.any.isRequired,
  onChange: PropTypes.func.isRequired,
  helper: PropTypes.string,
  error: PropTypes.string,
}