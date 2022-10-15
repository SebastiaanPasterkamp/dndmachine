import { render, screen } from '@testing-library/react';
import SignIn from './SignIn';

test('renders Email Address field', () => {
  render(<SignIn setUser={() => { }} />);

  const linkElement = screen.getByTestId("login.username");
  expect(linkElement).toBeInTheDocument();
});

test('renders Password field', () => {
  render(<SignIn setUser={() => { }} />);

  const linkElement = screen.getByTestId("login.password");
  expect(linkElement).toBeInTheDocument();
});
