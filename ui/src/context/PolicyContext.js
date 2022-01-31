import * as React from 'react';
import opa from "@open-policy-agent/opa-wasm";

const Policy = React.createContext({});

async function getPolicy() {
  return fetch('/ui/policy.wasm')
    .then(response => response.arrayBuffer())
    .then(wasm => opa.loadPolicy(wasm))
}

export default function PolicyContext({ data, useContext = () => { }, query, children }) {
  const [policy, setPolicy] = React.useState(null);
  const funcData = useContext();

  const isAllowed = (input, override) => {
    if (!policy) {
      return false;
    }
    const rules = policy.evaluate(input, override || query);
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

    getPolicy()
      .then(policy => {
        if (!mounted.current) return;

        policy.setData({ ...data, ...funcData });
        setPolicy(policy)
      })

    return () => mounted.current = false;
  }, [data, funcData])

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
