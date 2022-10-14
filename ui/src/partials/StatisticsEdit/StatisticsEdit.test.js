import * as React from 'react';
import { act, render, screen, waitFor, fireEvent } from '@testing-library/react';
import StatisticsEdit from './StatisticsEdit';
import statistics from '../../testdata/statistics.json';

test('renders table for StatisticsEdit', async () => {
  await act(async () => render(
    <StatisticsEdit
      statistics={statistics}
      onChange={() => false}
    />
  ));

  await waitFor(() => screen.getByTestId('table-row-constitution'))

  const tableTitle = screen.getByTestId('tableTitle');
  expect(tableTitle).toBeInTheDocument();

  const headIncrease = screen.queryByTestId('table-head-increase');
  expect(headIncrease).not.toBeInTheDocument();

  const conRow = screen.getByTestId('table-row-constitution');
  expect(conRow).toBeInTheDocument();

  const strBonus = screen.getByTestId('table-cell-strength-bonus');
  expect(strBonus).toHaveTextContent('0');

  const strModifier = screen.getByTestId('table-cell-strength-modifier');
  expect(strModifier).toHaveTextContent('0');

  const conBonus = screen.getByTestId('table-cell-constitution-bonus');
  expect(conBonus).toHaveTextContent('+1');

  const conModifier = screen.getByTestId('table-cell-constitution-modifier');
  expect(conModifier).toHaveTextContent('+2');

  const wisBonus = screen.getByTestId('table-cell-wisdom-bonus');
  expect(wisBonus).toHaveTextContent('0');

  const wisModifier = screen.getByTestId('table-cell-wisdom-modifier');
  expect(wisModifier).toHaveTextContent('-1');
});

test('adds increase column to StatisticsEdit', async () => {
  await act(async () => render(
    <StatisticsEdit
      statistics={statistics}
      increase={2}
      onChange={() => false}
    />
  ));

  await waitFor(() => screen.getByTestId('table-head-increase'))

  const headIncrease = screen.queryByTestId('table-head-increase');
  expect(headIncrease).toBeInTheDocument();
});

test('emit increase change', async () => {
  const onChange = jest.fn((field, callback) => {
    expect(field).toBe('increases');
    expect(callback({ strength: 2 })).toEqual({ constitution: 1, strength: 2 });
  });

  await act(async () => render(
    <StatisticsEdit
      statistics={statistics}
      increase={2}
      onChange={onChange}
    />
  ));

  await waitFor(() => screen.getByTestId('table-head-increase'))

  const buttons = screen.getByTestId('table-cell-constitution-increase').querySelectorAll('button')

  fireEvent.click(buttons[1]);

  expect(onChange).toHaveBeenCalledWith('increases', expect.any(Function));
});
