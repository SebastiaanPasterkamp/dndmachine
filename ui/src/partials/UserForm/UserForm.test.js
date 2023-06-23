import { act, render, screen, waitFor } from '@testing-library/react';
import fs from 'fs';
import path from 'path';
import opa from "@open-policy-agent/opa-wasm";

import { MockUserContext } from '../../context/CurrentUserContext';
import { MockPolicyEngineContext } from '../../context/PolicyEngineContext';
import PolicyContext from '../../context/PolicyContext';
import UserForm from './UserForm';

test('renders UserForm', async () => {
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
          <UserForm />
        </PolicyContext>
      </MockUserContext>
    </MockPolicyEngineContext>
  ));

  await waitFor(() => screen.getByText('Reset'))

  const resetButton = screen.getByText('Reset');
  expect(resetButton).toBeInTheDocument();
});
