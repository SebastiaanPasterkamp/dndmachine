import { render, screen } from '@testing-library/react';
import Dashboard from './Dashboard';

test('renders Dashboard header', () => {
  render(<Dashboard />);
  const linkElement = screen.getByText(/Dashboard/i);
  expect(linkElement).toBeInTheDocument();
});
