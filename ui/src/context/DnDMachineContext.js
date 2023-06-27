import * as React from 'react';
import './crypto.polyfill';
import './wasm_exec';

const DnDMachine = React.createContext({});

async function getDnDMachine(signal, provider) {
  if (globalThis.NewDnDMachine === undefined) {
    const go = new globalThis.Go();

    const result = await WebAssembly.instantiateStreaming(
      fetch('ui/dndmachine.wasm', { signal }),
      go.importObject
    )

    const goIsReady = new Promise((resolve) => {
      window.onDnDMachineStarted = resolve;
    });

    go.run(result.instance);

    await goIsReady;
  }

  return globalThis.NewDnDMachine(provider)
}

const defaultProvider = (uuid) => fetch(`/api/character-option/uuid/${uuid}`, {
  method: 'GET',
  credentials: 'same-origin',
})
  .then(response => {
    if (!response.ok) {
      throw new Error(`${response.status}: ${response.statusText}`);
    }
    return response.json();
  })
  .then(data => JSON.stringify(data.result));

export default function DnDMachineContext({ provider, children }) {
  const [machine, setMachine] = React.useState(null);

  React.useEffect(() => {
    const abortController = new AbortController();

    getDnDMachine(abortController.signal, provider || defaultProvider)
      .then(machine => setMachine(machine))
      .catch((error) => console.error('Error:', error));

    return () => abortController.abort();
  }, [provider])

  const characterCompute = async (character) => {
    return await machine.CharacterCompute(JSON.stringify(character))
      .then((update) => JSON.parse(update));
  }

  if (!machine) return null;

  return (
    <DnDMachine.Provider value={{ characterCompute }}>
      {children}
    </DnDMachine.Provider>
  );
}

function MockDnDMachineContext({ children, characterCompute }) {
  return (
    <DnDMachine.Provider value={{ characterCompute }}>
      {children}
    </DnDMachine.Provider>
  );
}

function useDnDMachineContext() {
  const context = React.useContext(DnDMachine);
  if (context === undefined) {
    throw new Error("Context must be used within a Provider");
  }
  return context;
}

export {
  DnDMachine,
  DnDMachineContext,
  MockDnDMachineContext,
  useDnDMachineContext
};

