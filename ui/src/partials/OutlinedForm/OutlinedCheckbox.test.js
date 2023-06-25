import { act, render, screen, waitFor, fireEvent } from '@testing-library/react';
import OutlinedCheckbox from './OutlinedCheckbox';

test('renders plain Checkbox', async () => {
  const onChange = jest.fn();

  await act(async () => render(
    <OutlinedCheckbox
      name="example"
      label="Example"
      onChange={onChange}
    />
  ));

  const checkbox = await waitFor(() => screen.getByTestId('input-checkbox-example').querySelector('input'));
  expect(checkbox.checked).toBe(false);

  fireEvent.click(checkbox);

  expect(onChange).toHaveBeenCalledWith(
    expect.objectContaining({
      target: expect.objectContaining({
        name: "example",
        value: true,
      }),
    }),
  );
});

test('renders Checkbox with help text', async () => {
  const onChange = jest.fn();

  await act(async () => render(
    <OutlinedCheckbox
      name="example"
      label="Example"
      helper="Click me"
      value={true}
      onChange={onChange}
    />
  ));

  const help = await waitFor(() => screen.getByText('Click me'));
  expect(help).toBeInTheDocument();
});

test('renders Checkbox with error', async () => {
  const onChange = jest.fn();

  await act(async () => render(
    <OutlinedCheckbox
      name="example"
      label="Example"
      helper="Click me"
      error="Whoops"
      value={true}
      onChange={onChange}
    />
  ));

  const error = await waitFor(() => screen.getByText('Whoops'));
  expect(error).toBeInTheDocument();

  const help = await waitFor(() => screen.queryByText('Click me'));
  expect(help).not.toBeInTheDocument();
});
