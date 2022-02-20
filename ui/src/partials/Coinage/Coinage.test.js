import { render, screen } from '@testing-library/react';
import Coinage from './Coinage';

test('renders an empty purse', () => {
  const { container } = render(<Coinage />)
  expect(container.children.length).toEqual(0);
});

test('renders a single coinage', () => {
  render(<Coinage gp={10} />);

  const value = screen.getByText(/10gp/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/10 Gold/);
  expect(title).toBeInTheDocument();
});

test('renders multiple coins', () => {
  render(<Coinage cp={10} sp={5} />);

  const valueCP = screen.getByText(/10cp/);
  expect(valueCP).toBeInTheDocument();

  const titleCP = screen.getByLabelText(/10 Copper/);
  expect(titleCP).toBeInTheDocument();

  const valueSP = screen.getByText(/5sp/);
  expect(valueSP).toBeInTheDocument();

  const titleSP = screen.getByLabelText(/5 Silver/);
  expect(titleSP).toBeInTheDocument();
});
