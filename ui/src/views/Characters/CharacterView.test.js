import opa from "@open-policy-agent/opa-wasm";
import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import { rest } from 'msw';
import { setupServer } from 'msw/node';
import path from 'path';
import { MemoryRouter, Route, Routes } from 'react-router-dom';

import { MockDnDMachineContext } from '../../context/DnDMachineContext';
import PolicyContext from "../../context/PolicyContext";
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import CharacterView from './CharacterView';

const server = setupServer(
  rest.get('/api/character', (_, res, ctx) => {
    return res(ctx.json({
      results: [{ id: 1, name: "Testy McTestFace" }],
    }))
  }),
  rest.get('/api/character/1', (_, res, ctx) => {
    return res(ctx.json({
      result: { id: 1, name: "Testy McTestFace" },
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
      <PolicyContext>
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
    </MockPolicyEngineContext>
  ));

  const nameElements = await waitFor(() => screen.getAllByText(/Testy McTestFace/))
  expect(nameElements[0]).toBeInTheDocument();
});
