import { act, render, screen } from '@testing-library/react';
import Header from './Header';

test('renders D&D Machine title', async () => {
  await act(async () => render(<Header
    setUser={() => { }}
    toggleMenu={() => { }}
  />));

  const linkElement = screen.getByText(/D&D Machine/i);

  expect(linkElement).toBeInTheDocument();
});
