import { act, render, screen, waitFor } from '@testing-library/react';
import { Route, Routes, MemoryRouter } from 'react-router-dom';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import fs from 'fs';
import path from 'path';
import opa from "@open-policy-agent/opa-wasm";

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import UserCreate from './UserCreate';

const server = setupServer(
  rest.get('/api/user', (_, res, ctx) => res(ctx.json({
    results: [
      { id: 1, role: ["admin"], name: "admin" },
      { id: 2, role: ["player"], name: "player" },
    ]
  }))),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

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
        <MemoryRouter initialEntries={['/user/new']} >
          <Routes>
            <Route
              path='/user/new'
              element={<UserCreate />}
            />
          </Routes>
        </MemoryRouter>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const createButton = await waitFor(() => screen.getByText('Create'))
  expect(createButton).toBeInTheDocument();
});
