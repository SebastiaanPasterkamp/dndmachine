import { render, screen } from '@testing-library/react';
import Weight from './Weight';

test('renders something weightless', () => {
  const { container } = render(<Weight />)
  expect(container.children.length).toEqual(0);
});

test('renders a light object', () => {
  render(<Weight oz={3} />);

  const value = screen.getByText(/3oz/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/3 Ounces/);
  expect(title).toBeInTheDocument();
});

test('renders heavier objects', () => {
  render(<Weight lb={5} oz={2} />);

  const valueLB = screen.getByText(/5lb/);
  expect(valueLB).toBeInTheDocument();

  const titleLB = screen.getByLabelText(/5 Pounds/);
  expect(titleLB).toBeInTheDocument();

  const valueOZ = screen.getByText(/2oz/);
  expect(valueOZ).toBeInTheDocument();

  const titleOZ = screen.getByLabelText(/2 Ounces/);
  expect(titleOZ).toBeInTheDocument();
});

test('handles plural/singular', () => {
  render(<Weight lb={1} oz={1} />);

  const titleLB = screen.getByLabelText(/1 Pound\b/);
  expect(titleLB).toBeInTheDocument();

  const titleOZ = screen.getByLabelText(/1 Ounce\b/);
  expect(titleOZ).toBeInTheDocument();
});
