import { render, screen, waitFor } from '@testing-library/react';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import Dashboard from './Dashboard';

const server = setupServer(
  rest.get('/api/mock', (req, res, ctx) => {
    return res(ctx.json({
      result: [
        { id: 1, text: "hello" },
        { id: 2, text: "world" },
      ]
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders Dashboard header', async () => {
  render(<Dashboard
    component={({ text }) => (<h1>{text}</h1>)}
    type="mock"
  />);

  await waitFor(() => screen.getAllByRole('heading'))

  const linkElement = screen.getByText(/hello/i);
  expect(linkElement).toBeInTheDocument();
});
