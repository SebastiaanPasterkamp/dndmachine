import opa from "@open-policy-agent/opa-wasm";
import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import { rest } from 'msw';
import { setupServer } from 'msw/node';
import path from 'path';
import { MemoryRouter, Route, Routes } from 'react-router-dom';

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockObjectsContext, useObjectsContext } from "../../context/ObjectsContext";
import PolicyContext from "../../context/PolicyContext";
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import UsersDashboard from './UsersDashboard';

const server = setupServer(
  rest.get('/api/user', (_, res, ctx) => {
    return res(ctx.json({
      results: [
        { id: 1, role: ["admin"], name: "admin" },
        { id: 2, role: ["player"], name: "player" },
      ]
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders UsersDashboard', async () => {
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
        <MockObjectsContext
          types={['user']}
          user={{
            1: { id: 1, role: ["admin"], name: "admin" },
            2: { id: 2, role: ["player"], name: "player" },
          }}
        >
          <PolicyContext useContext={useObjectsContext} query={`authz/user/allow`}>
            <MemoryRouter initialEntries={['/user']} >
              <Routes>
                <Route
                  path='/user'
                  element={<UsersDashboard />}
                />
              </Routes>
            </MemoryRouter>
          </PolicyContext>
        </MockObjectsContext>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const nameElements = await waitFor(() => screen.getAllByText('admin'))
  expect(nameElements[0]).toBeInTheDocument();
});
