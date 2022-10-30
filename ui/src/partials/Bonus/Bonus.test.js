import { render, screen } from '@testing-library/react';
import Bonus from './Bonus';

test('renders no bonus', () => {
  render(<Bonus bonus={0} />);

  const bonus = screen.getByTestId("bonus")
  expect(bonus).toHaveTextContent('0');
});

test('renders positive bonus', () => {
  render(<Bonus bonus={1} />);

  const bonus = screen.getByTestId("bonus")
  expect(bonus).toHaveTextContent('+1');
});

test('renders negative bonus', () => {
  render(<Bonus bonus={-1} />);

  const bonus = screen.getByTestId("bonus")
  expect(bonus).toHaveTextContent('-1');
});
