import React, { useState } from 'react';
import PropTypes from 'prop-types';
import Avatar from '@mui/material/Avatar';
import IconButton from '@mui/material/IconButton';
import ModeEditIcon from '@mui/icons-material/ModeEdit';

import { stringToInitials, stringToColor } from '../../utils';

// Max avatar file size is 75Kb
const MAX_FILE_SIZE = 75 * 1024;

export default function OutlinedFileUpload({ helper, label, name, value, title, onChange, sx, ...rest }) {
  const [hover, setHover] = useState(false);

  const onImageChange = (event) => {
    if (!event.target.files) {
      return;
    }

    if (event.target.files.length !== 1) {
      return
    };

    const file = event.target.files[0];

    if (file.size > MAX_FILE_SIZE) {
      return;
    }

    var reader = new FileReader();
    reader.onload = () => {
      var base64 = reader.result.toString();
      if ((base64 % 4) > 0) {
        base64 += '='.repeat(4 - (base64 % 4));
      }

      onChange({
        target: {
          name: event.target.name,
          value: base64,
        },
      });
    };
    reader.readAsDataURL(file);
  };

  return (
    <IconButton
      color="primary"
      variant="contained"
      component="label"
      aria-label="upload picture"
      onMouseEnter={() => setHover(true)}
      onMouseLeave={() => setHover(false)}
    >
      <input
        type="file"
        name={name}
        accept="image/*"
        onChange={onImageChange}
        {...rest}
        hidden
      />

      <Avatar
        aria-label={label}
        variant="rounded"
        src={hover ? null : value}
        children={hover
          ? <ModeEditIcon />
          : (value ? null : stringToInitials(title))
        }
        sx={{
          ...sx,
          bgcolor: value ? null : stringToColor(title),
        }}
      />
    </IconButton >
  )

}

OutlinedFileUpload.propTypes = {
  name: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
  value: PropTypes.string.isRequired,
  title: PropTypes.string,
  onChange: PropTypes.func.isRequired,
  helper: PropTypes.string,
}