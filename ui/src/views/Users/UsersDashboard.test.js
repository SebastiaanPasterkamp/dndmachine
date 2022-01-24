import { render, screen, waitFor } from '@testing-library/react';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import UsersDashboard from './UsersDashboard';

const server = setupServer(
  rest.get('/api/user', (req, res, ctx) => {
    return res(ctx.json({
      result: [
        { id: 1, name: "hello" },
        { id: 2, name: "world" },
      ]
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders UsersDashboard', async () => {
  render(<UsersDashboard />);

  await waitFor(() => screen.getByText('hello'))

  const linkElement = screen.getByText('hello');
  expect(linkElement).toBeInTheDocument();
});
