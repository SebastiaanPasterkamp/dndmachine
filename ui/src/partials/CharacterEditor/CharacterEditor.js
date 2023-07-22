import BackspaceIcon from '@mui/icons-material/Backspace';
import CancelIcon from '@mui/icons-material/Cancel';
import EditIcon from '@mui/icons-material/Edit';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import Button from '@mui/material/Button';
import Grid from '@mui/material/Grid';
import * as React from 'react';

import OutlinedForm from '../OutlinedForm';
import { PolicyButton } from '../ProtectedLink';
import Description from './options/Description';

export default function CharacterEditor({ values, setValues, isValid, onClose, onDone, resetForm }) {

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

  const getChoiceHandler = (uuid) => React.useMemo(
    () => async (e) => {
      if (e.preventDefault) e.preventDefault();
      const { name, value } = e.target;

      setValues((values) => {
        const { choices } = values;
        const { [uuid]: orig } = choices;
        return {
          ...values,
          choices: {
            ...choices,
            [uuid]: { ...orig, [name]: value },
          },
        }
      });
    },
    [uuid, setValues]
  );

  const queue = [
    "c4826704-86dc-4daf-985b-d4514ece5bc5",
    "867fde51-ed0d-4ec6-bed4-a6e561f08ff4",
  ];
  const uuid = queue[0];

  return (
    <OutlinedForm onSubmit={values.id ? handleUpdate : handleCreate}>
      <Description
        uuid={uuid}
        onChange={getChoiceHandler(uuid)}
        choice={values.choices[uuid] || {}}
      />

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
    </OutlinedForm >
  )
}


