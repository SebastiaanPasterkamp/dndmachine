import * as React from 'react';
import PropTypes from 'prop-types';
import Avatar from '@mui/material/Avatar';
import BackspaceIcon from '@mui/icons-material/Backspace'
import Button from '@mui/material/Button';
import CancelIcon from '@mui/icons-material/Cancel'
import CharacteristicOption from '../CharacteristicOption';
import EditIcon from '@mui/icons-material/Edit';
import Grid from '@mui/material/Grid';
import { Objects } from '../../context/ObjectsContext';
import OutlinedForm, { OutlinedInput, OutlinedSelect } from '../OutlinedForm';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import useFormHelper from '../../utils/formHelper';

import { requiredString } from '../../utils/validators';
import { stringToInitials, stringToColor } from '../../utils';

const defaultRace = {
  name: "",
  sub: null,
  description: "",
}

export default function RaceForm({ race, onClose, onDone }) {

  const validate = async (values) => {
    var errors = {};
    if ('name' in values) {
      errors.name = requiredString(values.name);
    }
    if ('description' in values) {
      errors.description = requiredString(values.description);
    }
    return errors;
  }

  const {
    values,
    errors,
    handleInputChange,
    isValid,
    resetForm,
  } = useFormHelper({ ...defaultRace, ...race }, validate, false)

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

    const updatedRace = await fetch(`/api/race/${values.id}`, {
      method: 'PATCH',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(values),
    })
      .then(response => (response.ok ? response.json() : null))
      .then(response => response.result)
      .catch((error) => console.error('Error:', error));

    if (updatedRace) {
      resetForm();
      if (onDone) onDone(updatedRace);
    }
  }

  const handleCreate = async (e) => {
    e.preventDefault();
    const valid = await isValid();
    if (!valid) {
      return;
    }

    const newRace = await fetch(`/api/race`, {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      redirect: 'manual',
      body: JSON.stringify(values),
    })
      .then(response => (response.ok ? response.json() : null))
      .then(response => response.result)
      .catch((error) => console.error('Error:', error));

    if (newRace) {
      resetForm();
      if (onDone) onDone(newRace);
    }
  }

  return (
    <OutlinedForm onSubmit={values.id ? handleUpdate : handleCreate}>
      <div style={{ display: "flex", justifyContent: "center" }}>
        <Avatar
          sx={{
            bgcolor: stringToColor(values.name),
            width: 56, height: 56,
          }}
          children={stringToInitials(values.name)}
          aria-label="name"
          variant="rounded"
        />
      </div>

      <Grid container>
        <Grid item xs={12}>
          <OutlinedInput
            label="Name"
            name="name"
            required
            value={values.name}
            error={errors.name}
            onChange={handleInputChange}
            helper="Must be unique"
          />

          <Objects.Consumer>
            {({ race: races }) => {
              if (!races) {
                return null;
              }

              races = Object.values(races)
                .filter(r => !r.sub)
                .filter(r => r.id !== race.id);

              if (!races.length) {
                return null;
              }

              return (
                <OutlinedSelect
                  label="Main race"
                  name="sub"
                  allowEmpty={true}
                  options={races}
                  value={values.sub || ""}
                  error={errors.sub}
                  onChange={handleInputChange}
                  helper="Subrace of ..."
                />
              )
            }}
          </Objects.Consumer>

          <OutlinedInput
            label="Description"
            name="description"
            multiline
            maxRows={10}
            value={values.description}
            error={errors.description}
            onChange={handleInputChange}
            helper="Describe the race"
          />
        </Grid>

        <Grid item xs={4}>
          <CharacteristicOption
            onChange={handleInputChange}
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

RaceForm.propTypes = {
  race: PropTypes.object,
  onClose: PropTypes.func,
  onDone: PropTypes.func,
};
