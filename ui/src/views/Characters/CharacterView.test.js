import opa from "@open-policy-agent/opa-wasm";
import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import { rest } from 'msw';
import { setupServer } from 'msw/node';
import path from 'path';
import { MemoryRouter, Route, Routes } from 'react-router-dom';

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockDnDMachineContext } from '../../context/DnDMachineContext';
import { MockObjectsContext, useObjectsContext } from "../../context/ObjectsContext";
import PolicyContext from "../../context/PolicyContext";
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import CharacterView from './CharacterView';

const character = {
  id: 1,
  user_id: 2,
  name: "Testy McTestFace",
  choices: {
    "c4826704-86dc-4daf-985b-d4514ece5bc5": { name: "Testy McTestFace" },
  },
};

const server = setupServer(
  rest.get('/api/character/1', (_, res, ctx) => {
    return res(ctx.json({
      result: character,
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders CharacterView', async () => {
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
          types={['user', 'character']}
          character={{
            1: character,
            2: { id: 2, user_id: 2, name: "Bar" },
          }}
          user={{
            1: { id: 1, username: "admin", role: ["admin"] },
            2: { id: 2, username: "player", role: ["player"] },
          }}
        >
          <PolicyContext useContext={useObjectsContext} query={`authz/character/allow`}>
            <MockDnDMachineContext characterCompute={async (character) => character}>
              <MemoryRouter initialEntries={['/character/1']} >
                <Routes>
                  <Route
                    path='/character/:id'
                    element={<CharacterView />}
                  />
                </Routes>
              </MemoryRouter >
            </MockDnDMachineContext>
          </PolicyContext>
        </MockObjectsContext>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const nameElement = await waitFor(() => screen.getByText(/Testy McTestFace/))
  expect(nameElement).toBeInTheDocument();
});
