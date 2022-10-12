import * as React from 'react';
import { act, render, screen, waitFor } from '@testing-library/react';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import CharacterContext, { Character } from './CharacterContext';

const server = setupServer(
  rest.get('/api/character/1', (req, res, ctx) => {
    return res(ctx.json({
      result: {
        id: 1,
        name: "dude",
        decisions: {
          'f00-b4r': { value: "existing" },
        },
      },
    }))
  }),
)

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('renders result using CharacterContext', async () => {
  await act(async () => render(
    <CharacterContext id={1}>
      <Character.Consumer>
        {({ loading, character }) => (
          loading
            ? 'loading'
            : <h1>${character.name}</h1>
        )}
      </Character.Consumer>
    </CharacterContext>
  ));

  await waitFor(() => screen.getByRole('heading'))

  const linkElement = screen.getByText(/dude/i);
  expect(linkElement).toBeInTheDocument();
});

test('should be able to access decisions', () => {
  render(
    <CharacterContext id={1}>
      <Character.Consumer>
        {({ loading, getDecision }) => {
          if (loading) return null;

          const decision = getDecision('f00-b4r');

          return (
            <h1>${decision.value}</h1>
          )
        }}
      </Character.Consumer>
    </CharacterContext>
  );
});


test('should be able to update decisions', () => {
  render(
    <CharacterContext id={1}>
      <Character.Consumer>
        {({ loading, getDecision, updateDecision }) => {
          if (loading) return null;

          const decision = getDecision('something-new');

          React.useEffect(() => {
            if (!decision) {
              updateDecision('something-new', { value: "updated" })
            }
          }, [decision]);

          return (
            <h1>${decision.value}</h1>
          )
        }}
      </Character.Consumer>
    </CharacterContext>
  );
});
