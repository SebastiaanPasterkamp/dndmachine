import opa from "@open-policy-agent/opa-wasm";
import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import path from 'path';
import { MemoryRouter, Route, Routes } from 'react-router-dom';

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockDnDMachineContext } from '../../context/DnDMachineContext';
import { MockObjectsContext, useObjectsContext } from "../../context/ObjectsContext";
import PolicyContext from "../../context/PolicyContext";
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import CharactersDashboard from './CharactersDashboard';

test('renders CharactersDashboard', async () => {
  const wasmPath = path.resolve(__dirname, '../../testdata/policy.wasm');
  const wasm = fs.readFileSync(wasmPath);
  const policy = await opa.loadPolicy(wasm);

  await act(async () => render(
    <MockPolicyEngineContext policy={policy}>
      <MockUserContext user={{
        id: 2,
        role: ["player"],
        name: "player",
      }}>
        <MockObjectsContext
          types={['user', 'character']}
          character={{
            1: { id: 1, user_id: 2, name: "Foo" },
            2: { id: 2, user_id: 2, name: "Testy McTestFace" },
          }}
          user={{
            1: { id: 1, username: "admin", role: ["admin"] },
            2: { id: 2, username: "player", role: ["player"] },
          }}
        >
          <PolicyContext useContext={useObjectsContext} query={`authz/character/allow`}>
            <MockDnDMachineContext characterCompute={async (character) => new Promise((resolve) => resolve(character))}>
              <MemoryRouter initialEntries={['/character']} >
                <Routes>
                  <Route
                    path='/character'
                    element={<CharactersDashboard />}
                  />
                </Routes>
              </MemoryRouter>
            </MockDnDMachineContext>
          </PolicyContext>
        </MockObjectsContext>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const nameElements = await waitFor(() => screen.getAllByText(/Testy McTestFace/))
  expect(nameElements[0]).toBeInTheDocument();
});
