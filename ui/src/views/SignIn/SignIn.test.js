import { act, render, screen, waitFor } from '@testing-library/react';
import SignIn from './SignIn';

test('renders Email Address field', async () => {
  await act(async () => render(
    <SignIn setUser={() => { }} />
  ));

  const input = await waitFor(() => screen.getByTestId('login.username'));
  expect(input).toBeInTheDocument();
});

test('renders Password field', async () => {
  await act(async () => render(
    <SignIn setUser={() => { }} />
  ));

  const input = await waitFor(() => screen.getByTestId('login.password'));
  expect(input).toBeInTheDocument();
});
