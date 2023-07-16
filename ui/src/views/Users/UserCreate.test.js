import opa from "@open-policy-agent/opa-wasm";
import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import path from 'path';
import { MemoryRouter, Route, Routes } from 'react-router-dom';

import { MockUserContext } from '../../context/CurrentUserContext';
import PolicyContext from "../../context/PolicyContext";
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import UserCreate from './UserCreate';

test('renders UserCreate', async () => {
  const wasmPath = path.resolve(__dirname, '../../testdata/policy.wasm');
  const wasm = fs.readFileSync(wasmPath);
  const policy = await opa.loadPolicy(wasm);

  await act(async () => render(
    <MockPolicyEngineContext policy={policy}>
      <MockUserContext user={{
        id: 1,
        role: ["admin"],
        name: "admin",
      }}>
        <PolicyContext query={`authz/user/allow`}>
          <MemoryRouter initialEntries={['/user/new']} >
            <Routes>
              <Route
                path='/user/new'
                element={<UserCreate />}
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
