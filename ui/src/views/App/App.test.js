import { act, render, screen, waitFor } from '@testing-library/react';
import App from './App';

test('renders login form', async () => {
  await act(async () => render(
    <App />
  ));

  const usernameField = await waitFor(() => screen.getByTestId("login.username"));
  expect(usernameField).toBeInTheDocument();

  const passwordField = await waitFor(() => screen.getByTestId("login.password"));
  expect(passwordField).toBeInTheDocument();
});
