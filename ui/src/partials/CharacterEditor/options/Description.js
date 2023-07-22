import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';
import * as React from 'react';

import BadgedAvatar from '../../BadgedAvatar/BadgedAvatar';
import { OutlinedFileUpload, OutlinedInput } from '../../OutlinedForm';

const defaultDescription = {
  name: "",
  avatar: "",
}

export default function Description({ onChange, choice }) {
  const values = { ...defaultDescription, ...choice };

  return (
    <>
      <div style={{ display: "flex", justifyContent: "center" }}>
        <BadgedAvatar
          name={values.name}
          avatar={values.avatar}
          aria-label="name"
          variant="rounded"
        />
      </div>

      <Grid container>
        <Grid item xs={12} sm={6} sx={{ px: 1 }}>
          <Box sx={{ display: 'flex', alignItems: 'flex-start' }}>
            <OutlinedFileUpload
              sx={{ width: 72, height: 72 }}
              label="Avatar"
              name="avatar"
              title={values.name}
              aria-label="Avatar"
              value={values.avatar}
              onChange={onChange}
            />

            <OutlinedInput
              label="Name"
              name="name"
              required
              value={values.name}
              onChange={onChange}
            />
          </Box>
        </Grid>
      </Grid>
    </>
  )
}


