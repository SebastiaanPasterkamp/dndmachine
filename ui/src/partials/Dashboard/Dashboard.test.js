import { act, render, screen, waitFor } from '@testing-library/react';
import { Objects } from '../../context/ObjectsContext';
import Dashboard from './Dashboard';

const mock = {
  1: { id: 1, text: 'hello' },
  2: { id: 2, text: 'world' },
}

const MockComponent = function ({ text, loading }) {
  if (loading) {
    return (<h1>Loading...</h1>);
  }
  return (<h1>{text}</h1>)
}

test('renders Dashboard header', async () => {
  await act(async () => render(
    <Objects.Provider value={{ mock, loading: { mock: false } }}>
      <Dashboard
        component={MockComponent}
        type="mock"
      />
    </Objects.Provider>
  ));

  await waitFor(() => screen.getAllByRole('heading'))

  const loader = screen.queryAllByText('Loading...');
  expect(loader).toHaveLength(0);

  const object = screen.queryByText('hello');
  expect(object).toBeInTheDocument();
});

test('renders Dashboard skeleton when loading', async () => {
  await act(async () => render(
    <Objects.Provider value={{ mock, loading: { mock: true } }}>
      <Dashboard
        component={MockComponent}
        type="mock"
      />
    </Objects.Provider>
  ));

  await waitFor(() => screen.getAllByRole('heading'))

  const loader = screen.queryAllByText('Loading...');
  expect(loader).toHaveLength(3);

  const object = screen.queryByText('hello');
  expect(object).toBeNull();
});
