import Backdrop from '@mui/material/Backdrop';
import CircularProgress from '@mui/material/CircularProgress';
import React, { lazy, Suspense } from 'react';
import { Route, Routes } from 'react-router-dom';

import ObjectsContext, { useObjectsContext } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';

const UserCreate = lazy(() => import('./UserCreate'));
const UserEdit = lazy(() => import('./UserEdit'));
const UsersDashboard = lazy(() => import('./UsersDashboard'));
const UserView = lazy(() => import('./UserView'));

export default function UserRoutes() {
  return (
    <Suspense fallback={<Backdrop open={true}> <CircularProgress color="inherit" /> </Backdrop>}>
      <ObjectsContext types={['user']}>
        <PolicyContext useContext={useObjectsContext} query={`authz/user/allow`}>

          <Routes>
            {/* Users */}
            <Route
              path="/"
              element={<UsersDashboard />}
            />
            <Route
              path="/new"
              element={<UserCreate />}
            />
            <Route
              path="/:id"
              element={<UserView />}
            />
            <Route
              path="/:id/edit"
              element={<UserEdit />}
            />

          </Routes>
        </PolicyContext>
      </ObjectsContext>
    </Suspense>
  );
}