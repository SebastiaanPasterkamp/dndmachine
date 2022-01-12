import * as React from 'react';
import Container from '@mui/material/Container';
import Grid from '@mui/material/Grid';

async function getObjects(type) {
  return fetch(`/api/${type}`, {
    method: 'GET',
    credentials: 'same-origin',
  })
    .then(response => {
      if (!response.ok) {
        return null;
      }
      return response.json()
    })
    .catch((error) => {
      console.error('Error:', error);
    });
}

export default function Dashboard({
  component: Component,
  type,
}) {
  const [error, setError] = React.useState(false);
  const [objects, setObjects] = React.useState([]);

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    if (objects.length > 0 || error) {
      return;
    }

    getObjects(type)
      .then(data => {
        if (data == null || data.error) {
          setError(true)
        } else {
          setObjects(data.result)
        }
      })

    return () => mounted.current = false;
  }, [type, error, objects])

  return (
    <Container sx={{ py: 8 }} maxWidth="md">
      <Grid container spacing={4}>
        {objects.map((object) => (
          <Grid item key={object.id} xs={12} sm={6} md={4}>
            <Component {...object} />
          </Grid>
        ))}
      </Grid>
    </Container>
  );
}