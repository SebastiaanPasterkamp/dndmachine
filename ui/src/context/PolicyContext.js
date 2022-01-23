import * as React from 'react';
import opa from "@open-policy-agent/opa-wasm";

const Policy = React.createContext({});

async function getPolicy() {
  return fetch('/ui/policy.wasm')
    .then(response => response.arrayBuffer())
    .then(wasm => opa.loadPolicy(wasm))
}

export default function PolicyContext({ data, query, children }) {
  const [policy, setPolicy] = React.useState(null);

  const isAllowed = !policy ? () => false : (input) => {
    const rules = policy.evaluate(input, query);
    for (const i in rules) {
      if (rules[i].result) {
        return true
      }
    }
    return false
  }

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    if (policy) {
      return;
    }

    getPolicy(data)
      .then(policy => {
        policy.setData(data);
        setPolicy(policy)
      })

    return () => mounted.current = false;
  }, [data, policy])

  return (
    <Policy.Provider value={{ policy, isAllowed }}>
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

