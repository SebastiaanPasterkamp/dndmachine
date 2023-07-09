import opa from "@open-policy-agent/opa-wasm";
import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import path from 'path';

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockObjectsContext, useObjectsContext } from "../../context/ObjectsContext";
import PolicyContext from '../../context/PolicyContext';
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import CharacterEditor from "./CharacterEditor";

test('renders CharacterEditor to create', async () => {
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
          <CharacterEditor />
        </PolicyContext>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const createButton = await waitFor(() => screen.getByText('Create'))
  expect(createButton).toBeInTheDocument();

  const resetButton = await waitFor(() => screen.getByText('Reset'))
  expect(resetButton).toBeInTheDocument();
});

test('renders CharacterEditor to update', async () => {
  const wasmPath = path.resolve(__dirname, '../../testdata/policy.wasm');
  const wasm = fs.readFileSync(wasmPath);
  const policy = await opa.loadPolicy(wasm);

  const character = {
    id: 1,
    user_id: 2,
    name: "Foo",
  };

  await act(async () => render(
    <MockPolicyEngineContext policy={policy}>
      <MockUserContext user={{
        id: 2,
        role: ["player"],
        name: "player",
      }}>
        <MockObjectsContext
          types={['character']}
          character={{
            1: { id: 1, user_id: 2, name: "Foo" },
            2: { id: 2, user_id: 2, name: "Bar" },
          }}
        >

          <PolicyContext useContext={useObjectsContext} query={`authz/character/allow`}>
            <CharacterEditor character={character} />
          </PolicyContext>
        </MockObjectsContext>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  const updateButton = await waitFor(() => screen.getByText('Update'))
  expect(updateButton).toBeInTheDocument();

  const resetButton = await waitFor(() => screen.getByText('Reset'))
  expect(resetButton).toBeInTheDocument();
});
