import * as React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import CssBaseline from '@mui/material/CssBaseline';
import useMediaQuery from '@mui/material/useMediaQuery';
import { createTheme, ThemeProvider, StyledEngineProvider } from '@mui/material/styles';

import Dashboard from '../Dashboard'
import Footer from '../../partials/Footer'
import Header from '../../partials/Header'
import Menu from '../../partials/Menu'
import ObjectView from '../../partials/ObjectView'
import SignIn from '../SignIn'
import UserCard from '../../partials/UserCard'

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

  const [menuOpen, setMenuOpen] = React.useState(false);
  const toggleMenu = (open) => (event) => {
    if (event.type === 'keydown' && (event.key === 'Tab' || event.key === 'Shift')) {
      return;
    }

    setMenuOpen(open);
  };

  const [user, setUser] = React.useState(null);

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    if (user) {
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
        <BrowserRouter>

          <header>
            <Header user={user} setUser={setUser} toggleMenu={toggleMenu} />
          </header>

          <nav>
            <Menu toggleMenu={toggleMenu} menuOpen={menuOpen} />
          </nav>

          {user ? (
            <main>
              <Routes>
                <Route
                  path="/user"
                  element={<Dashboard component={UserCard} type="user" />}
                />
                <Route
                  path="/user/:id"
                  element={<ObjectView component={UserCard} type="user" />}
                />
              </Routes>
            </main>
          ) : (
            <main>
              <SignIn setUser={setUser} />
            </main>
          )}

          <footer>
            <Footer />
          </footer>

        </BrowserRouter>
      </ThemeProvider>
    </StyledEngineProvider>
  );
}