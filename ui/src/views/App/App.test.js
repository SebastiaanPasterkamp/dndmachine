import { act, render, screen, waitFor } from '@testing-library/react';
import App from './App';

test('renders login form', async () => {
  await act(async () => render(
    <App />
  ));

  await waitFor(() => screen.getByTestId("login.username"));

  const usernameField = screen.getByTestId("login.username");
  expect(usernameField).toBeInTheDocument();

  const passwordField = screen.getByTestId("login.password");
  expect(passwordField).toBeInTheDocument();
});
