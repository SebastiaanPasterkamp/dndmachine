import { render, screen } from '@testing-library/react';
import SignIn from './SignIn';

test('renders Email Address field', () => {
  render(<SignIn setUser={() => { }} />);
  const linkElement = screen.getByLabelText(/Username/i);
  expect(linkElement).toBeInTheDocument();
});

test('renders Password field', () => {
  render(<SignIn setUser={() => { }} />);
  const linkElement = screen.getByLabelText(/toggle password/i);
  expect(linkElement).toBeInTheDocument();
});
