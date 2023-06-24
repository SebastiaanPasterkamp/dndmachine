import * as React from 'react';
import { render, screen, waitFor, fireEvent } from '@testing-library/react';
import OutlinedInput from './OutlinedInput';

test('renders text OutlinedInput', async () => {
  const onChange = jest.fn();

  render(
    <OutlinedInput
      name="example"
      label="Example"
      value="text value"
      onChange={onChange}
    />
  );

  await waitFor(() => screen.getByTestId('input-text-example'));

  const input = screen.getByTestId('input-text-example').querySelector('input')
  expect(input.value).toBe('text value');
});

test('sends normal events for text changes', async () => {
  const onChange = jest.fn();

  render(
    <OutlinedInput
      name="example"
      label="Example"
      value="text value"
      onChange={onChange}
    />
  );

  await waitFor(() => screen.getByTestId('input-text-example'));

  const input = screen.getByTestId('input-text-example').querySelector('input')
  expect(input.value).toBe('text value');

  fireEvent.change(input, { target: { value: 'updated' } });

  expect(onChange).toHaveBeenCalled();
});

test('sends events with numeric values', async () => {
  const onChange = jest.fn();

  render(
    <OutlinedInput
      name="example"
      type="number"
      label="Example"
      value="3"
      onChange={onChange}
    />
  );

  await waitFor(() => screen.getByTestId('input-number-example'));

  const input = screen.getByTestId('input-number-example').querySelector('input')
  expect(input.value).toBe('3');

  fireEvent.change(input, { target: { value: 'updated' } });

  expect(onChange).not.toHaveBeenCalled();

  fireEvent.change(input, { target: { value: '5' } });

  expect(onChange).toHaveBeenCalledWith(
    expect.objectContaining({
      target: expect.objectContaining({
        name: "example",
        value: 5,
      }),
    }),
  );
});
