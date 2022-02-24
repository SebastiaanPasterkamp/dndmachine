import { render, screen } from '@testing-library/react';
import Markdown from './Markdown';

test('renders nothing', () => {
  const { container } = render(<Markdown />)
  expect(container.children.length).toEqual(0);
});

test('renders markdown', () => {
  const text = `
# hello world
* This
* works`;
  render(
    <Markdown description={text} />
  );

  const title = screen.getByRole('heading', { text: /hello world/ });
  expect(title).toBeInTheDocument();
});
