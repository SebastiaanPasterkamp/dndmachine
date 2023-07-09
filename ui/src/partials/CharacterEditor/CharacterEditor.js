import BackspaceIcon from '@mui/icons-material/Backspace';
import CancelIcon from '@mui/icons-material/Cancel';
import EditIcon from '@mui/icons-material/Edit';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import Button from '@mui/material/Button';
import Grid from '@mui/material/Grid';
import * as React from 'react';

import { useCurrentUserContext } from '../../context/CurrentUserContext';
import useFormHelper from '../../utils/formHelper';
import { requiredString } from '../../utils/validators';
import OutlinedForm, { OutlinedFileUpload, OutlinedInput } from '../OutlinedForm';
import { PolicyButton } from '../ProtectedLink';

const defaultCharacter = {
  name: "",
  avatar: "",
  level: 1,
}

export default function CharacterEditor({ character, onClose, onDone }) {
  const { user } = useCurrentUserContext();

  const validate = async (values) => {
    var errors = {};
    if ('name' in values) {
      errors.name = requiredString(values.name);
    }
    return errors;
  }

  const {
    values,
    errors,
    handleInputChange,
    isValid,
    resetForm,
  } = useFormHelper({ user_id: user.id, ...defaultCharacter, ...character }, validate, false)

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

    const result = await fetch(`/api/character/${values.id}`, {
      method: 'PATCH',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(values),
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`${response.status}: ${response.statusText}`);
        }
        return response.json();
      })
      .then(data => data.result)
      .catch((error) => console.error('Error:', error));

    if (result) {
      resetForm();
      if (onDone) onDone(result);
    }
  }

  const handleCreate = async (e) => {
    e.preventDefault();
    const valid = await isValid();
    if (!valid) {
      return;
    }

    const result = await fetch(`/api/character`, {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(values),
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`${response.status}: ${response.statusText}`);
        }
        return response.json();
      })
      .then(data => data.result)
      .catch((error) => console.error('Error:', error));

    if (result) {
      resetForm();
      if (onDone) onDone(result);
    }
  }

  return (
    <OutlinedForm onSubmit={values.id ? handleUpdate : handleCreate}>
      <div style={{ display: "flex", justifyContent: "center" }}>
        <OutlinedFileUpload
          sx={{ width: 56, height: 56 }}
          label="Avatar"
          name="avatar"
          title={values.name}
          aria-label="Avatar"
          value={values.avatar}
          error={errors.avatar}
          onChange={handleInputChange}
        />
      </div>

      <Grid container>
        <Grid item xs={12} sm={6} sx={{ px: 1 }}>
          <OutlinedFileUpload
            sx={{ width: 56, height: 56 }}
            label="Avatar"
            name="avatar"
            title={values.name}
            aria-label="Avatar"
            value={values.avatar}
            error={errors.avatar}
            onChange={handleInputChange}
          />

          <OutlinedInput
            label="Name"
            name="name"
            required
            value={values.name}
            error={errors.name}
            onChange={handleInputChange}
            helper="Must be unique."
          />
        </Grid>

        <Grid item xs={12} style={{ display: "flex", justifyContent: "space-evenly", alignItems: "center" }}>
          {values.id ? (
            <PolicyButton
              path={`/api/character/${values.id}`}
              method="PATCH"
              query="authz/character/allow"

              variant="contained"
              type="submit"
              color="primary"
              onClick={handleUpdate}
              startIcon={<EditIcon />}
            >
              Update
            </PolicyButton>
          ) : (
            <PolicyButton
              path={`/api/character`}
              method="POST"
              query="authz/character/allow"

              variant="contained"
              type="submit"
              color="primary"
              onClick={handleCreate}
              startIcon={<PersonAddIcon />}
            >
              Create
            </PolicyButton>
          )}
          <Button
            variant="contained"
            type="cancel"
            color="secondary"
            onClick={handleCancel}
            startIcon={<CancelIcon />}
          >
            Cancel
          </Button>
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


