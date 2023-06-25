import { act, render, screen, waitFor } from '@testing-library/react';
import { Route, Routes, MemoryRouter } from 'react-router-dom';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import fs from 'fs';
import path from 'path';
import opa from "@open-policy-agent/opa-wasm";

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import UserView from './UserView';

const server = setupServer(
  rest.get('/api/user', (_, res, ctx) => {
    return res(ctx.json({
      results: [{ id: 1, name: "hello" }],
    }))
  }),
  rest.get('/api/user/1', (_, res, ctx) => {
    return res(ctx.json({
      result: { id: 1, name: "hello" },
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders UserView', async () => {
  const wasmPath = path.resolve(__dirname, '../../testdata/policy.wasm');
  const wasm = fs.readFileSync(wasmPath);
  const policy = await opa.loadPolicy(wasm);

  await act(async () => render(
    <MockPolicyEngineContext policy={policy}>
      <MockUserContext user={{
        id: 1,
        name: "hello",
      }}>
        <MemoryRouter initialEntries={['/user/1']} >
          <Routes>
            <Route
              path='/user/:id'
              element={<UserView />}
            />
          </Routes>
        </MemoryRouter >
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const linkElement = await waitFor(() => screen.getByText('hello'))
  expect(linkElement).toBeInTheDocument();
});
