import { render, screen } from '@testing-library/react';
import Range from './Range';

test('renders something without range', () => {
  const { container } = render(<Range />)
  expect(container.children.length).toEqual(0);
});

test('renders a melee object', () => {
  render(<Range min={5} />);

  const value = screen.getByText(/5ft\./);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/5 Feet/);
  expect(title).toBeInTheDocument();
});

test('renders a range object', () => {
  render(<Range min={30} max={60} />);

  const valueMin = screen.getByText(/30ft\./);
  expect(valueMin).toBeInTheDocument();

  const titleMin = screen.getByLabelText(/30 Feet/);
  expect(titleMin).toBeInTheDocument();

  const valueMax = screen.getByText(/60ft\./);
  expect(valueMax).toBeInTheDocument();

  const titleMax = screen.getByLabelText(/60 Feet with disadvantage/);
  expect(titleMax).toBeInTheDocument();
});

