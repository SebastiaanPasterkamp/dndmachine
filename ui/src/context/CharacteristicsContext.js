import React from 'react';

export const Characteristics = React.createContext({});

export default function CharacteristicsContext({ children }) {
  const [focus, setFocus] = React.useState();
  const [characteristics, setCharacteristics] = React.useState({});
  const [loadings, setLoadings] = React.useState({});

  const listeners = new Set();

  const subscribe = (callback) => {
    listeners.add(callback);
    return () => listeners.delete(callback);
  };

  const getCharacteristic = React.useCallback(
    (uuid) => {
      const { [uuid]: characteristic = {} } = characteristics;
      const { [uuid]: loading = false } = loadings;
      return { characteristic, loading, focus };
    },
    [characteristics, loadings, focus],
  );

  const updateCharacteristic = async (uuid, field, change) => setCharacteristics(characteristics => {
    const { [uuid]: characteristic } = characteristics;
    const { [field]: original } = characteristic || {};
    const update = change(original);
    const final = { ...characteristic, [field]: update, };

    listeners.forEach((callback) => callback(uuid, {
      characteristic: final,
    }));

    return {
      ...characteristics,
      [uuid]: final,
    };
  });

  return (
    <Characteristics.Provider value={{
      focus,
      setFocus,
      getCharacteristic,
      updateCharacteristic,
      subscribe,
    }}>
      {children}
    </Characteristics.Provider>
  );
}

export function useCharacteristicsContext() {
  const context = React.useContext(Characteristics);
  if (context === undefined) {
    throw new Error("Context must be used within a Provider");
  }
  return context;
}

