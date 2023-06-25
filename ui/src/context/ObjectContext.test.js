import { act, render, screen, waitFor } from '@testing-library/react';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import ObjectsContext, { Objects } from './ObjectsContext';

const server = setupServer(
  rest.get('/api/mock', (req, res, ctx) => {
    return res(ctx.json({
      results: [
        { id: 1, text: "hello" },
        { id: 2, text: "world" },
      ]
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders result using ObjectContext', async () => {
  await act(async () => render(
    <ObjectsContext types={['mock']}>
      <Objects.Consumer>
        {({ mock }) => mock ? (<h1>${mock[1].text}</h1>) : 'loading'}
      </Objects.Consumer>
    </ObjectsContext>
  ));

  const linkElement = await waitFor(() => screen.getByText(/hello/i))
  expect(linkElement).toBeInTheDocument();
});
