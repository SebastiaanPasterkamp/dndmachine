import { render, screen } from '@testing-library/react';
import Armor from './Armor';

test('renders something without Armor', () => {
  const { container } = render(<Armor />)
  expect(container.children.length).toEqual(0);
});

test('renders a armored object', () => {
  render(<Armor value={11} />);

  const value = screen.getByText(/11AC/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/11 Armor Class/);
  expect(title).toBeInTheDocument();
});

test('renders bonus armor', () => {
  render(<Armor bonus={2} />);

  const value = screen.getByText(/\+2AC/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/\+2 Armor Class/);
  expect(title).toBeInTheDocument();
});

test('mentions stealth disadvantage', () => {
  render(<Armor disadvantage />);

  const value = screen.getByText(/\bD\b/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/Disadvantage/);
  expect(title).toBeInTheDocument();
});

test('shows formula when value unknown', () => {
  render(<Armor formula="11 + statistics.modifiers.dexterity" />);

  const value = screen.getByText(/11 \+ Dex/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/11 \+ Dexterity Modifier/);
  expect(title).toBeInTheDocument();
});

test('explains value when formula known', () => {
  render(<Armor value={13} formula="11 + statistics.modifiers.dexterity" />);

  const value = screen.getByText(/13AC/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/11 \+ Dexterity Modifier/);
  expect(title).toBeInTheDocument();
});

test('handle formula with minimum value', () => {
  render(<Armor formula="12 + min(2, statistics.modifiers.dexterity)" />);

  const value = screen.getByText(/12 \+ Dex \(max 2\)/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/12 \+ Dexterity Modifier \(maximum of 2\)/);
  expect(title).toBeInTheDocument();
});
