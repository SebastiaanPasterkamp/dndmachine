import * as React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import CssBaseline from '@mui/material/CssBaseline';
import useMediaQuery from '@mui/material/useMediaQuery';
import { createTheme, ThemeProvider, StyledEngineProvider } from '@mui/material/styles';

import { UsersDashboard, UserView } from '../Users';
import Footer from '../../partials/Footer';
import Header from '../../partials/Header';
import Menu from '../../partials/Menu';
import SignIn from '../SignIn';
import { useCurrentUserContext } from '../../context/CurrentUserContext';

export default function App() {
  const { user } = useCurrentUserContext();

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

  return (
    <StyledEngineProvider injectFirst>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <BrowserRouter>

          <header>
            <Header toggleMenu={toggleMenu} />
          </header>

          <nav>
            <Menu toggleMenu={toggleMenu} menuOpen={menuOpen} />
          </nav>

          {user ? (
            <main>
              <Routes>
                <Route
                  path="/user"
                  element={<UsersDashboard />}
                />
                <Route
                  path="/user/:id"
                  element={<UserView />}
                />
              </Routes>
            </main>
          ) : (
            <main>
              <SignIn />
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