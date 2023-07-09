import Container from '@mui/material/Container';
import Grid from '@mui/material/Grid';
import * as React from 'react';
import { useObjectsContext } from '../../context/ObjectsContext';

export default function Dashboard({
  component: Component,
  type,
  placeholders = 3,
}) {
  const {
    [type]: objects = [],
    loading = { [type]: true },
  } = useObjectsContext();

  const skeleton = [...Array(placeholders)];

  return (
    <Container sx={{ py: 8 }}>
      <Grid container spacing={4}>
        {loading[type] ? skeleton.map((_, i) => (
          <Grid item key={i} xs={12} sm={6} md={4}>
            <Component loading />
          </Grid>
        )) : Object.entries(objects).map(([id, object], i) => (
          <Grid item key={id} xs={12} sm={6} md={4}>
            <Component {...object} />
          </Grid>
        ))}
      </Grid>
    </Container>
  );
}