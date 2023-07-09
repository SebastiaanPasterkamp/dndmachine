import Backdrop from '@mui/material/Backdrop';
import CircularProgress from '@mui/material/CircularProgress';
import React, { lazy, Suspense } from 'react';
import { Route, Routes } from 'react-router-dom';

import DnDMachineContext from '../../context/DnDMachineContext';
import ObjectsContext, { Objects, useObjectsContext } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';

const CharacterView = lazy(() => import('./CharacterView'));
const CharacterEdit = lazy(() => import('./CharacterEdit'));
const CharacterCreate = lazy(() => import('./CharacterCreate'));
const CharactersDashboard = lazy(() => import('./CharactersDashboard'));

export default function CharacterRoutes() {
  return (
    <Suspense fallback={<Backdrop open={true}> <CircularProgress color="inherit" /> </Backdrop>}>
      <ObjectsContext types={['user', 'character', 'character-option']}>
        <PolicyContext useContext={useObjectsContext} query={`authz/character/allow`}>
          <Objects.Consumer>
            {({ "character-option": options }) => {
              if (!options) return null;

              const provider = (uuid) => new Promise((resolve, reject) => {
                var option = Object.values(options).find(option => option.uuid === uuid);

                if (option === undefined) {
                  reject(`${uuid} not available`);
                  return;
                }

                resolve(JSON.stringify(option));
              });

              return (
                <DnDMachineContext provider={provider}>

                  <Routes>
                    <Route
                      path="/"
                      element={<CharactersDashboard />}
                    />
                    <Route
                      path="/new"
                      element={<CharacterCreate />}
                    />
                    <Route
                      path="/:id"
                      element={<CharacterView />}
                    />
                    <Route
                      path="/:id/edit"
                      element={<CharacterEdit />}
                    />

                  </Routes>
                </DnDMachineContext>
              );
            }}
          </Objects.Consumer>
        </PolicyContext>
      </ObjectsContext>
    </Suspense>
  );
}