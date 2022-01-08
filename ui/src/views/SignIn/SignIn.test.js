import { render, screen } from '@testing-library/react';
import SignIn from './SignIn';

test('renders Email Address field', () => {
  render(<SignIn setUser={() => {}} />);
  const linkElement = screen.getByLabelText(/Email Address/i);
  expect(linkElement).toBeInTheDocument();
});

test('renders Password field', () => {
  render(<SignIn setUser={() => {}} />);
  const linkElement = screen.getByLabelText(/Password/i);
  expect(linkElement).toBeInTheDocument();
});
