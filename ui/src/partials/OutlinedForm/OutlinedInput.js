import React from 'react'
import PropTypes from 'prop-types';
import InputAdornment from '@mui/material/InputAdornment';
import TextField from '@mui/material/TextField';
import IconButton from '@mui/material/IconButton';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';

export default function OutlinedInput({ helper, name, value, onChange, type, unit, error, ...rest }) {
  const [text, setText] = React.useState(value);
  const [showPassword, setShowPassword] = React.useState(false);

  const toggleShowPassword = () => {
    setShowPassword(!showPassword);
  }

  const cancelEvent = (event) => {
    event.preventDefault();
  };

  const onTextChange = (e) => {
    setText(e.target.value);

    if (type === "number") {
      const number = parseInt(e.target.value, 10);
      if (isNaN(number)) return;
      e.target = { name: e.target.name, value: number };
    }

    onChange(e);
  }

  return (
    <TextField
      variant="outlined"
      fullWidth
      margin="normal"
      type={showPassword ? 'text' : type}
      data-testid={`input-${type}-${name}`}
      name={name}
      value={text}
      onChange={onTextChange}
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

OutlinedInput.defaultProps = {
  type: "text",
  unit: null,
  error: null,
};

OutlinedInput.propTypes = {
  name: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
  value: PropTypes.any.isRequired,
  onChange: PropTypes.func.isRequired,
  helper: PropTypes.string,
  error: PropTypes.string,
}