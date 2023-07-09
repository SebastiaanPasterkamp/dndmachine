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
import CharacterEdit from "./CharacterEdit";

const server = setupServer(
  rest.get('/api/character/2', (req, res, ctx) => {
    return res(ctx.json({
      result: {
        id: 2,
        user_id: 2,
        name: "Foo",
      },
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders CharacterEdit to modify existing', async () => {
  const wasmPath = path.resolve(__dirname, '../../testdata/policy.wasm');
  const wasm = fs.readFileSync(wasmPath);
  const policy = await opa.loadPolicy(wasm);

  await act(async () => render(
    <MockPolicyEngineContext policy={policy}>
      <MockUserContext user={{
        id: 2,
        role: ["player"],
        username: "player",
      }}>
        <MockObjectsContext
          types={['character']}
          character={{
            1: { id: 1, user_id: 2, name: "Foo" },
            2: { id: 2, user_id: 2, name: "Bar" },
          }}
        >
          <PolicyContext useContext={useObjectsContext} query={`authz/character/allow`}>
            <MemoryRouter initialEntries={['/character/2/edit']} >
              <Routes>
                <Route
                  path='/character/:id/edit'
                  element={<CharacterEdit />}
                />
              </Routes>
            </MemoryRouter>
          </PolicyContext>
        </MockObjectsContext>
      </MockUserContext>
    </MockPolicyEngineContext >
  ));

  const updateButton = await waitFor(() => screen.getByText('Update'))
  expect(updateButton).toBeInTheDocument();
});
