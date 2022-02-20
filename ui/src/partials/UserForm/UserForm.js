import * as React from 'react';
import PropTypes from 'prop-types';
import Avatar from '@mui/material/Avatar';
import BackspaceIcon from '@mui/icons-material/Backspace'
import Button from '@mui/material/Button';
import CancelIcon from '@mui/icons-material/Cancel'
import EditIcon from '@mui/icons-material/Edit';
import Grid from '@mui/material/Grid';
import OutlinedForm, { OutlinedInput, OutlinedSelect } from '../OutlinedForm';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import useFormHelper from '../../utils/formHelper';

import { maxLength, minLength, numeric, requiredString, validEmail } from '../../utils/validators';
import { stringToInitials, stringToColor } from '../../utils';

const roles = [
  { id: 'player', title: 'Player' },
  { id: 'dm', title: 'Dungeon Master' },
  { id: 'admin', title: 'Administrator' },
];

const themes = [
  { id: 'auto', title: 'Follow system' },
  { id: 'light', title: 'Light theme' },
  { id: 'dark', title: 'Dark theme' },
];

const defaultUser = {
  username: "",
  name: "",
  email: "",
  password: "",
  dci: "",
  role: [],
  theme: "auto",
}

export default function UserForm({ user, onClose, onDone }) {

  const validate = async (values) => {
    var errors = {};
    if ('username' in values) {
      errors.username = requiredString(values.username);
    }
    if ('email' in values) {
      errors.email = requiredString(values.email) || validEmail(values.email);
    }
    if (user && user.id) {
      if ('password' in values) {
        errors.password = minLength(values.password, 12);
      }
    } else {
      if ('password' in values) {
        errors.password = requiredString(values.password) || minLength(values.password, 12);
      }
    }
    if ('dci' in values) {
      errors.dci = numeric(values.dci) || minLength(values.dci, 5) || maxLength(values.dci, 10);
    }
    if ('role' in values) {
      errors.role = !(values.role && values.role.length) ? "This field is required." : undefined;
    }
    return errors;
  }

  const {
    values,
    errors,
    handleInputChange,
    isValid,
    resetForm,
  } = useFormHelper({ ...defaultUser, ...user }, validate, false)

  const handleCancel = async (e) => {
    e.preventDefault();

    resetForm();
    onClose();
  }

  const handleUpdate = async (e) => {
    e.preventDefault();
    const valid = await isValid();
    if (!valid) {
      return;
    }

    const success = await fetch(`/api/user/${values.id}`, {
      method: 'PATCH',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(values),
    })
      .then(response => response.ok)
      .catch((error) => console.error('Error:', error));

    if (success) {
      resetForm();
      if (onDone) onDone();
    }
  }

  const handleCreate = async (e) => {
    e.preventDefault();
    const valid = await isValid();
    if (!valid) {
      return;
    }

    const newUser = await fetch(`/api/user`, {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(values),
    })
      .then(response => (response.ok ? response.json() : null))
      .then(({ result }) => result)
      .catch((error) => console.error('Error:', error));

    if (newUser) {
      resetForm();
      if (onDone) onDone(newUser);
    }
  }

  const displayName = (values.name ? values.name : values.username) || '?';

  return (
    <OutlinedForm onSubmit={values.id ? handleUpdate : handleCreate}>
      <div style={{ display: "flex", justifyContent: "center" }}>
        <Avatar
          sx={{
            bgcolor: stringToColor(displayName),
            width: 56, height: 56,
          }}
          children={stringToInitials(displayName)}
          aria-label="name"
          variant="rounded"
        />
      </div>

      <Grid container>
        <Grid item xs={12} sm={6} sx={{ px: 1 }}>
          <OutlinedInput
            label="Username"
            name="username"
            required
            value={values.username}
            error={errors.username}
            onChange={handleInputChange}
            helper="Must be unique"
          />

          <OutlinedInput
            label="Password"
            name="password"
            type="password"
            required
            value={values.password}
            error={errors.password}
            onChange={handleInputChange}
            helper={values.id ? "Leaving this empty won't change the password." : "Stored encrypted."}
          />

          <OutlinedInput
            label="Email"
            name="email"
            required
            value={values.email}
            error={errors.email}
            onChange={handleInputChange}
            helper="Will not be shared. Only used to recover lost credentials."
          />
        </Grid>

        <Grid item xs={12} sm={6} sx={{ px: 1 }}>
          <OutlinedInput
            label="Fullname"
            name="name"
            value={values.name}
            error={errors.name}
            onChange={handleInputChange}
            helper="Defaults to the username if left blank."
          />

          <OutlinedSelect
            label="Theme"
            name="theme"
            options={themes}
            value={values.theme}
            error={errors.theme}
            defaultValue="auto"
            onChange={handleInputChange}
            helper="The theme may require signing in and out to take effect."
          />

          <OutlinedSelect
            label="Roles"
            name="role"
            options={roles}
            multiple
            value={values.role}
            error={errors.role}
            onChange={handleInputChange}
            helper="Can pick multiple."
          />
        </Grid>

        <Grid item xs={12} style={{ display: "flex", justifyContent: "space-evenly", alignItems: "center" }}>
          {values.id ? (
            <Button
              variant="contained"
              type="submit"
              color="primary"
              onClick={handleUpdate}
              startIcon={<EditIcon />}
            >
              Update
            </Button>
          ) : (
            <Button
              variant="contained"
              type="submit"
              color="primary"
              onClick={handleCreate}
              startIcon={<PersonAddIcon />}
            >
              Create
            </Button>
          )}
          {onClose && (
            <Button
              variant="contained"
              type="cancel"
              color="secondary"
              onClick={handleCancel}
              startIcon={<CancelIcon />}
            >
              Cancel
            </Button>
          )}
          <Button
            variant="contained"
            type="reset"
            color="warning"
            onClick={resetForm}
            startIcon={<BackspaceIcon />}
          >
            Reset
          </Button>
        </Grid>
      </Grid>
    </OutlinedForm >
  )
}

UserForm.propTypes = {
  user: PropTypes.object,
  onClose: PropTypes.func,
  onDone: PropTypes.func,
};
