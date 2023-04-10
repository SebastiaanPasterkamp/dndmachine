import React from 'react';

export default function useStateObject(defaultState) {
  const [state, setState] = React.useState(defaultState);
  const setStateObject = React.useCallback(
    update => setState(original => ({ ...original, ...update })),
    [setState],
  );
  return [state, setStateObject];
}