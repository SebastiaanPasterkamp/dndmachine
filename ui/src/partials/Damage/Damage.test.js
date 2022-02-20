import { render, screen } from '@testing-library/react';
import Damage from './Damage';

test('renders no damage', () => {
  const { container } = render(<Damage />)
  expect(container.children.length).toEqual(0);
});

test('flat damage', () => {
  render(<Damage damage={{ value: 1, type: 'piercing' }} />);

  const value = screen.getByText(/1 pcn/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/1 Piercing/);
  expect(title).toBeInTheDocument();
});

test('only bonus damage', () => {
  render(<Damage damage={{ bonus: 1, type: 'poison' }} />);

  const value = screen.getByText(/\+1 psn/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/\+1 Poison/);
  expect(title).toBeInTheDocument();
});

test('renders simple damage', () => {
  render(<Damage damage={{ dice_count: 1, dice_size: 4, type: 'bludgeoning' }} />);

  const value = screen.getByText(/1d4 bldg/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/1d4 Bludgeoning/);
  expect(title).toBeInTheDocument();
});

test('renders complex damage', () => {
  render(<Damage damage={{ dice_count: 1, dice_size: 4, bonus: 3, type: 'poison' }} />);

  const value = screen.getByText(/1d4\+3 psn/);
  expect(value).toBeInTheDocument();

  const title = screen.getByLabelText(/1d4\+3 Poison/);
  expect(title).toBeInTheDocument();
});

test('renders versatile damage', () => {
  render(<Damage
    damage={{ dice_count: 1, dice_size: 6, type: 'slashing' }}
    versatile={{ dice_count: 1, dice_size: 8, type: 'slashing' }}
  />);

  const valueD = screen.getByText(/1d6 slsh/);
  expect(valueD).toBeInTheDocument();

  const titleD = screen.getByLabelText(/1d6 Slashing/);
  expect(titleD).toBeInTheDocument();

  const valueV = screen.getByText(/1d8 slsh/);
  expect(valueV).toBeInTheDocument();

  const titleV = screen.getByLabelText(/1d8 Slashing/);
  expect(titleV).toBeInTheDocument();
});
