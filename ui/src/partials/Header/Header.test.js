import { render, screen } from '@testing-library/react';
import Header from './Header';

test('renders D&D Machine title', () => {
  render(<Header setUser={() => {}} />);
  const linkElement = screen.getByText(/D&D Machine/i);
  expect(linkElement).toBeInTheDocument();
});
