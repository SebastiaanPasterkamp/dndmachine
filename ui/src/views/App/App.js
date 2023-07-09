import Backdrop from '@mui/material/Backdrop';
import CircularProgress from '@mui/material/CircularProgress';
import CssBaseline from '@mui/material/CssBaseline';
import { createTheme, StyledEngineProvider, ThemeProvider } from '@mui/material/styles';
import useMediaQuery from '@mui/material/useMediaQuery';
import React, { lazy, Suspense } from 'react';
import { BrowserRouter, Route, Routes } from 'react-router-dom';

import { useCurrentUserContext } from '../../context/CurrentUserContext';

import Footer from '../../partials/Footer';
import Header from '../../partials/Header';
import Menu from '../../partials/Menu';

const CharacterRoutes = lazy(() => import('../Characters/CharacterRoutes'));
const EquipmentTable = lazy(() => import('../Equipment/EquipmentTable'));
const SignIn = lazy(() => import('../SignIn'));
const UserRoutes = lazy(() => import('../Users/UserRoutes'));

export default function App() {
  const { user } = useCurrentUserContext();

  const prefersDarkMode = useMediaQuery('(prefers-color-scheme: dark)');

  const theme = React.useMemo(
    () =>
      createTheme({
        palette: {
          mode: (user && /^(light|dark)$/.test(user.theme)) ? user.theme : (prefersDarkMode ? 'dark' : 'light'),
        },
      }),
    [user, prefersDarkMode],
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

          <main>
            {user ? (
              <Suspense fallback={<Backdrop open={true}> <CircularProgress color="inherit" /> </Backdrop>}>
                <Routes>
                  {/* Characters */}
                  <Route
                    path="/character/*"
                    element={<CharacterRoutes />}
                  />

                  {/* Equipment */}
                  <Route
                    path="/equipment"
                    element={<EquipmentTable />}
                  />

                  {/* Users */}
                  <Route
                    path="/user/*"
                    element={<UserRoutes />}
                  />

                </Routes>
              </Suspense>
            ) : (
              <Suspense fallback={<Backdrop open={true}> <CircularProgress color="inherit" /> </Backdrop>}>
                <SignIn />
              </Suspense>
            )}
          </main>

          <footer>
            <Footer />
          </footer>

        </BrowserRouter>
      </ThemeProvider >
    </StyledEngineProvider >
  );
}