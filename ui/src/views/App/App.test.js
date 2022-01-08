import { render, screen } from '@testing-library/react';
import SignIn from './App';

test('renders email field', () => {
  render(<SignIn />);
  const linkElement = screen.getByLabelText(/Email Address/i);
  expect(linkElement).toBeInTheDocument();
});

test('renders password field', () => {
  render(<SignIn />);
  const linkElement = screen.getByLabelText(/Password/i);
  expect(linkElement).toBeInTheDocument();
});
