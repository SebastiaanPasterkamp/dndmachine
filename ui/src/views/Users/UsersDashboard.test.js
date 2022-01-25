import { act, render, screen, waitFor } from '@testing-library/react';
import { Route, Routes, MemoryRouter } from 'react-router-dom';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import fs from 'fs';
import path from 'path';
import UsersDashboard from './UsersDashboard';

const server = setupServer(
  rest.get('/api/user', (_, res, ctx) => {
    return res(ctx.json({
      result: [
        { id: 1, name: "hello" },
        { id: 2, name: "world" },
      ]
    }))
  }),
  rest.get('/ui/policy.wasm', (_, res, ctx) => {
    const wasmPath = path.resolve(__dirname, '../../testdata/policy.wasm');
    const wasm = fs.readFileSync(wasmPath);

    return res(
      ctx.set('Content-Length', wasm.byteLength.toString()),
      ctx.set('Content-Type', 'application/wasm'),
      ctx.body(wasm),
    )
  })
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders UsersDashboard', async () => {
  await act(async () => render(
    <MemoryRouter initialEntries={['/user']} >
      <Routes>
        <Route
          path='/user'
          element={<UsersDashboard />}
        />
      </Routes>
    </MemoryRouter >
  ));

  await waitFor(() => screen.getByText('hello'))

  const linkElement = screen.getByText('hello');
  expect(linkElement).toBeInTheDocument();
});
