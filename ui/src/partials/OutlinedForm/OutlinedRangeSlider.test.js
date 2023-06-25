import { act, render, screen, waitFor, fireEvent } from '@testing-library/react';
import OutlinedRangeSlider from './OutlinedRangeSlider';

test('renders simple RangeSlider', async () => {
  const onChange = jest.fn();

  await act(async () => render(
    <OutlinedRangeSlider
      name="example"
      label="Example"
      value={1}
      onChange={onChange}
    />
  ));

  const input = await waitFor(() => screen.getByTestId('input-slider-example').querySelector('input'));
  expect(input.value).toBe("1");
});

test('renders simple RangeSlider', async () => {
  const onChange = jest.fn();

  await act(async () => render(
    <OutlinedRangeSlider
      name="example"
      label="Example"
      value={[10, 90]}
      min={1}
      max={100}
      onChange={onChange}
    />
  ));

  const inputs = await waitFor(() => screen.getByTestId('input-slider-example').querySelectorAll('input'));
  expect(inputs[0].value).toBe("10");
  expect(inputs[1].value).toBe("90");
});
