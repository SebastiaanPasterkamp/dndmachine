import React from 'react';
import PropTypes from 'prop-types';
import Box from '@mui/material/Box';
import CheckIcon from '@mui/icons-material/Check';
import CircularProgress from '@mui/material/CircularProgress';
import EditIcon from '@mui/icons-material/Edit';
import IconButton from '@mui/material/IconButton';
import Markdown from '../Markdown';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { OutlinedInput } from '../OutlinedForm';
import { useCharacteristicsContext } from '../../context/CharacteristicsContext';

import types from './types';

export default function CharacteristicOption({ uuid }) {
  const {
    focus, setFocus, getCharacteristic, updateCharacteristic,
  } = useCharacteristicsContext();

  const {
    loading,
    characteristic: { name = "", description = "", type, config },
  } = getCharacteristic(uuid);

  const { name: label, component: Component } = types[type] || {};
  if (!Component) {
    return null;
  }

  const onChange = async (e) => {
    const { name, value } = e.target;

    updateCharacteristic(uuid, name, () => value);
  }

  const onComponentChange = async (change) => {
    updateCharacteristic(uuid, 'config', change);
  }

  const editing = uuid === focus;
  const props = (!!config && config.constructor === Object) ? config : { config };

  return (
    <span>
      <Toolbar>
        <Typography
          variant="h6"
          noWrap
          component="div"
        >
          {label}: {name}
        </Typography>
        <Box sx={{ flexGrow: 1 }} />
        <Box sx={{ display: { xs: 'none', md: 'flex' } }}>
          {loading ? (
            <CircularProgress />
          ) : null}
          {!editing ? (
            <IconButton
              variant="outlined"
              aria-label="edit"
              onClick={() => setFocus(uuid)}
            >
              <EditIcon />
            </IconButton>
          ) : (
            <IconButton
              variant="outlined"
              aria-label="done"
              onClick={() => setFocus(undefined)}
            >
              <CheckIcon />
            </IconButton>
          )}
        </Box>
      </Toolbar>

      {editing ? (
        <OutlinedInput
          label="Name"
          name="name"
          required
          value={name}
          onChange={onChange}
        />
      ) : null}

      {editing ? (
        <OutlinedInput
          label="Description"
          name="description"
          multiline
          maxRows={10}
          value={description}
          onChange={onChange}
        />
      ) : (
        <Markdown description={description} />
      )}

      <Component
        {...props}
        editing={editing}
        onChange={onComponentChange}
      />
    </span>
  );
}

CharacteristicOption.propTypes = {
  uuid: PropTypes.string.isRequired,
};
