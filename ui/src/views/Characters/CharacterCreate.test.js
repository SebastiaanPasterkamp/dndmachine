import opa from "@open-policy-agent/opa-wasm";
import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import path from 'path';
import { MemoryRouter, Route, Routes } from 'react-router-dom';

import { MockUserContext } from '../../context/CurrentUserContext';
import PolicyContext from "../../context/PolicyContext";
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import CharacterCreate from './CharacterCreate';

test('renders CharacterCreate', async () => {
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
        <PolicyContext query={`authz/character/allow`}>
          <MemoryRouter initialEntries={['/character/new']} >
            <Routes>
              <Route
                path='/character/new'
                element={<CharacterCreate />}
              />
            </Routes>
          </MemoryRouter>
        </PolicyContext>
      </MockUserContext>
    </MockPolicyEngineContext >
  ));

  await waitFor(() => screen.getByText('Create'))

  const createButton = screen.getByText('Create');
  expect(createButton).toBeInTheDocument();
});
