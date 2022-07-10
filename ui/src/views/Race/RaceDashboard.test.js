import { act, render, screen, waitFor } from '@testing-library/react';
import { Route, Routes, MemoryRouter } from 'react-router-dom';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import fs from 'fs';
import path from 'path';
import RaceDashboard from './RaceDashboard';

const server = setupServer(
  rest.get('/api/race', (_, res, ctx) => {
    return res(ctx.json({
      results: [
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

test('renders RaceDashboard', async () => {
  await act(async () => render(
    <MemoryRouter initialEntries={['/race']} >
      <Routes>
        <Route
          path='/race'
          element={<RaceDashboard />}
        />
      </Routes>
    </MemoryRouter >
  ));

  await waitFor(() => screen.getByText('hello'))

  const linkElement = screen.getByText('hello');
  expect(linkElement).toBeInTheDocument();
});
