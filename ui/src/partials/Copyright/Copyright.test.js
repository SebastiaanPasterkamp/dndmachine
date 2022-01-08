import { render, screen } from '@testing-library/react';
import Copyright from './Copyright';

test('renders Copyright notice', () => {
  render(<Copyright />);
  const linkElement = screen.getByText(/Copyright/i);
  expect(linkElement).toBeInTheDocument();
});
