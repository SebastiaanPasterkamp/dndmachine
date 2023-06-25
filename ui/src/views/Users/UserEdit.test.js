import { act, render, screen, waitFor } from '@testing-library/react';
import { Route, Routes, MemoryRouter } from 'react-router-dom';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import fs from 'fs';
import path from 'path';
import opa from "@open-policy-agent/opa-wasm";

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import UserEdit from './UserEdit';

const server = setupServer(
  rest.get('/api/user', (_, res, ctx) => {
    return res(ctx.json({
      results: [
        { id: 1, role: ["admin"], name: "admin" },
        { id: 2, role: ["player"], name: "player" },
      ]
    }))
  }),
  rest.get('/api/user/2', (_, res, ctx) => {
    return res(ctx.json({
      result: {
        id: 2,
        username: "player",
      },
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders UserEdit to modify self', async () => {
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
        <MemoryRouter initialEntries={['/user/2/edit']} >
          <Routes>
            <Route
              path='/user/:id/edit'
              element={<UserEdit />}
            />
          </Routes>
        </MemoryRouter>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  await waitFor(() => screen.getByText('Update'))

  const createButton = screen.getByText('Update');
  expect(createButton).toBeInTheDocument();
});

test('renders UserEdit to modify as Admin', async () => {
  const wasmPath = path.resolve(__dirname, '../../testdata/policy.wasm');
  const wasm = fs.readFileSync(wasmPath);
  const policy = await opa.loadPolicy(wasm);

  await act(async () => render(
    <MockPolicyEngineContext policy={policy}>
      <MockUserContext user={{
        id: 1,
        role: ["admin"],
        username: "admin",
      }}>
        <MemoryRouter initialEntries={['/user/2/edit']} >
          <Routes>
            <Route
              path='/user/:id/edit'
              element={<UserEdit />}
            />
          </Routes>
        </MemoryRouter>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const createButton = await waitFor(() => screen.getByText('Update'))
  expect(createButton).toBeInTheDocument();
});
