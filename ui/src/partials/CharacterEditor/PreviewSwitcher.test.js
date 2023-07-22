import opa from "@open-policy-agent/opa-wasm";
import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import path from 'path';

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockObjectsContext, useObjectsContext } from "../../context/ObjectsContext";
import PolicyContext from '../../context/PolicyContext';
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import PreviewSwitcher from "./PreviewSwitcher";

test('renders PreviewSwitcher to create', async () => {
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
          <PreviewSwitcher />
        </PolicyContext>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const input = await waitFor(() => screen.getByTestId('input-text-name').querySelector('input'));
  expect(input.value).toBe('');

  const createButton = await waitFor(() => screen.getAllByText('Create'));
  expect(createButton[1]).toBeInTheDocument();

  const resetButton = await waitFor(() => screen.getByText('Reset'))
  expect(resetButton).toBeInTheDocument();
});

test('renders PreviewSwitcher to update', async () => {
  const wasmPath = path.resolve(__dirname, '../../testdata/policy.wasm');
  const wasm = fs.readFileSync(wasmPath);
  const policy = await opa.loadPolicy(wasm);

  const character = {
    id: 1,
    user_id: 2,
    name: "Foo",
    choices: {
      "c4826704-86dc-4daf-985b-d4514ece5bc5": { name: "Testy McTestFace" },
    },
  };

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
            <PreviewSwitcher character={character} />
          </PolicyContext>
        </MockObjectsContext>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const input = await waitFor(() => screen.getByTestId('input-text-name').querySelector('input'));
  expect(input.value).toBe('Testy McTestFace');

  const updateButton = await waitFor(() => screen.getByText('Update'));
  expect(updateButton).toBeInTheDocument();

  const resetButton = await waitFor(() => screen.getByText('Reset'))
  expect(resetButton).toBeInTheDocument();
});
