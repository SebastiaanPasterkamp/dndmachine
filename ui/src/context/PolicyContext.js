import * as React from 'react';
import { usePolicyEngineContext } from './PolicyEngineContext';

const Policy = React.createContext({});

export default function PolicyContext({ data, useContext = () => { }, query, children }) {
  const { policy } = usePolicyEngineContext();
  const funcData = useContext();

  const isAllowed = (input, override) => {
    if (!policy) {
      return false;
    }
    policy.setData({ ...data, ...funcData });
    const rules = policy.evaluate(input, override || query);
    for (const i in rules) {
      // result can be non-boolean, which means it is (partially) allowed
      if (rules[i].result !== false) {
        return true
      }
    }
    return false
  }

  return (
    <Policy.Provider value={{ isAllowed }}>
      {children}
    </Policy.Provider>
  );
}

export function usePolicyContext() {
  const context = React.useContext(Policy);
  if (context === undefined) {
    throw new Error("Context must be used within a Provider");
  }
  return context;
}
