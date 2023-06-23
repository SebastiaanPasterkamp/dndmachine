import * as React from 'react';
import opa from "@open-policy-agent/opa-wasm";

const PolicyEngine = React.createContext({});

async function getPolicyEngine(signal) {
  return fetch('/ui/policy.wasm', { signal })
    .then(response => response.arrayBuffer())
    .then(wasm => opa.loadPolicy(wasm))
}

export default function PolicyEngineContext({ children }) {
  const [policy, setPolicy] = React.useState(null);

  React.useEffect(() => {
    const abortController = new AbortController();

    getPolicyEngine(abortController.signal)
      .then(policy => {
        setPolicy(policy)
      })

    return () => abortController.abort();
  }, [])

  return (
    <PolicyEngine.Provider value={{ policy }}>
      {children}
    </PolicyEngine.Provider>
  );
}

export function MockPolicyEngineContext({ children, policy }) {
  return (
    <PolicyEngine.Provider value={{ policy }}>
      {children}
    </PolicyEngine.Provider>
  );
}

export function usePolicyEngineContext() {
  const context = React.useContext(PolicyEngine);
  if (context === undefined) {
    throw new Error("Context must be used within a Provider");
  }
  return context;
}
