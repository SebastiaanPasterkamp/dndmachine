import { render, screen } from '@testing-library/react';
import Footer from './Footer';

test('renders Source Code link', () => {
  render(<Footer />);
  const linkElement = screen.getByText(/Source Code/i);
  expect(linkElement).toBeInTheDocument();
});
