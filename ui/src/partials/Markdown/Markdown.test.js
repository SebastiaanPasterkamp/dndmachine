import { render, screen } from '@testing-library/react';
import Markdown from './Markdown';

test('renders nothing', () => {
  const { container } = render(<Markdown />)
  expect(container.children.length).toEqual(0);
});

test('renders markdown', () => {
  render(
    <Markdown description="## hello world
      * This
      * works
    " />
  );

  const title = screen.getByTitle(/hello world/);
  expect(title).toBeInTheDocument();
});
