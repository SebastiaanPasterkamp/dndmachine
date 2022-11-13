import * as React from 'react';
import PropTypes from 'prop-types';
import BackspaceIcon from '@mui/icons-material/Backspace'
import { Characteristic } from '../CharacterCreate';
import CancelIcon from '@mui/icons-material/Cancel';
import { Phases } from '../CharacteristicOption';
import CharacterContext from '../../context/CharacterContext';
import CharacteristicsContext from '../../context/CharacteristicsContext';
import EditIcon from '@mui/icons-material/Edit';
import Grid from '@mui/material/Grid';
import { Objects } from '../../context/ObjectsContext';
import OutlinedForm, { OutlinedFileUpload, OutlinedInput, OutlinedSelect } from '../OutlinedForm';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import { PolicyButton } from '../ProtectedLink';
import useFormHelper from '../../utils/formHelper';
import { requiredString } from '../../utils/validators';

const defaultRace = {
  name: "",
  sub: null,
  avatar: "",
  description: "",
  phases: [],
}

export default function RaceForm({ race, onClose, onDone }) {
  const [phase, setPhase] = React.useState((race?.phases || [])[0]);

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
    handleChangeCallback,
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
      .then(response => {
        if (response.ok) {
          return response.json();
        }
        return Promise.reject(response);
      })
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

  const changePhases = (change) => handleChangeCallback('phases', change);

  return (
    <OutlinedForm onSubmit={values.id ? handleUpdate : handleCreate}>
      <CharacteristicsContext>
        <Grid container>
          <Grid item xs={12} md={6}>

            <Grid item xs={12}>
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
                helper="Must be unique"
              />
            </Grid>

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
                  <Grid item xs={12} >
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
                  </Grid>
                )
              }}
            </Objects.Consumer>

            <Grid item xs={12}>
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

            <Grid item xs={12}>
              <Phases
                phases={values.phases || []}
                onChange={changePhases}
                onSwitch={setPhase}
              />
            </Grid>
          </Grid>

          <Grid item xs={12} md={6}>
            {phase ? (
              <CharacterContext>
                <Characteristic
                  {...values}
                />
              </CharacterContext>
            ) : null}
          </Grid>

          <Grid item xs={12} style={{ display: "flex", justifyContent: "space-evenly", alignItems: "center" }}>
            {values.id ? (
              <PolicyButton
                path={`/api/race/${race.id}`}
                method="PATCH"
                query="authz/race/allow"

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
                path={`/api/race`}
                method="POST"
                query="authz/race/allow"

                variant="contained"
                type="submit"
                color="primary"
                onClick={handleCreate}
                startIcon={<PersonAddIcon />}
              >
                Create
              </PolicyButton>
            )}
            {onClose && (
              <PolicyButton
                path={`/race`}
                method="GET"
                query="authz/pages/allow"

                variant="contained"
                type="cancel"
                color="secondary"
                onClick={handleCancel}
                startIcon={<CancelIcon />}
              >
                Cancel
              </PolicyButton>
            )}
            <PolicyButton
              path={`/api/race/${race.id}`}
              method="GET"
              query="authz/race/allow"

              variant="contained"
              type="reset"
              color="warning"
              onClick={resetForm}
              startIcon={<BackspaceIcon />}
            >
              Reset
            </PolicyButton>
          </Grid>
        </Grid>
      </CharacteristicsContext>
    </OutlinedForm >
  )
}

RaceForm.defaultProps = {
  race: {},
}

RaceForm.propTypes = {
  race: PropTypes.object,
  onClose: PropTypes.func,
  onDone: PropTypes.func,
};
