import { act, fireEvent, render, screen, waitFor } from '@testing-library/react';

import Description from "./Description";

test('renders CharacterEditor to create', async () => {
  const onChange = jest.fn();

  await act(async () => render(
    <Description
      onChange={onChange}
    />
  ));

  const input = await waitFor(() => screen.getByTestId('input-text-name').querySelector('input'));
  expect(input.value).toBe('');

  fireEvent.change(input, { target: { value: 'Testy McTestFace' } });

  expect(onChange).toHaveBeenCalled();
});

test('renders CharacterEditor to update', async () => {
  const onChange = jest.fn();

  const character = {
    id: 1,
    user_id: 2,
    name: "Foo",
    choices: {},
  };

  await act(async () => render(
    <Description
      character={character}
      choice={{
        name: 'Test',
      }}
      onChange={onChange}
    />
  ));

  const input = await waitFor(() => screen.getByTestId('input-text-name').querySelector('input'));
  expect(input.value).toBe('Test');

  fireEvent.change(input, { target: { value: 'Testy McTestFace' } });

  expect(onChange).toHaveBeenCalled();
});
