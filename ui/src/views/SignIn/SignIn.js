import * as React from 'react';

import Avatar from '@mui/material/Avatar';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Container from '@mui/material/Container';
import Grid from '@mui/material/Grid';
import Link from '@mui/material/Link';
import OutlinedForm, { OutlinedInput } from '../../partials/OutlinedForm';
import Typography from '@mui/material/Typography';

import Copyright from '../../partials/Copyright'
import { useCurrentUserContext } from '../../context/CurrentUserContext'

async function loginUser(credentials) {
  return fetch('/auth/login', {
    method: 'POST',
    credentials: 'same-origin',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(credentials)
  })
    .then(response => {
      if (!response.ok) {
        return null;
      }
      return response.json();
    })
    .catch((error) => {
      console.error('Error:', error);
    });
}

export default function SignIn() {
  const { setUser } = useCurrentUserContext();

  const [username, setUserName] = React.useState("");
  const [password, setPassword] = React.useState("");

  const handleSubmit = async (event) => {
    event.preventDefault();

    const user = await loginUser({
      username,
      password
    });

    setUser(user);
  }

  return (
    <Container component="main" maxWidth="xs">
      <Box
        sx={{
          marginTop: 8,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
        }}
      >
        <Avatar
          src="ui/logo512.png"
          sx={{ m: 1, bgcolor: 'primary.main' }}
        >
        </Avatar>
        <Typography component="h1" variant="h5">
          Sign in
        </Typography>
        <OutlinedForm onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
          <OutlinedInput
            label="Username or Email Address"
            name="username"
            required
            autoComplete="username"
            autoFocus
            value={username}
            onChange={e => setUserName(e.target.value)}
            data-testid="login.username"
          />
          <OutlinedInput
            label="Password"
            name="password"
            type="password"
            required
            autoComplete="current-password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            data-testid="login.password"
          />
          <Button
            type="submit"
            fullWidth
            variant="contained"
            sx={{ mt: 3, mb: 2 }}
            data-testid="login.submit"
          >
            Sign In
          </Button>
          <Grid container>
            <Grid item xs>
              <Link href="#" variant="body2">
                Forgot password?
              </Link>
            </Grid>
            <Grid item>
              <Link href="#" variant="body2">
                {"Don't have an account? Sign Up"}
              </Link>
            </Grid>
          </Grid>
        </OutlinedForm>
      </Box>
      <Copyright sx={{ mt: 8, mb: 4 }} />
    </Container>
  );
}
