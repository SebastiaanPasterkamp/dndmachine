import * as React from 'react';
import { act, render, screen, waitFor, fireEvent } from '@testing-library/react';

import OutlinedForm from './OutlinedForm';
import OutlinedInput from './OutlinedInput';

test('renders text OutlinedForm', async () => {
  const onChange = jest.fn();

  await act(async () => render(
    <OutlinedForm>
      <OutlinedInput
        name="example"
        label="Example"
        value="text value"
        onChange={onChange}
      />
    </OutlinedForm>
  ));

  const input = await waitFor(() => screen.getByTestId('input-text-example').querySelector('input'));
  expect(input).toBeInTheDocument();
});
