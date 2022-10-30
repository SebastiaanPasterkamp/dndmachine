import * as React from 'react';
import { act, render, screen, waitFor } from '@testing-library/react';
import { rest } from 'msw'
import { setupServer } from 'msw/node'
import CharacterContext from '../../context/CharacterContext';
import AbilityScore from './AbilityScore';

import statistics from '../../testdata/statistics.json';

const server = setupServer(
  rest.get('/api/character/1', (req, res, ctx) => {
    return res(ctx.json({
      result: {
        id: 1,
        name: "dude",
        statistics,
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

test('renders result using StatisticsEdit', async () => {
  await act(async () => render(
    <CharacterContext id={1}>
      <AbilityScore uuid="f00-b4r" />
    </CharacterContext>
  ));

  await waitFor(() => screen.getByTestId('tableTitle'))

  const tableTitle = screen.getByTestId('tableTitle');
  expect(tableTitle).toBeInTheDocument();

  const strengthRow = screen.getByTestId('table-row-strength');
  expect(strengthRow).toBeInTheDocument();
});
