import { render, screen } from '@testing-library/react';
import SignIn from './App';

test('renders email field', () => {
  render(<SignIn />);
  const linkElement = screen.getByLabelText(/Username/i);
  expect(linkElement).toBeInTheDocument();
});

test('renders password field', () => {
  render(<SignIn />);
  const linkElement = screen.getByLabelText(/toggle password/i);
  expect(linkElement).toBeInTheDocument();
});
