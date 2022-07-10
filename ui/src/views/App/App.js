import React, { lazy, Suspense } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import CssBaseline from '@mui/material/CssBaseline';
import useMediaQuery from '@mui/material/useMediaQuery';
import Backdrop from '@mui/material/Backdrop';
import CircularProgress from '@mui/material/CircularProgress';
import { createTheme, ThemeProvider, StyledEngineProvider } from '@mui/material/styles';

import Footer from '../../partials/Footer';
import Header from '../../partials/Header';
import Menu from '../../partials/Menu';
import { useCurrentUserContext } from '../../context/CurrentUserContext';

const EquipmentTable = lazy(() => import('../Equipment/EquipmentTable'));
const RaceCreate = lazy(() => import('../Race/RaceCreate'));
const RaceDashboard = lazy(() => import('../Race/RaceDashboard'));
const RaceEdit = lazy(() => import('../Race/RaceEdit'));
const SignIn = lazy(() => import('../SignIn'));
const UserCreate = lazy(() => import('../Users/UserCreate'));
const UserEdit = lazy(() => import('../Users/UserEdit'));
const UsersDashboard = lazy(() => import('../Users/UsersDashboard'));
const UserView = lazy(() => import('../Users/UserView'));

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

                  {/* Equipment */}
                  <Route
                    path="/equipment"
                    element={<EquipmentTable />}
                  />

                  {/* Race */}
                  <Route
                    path="/race"
                    element={<RaceDashboard />}
                  />
                  <Route
                    path="/race/new"
                    element={<RaceCreate />}
                  />
                  <Route
                    path="/race/:id/edit"
                    element={<RaceEdit />}
                  />

                  {/* Users */}
                  <Route
                    path="/user"
                    element={<UsersDashboard />}
                  />
                  <Route
                    path="/user/new"
                    element={<UserCreate />}
                  />
                  <Route
                    path="/user/:id"
                    element={<UserView />}
                  />
                  <Route
                    path="/user/:id/edit"
                    element={<UserEdit />}
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