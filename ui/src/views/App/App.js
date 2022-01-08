import * as React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import CssBaseline from '@mui/material/CssBaseline';
import useMediaQuery from '@mui/material/useMediaQuery';
import { createTheme, ThemeProvider, StyledEngineProvider } from '@mui/material/styles';

import Dashboard from '../Dashboard'
import Footer from '../../partials/Footer'
import Header from '../../partials/Header'
import SignIn from '../SignIn'

async function currentUser() {
  return fetch('/auth/current-user', {
    method: 'GET',
    credentials: 'same-origin',
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

export default function App() {

  const prefersDarkMode = useMediaQuery('(prefers-color-scheme: dark)');

  const theme = React.useMemo(
    () =>
      createTheme({
        palette: {
          mode: prefersDarkMode ? 'dark' : 'light',
        },
      }),
    [prefersDarkMode],
  );

  const [user, setUser] = React.useState(null);

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    if(user) {
      return;
    }

    currentUser()
      .then(user => setUser(user))

    return () => mounted.current = false;
  }, [user])

  return (
    <StyledEngineProvider injectFirst>
      <ThemeProvider theme={theme}>
        <CssBaseline />

        <header>
         <Header user={user} setUser={setUser} />
        </header>

        <main>
          {user ? (
            <BrowserRouter>
              <Routes>
                <Route path="/" element={<Dashboard />} />
              </Routes>
            </BrowserRouter>
          ) : (
            <SignIn setUser={setUser} />
          )}
        </main>

        <footer>
          <Footer />
        </footer>
      </ThemeProvider>
    </StyledEngineProvider>
  );
}