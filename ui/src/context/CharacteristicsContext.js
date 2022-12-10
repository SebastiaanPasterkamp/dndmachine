import React, { useSyncExternalStore, useCallback } from 'react';

export const Characteristics = React.createContext({});

export default function CharacteristicsContext({ children }) {
  const [focus, setFocus] = React.useState();
  const [characteristics, setCharacteristics] = React.useState({});
  const [loadings, setLoadings] = React.useState({});

  const listeners = Set();

  const subscribe = (callback) => {
    listeners.add();
    return () => listeners.remove(callback);
  };

  const getCharacteristic = (uuid) => {
    const { [uuid]: characteristic = {} } = characteristics;
    const { [uuid]: loading = false } = loadings;
    return { characteristic, loading };
  }

  const updateCharacteristic = async (uuid, field, change) => setCharacteristics(characteristics => {
    const { [uuid]: characteristic } = characteristics;
    const { [field]: original } = characteristic || {};
    const update = change(original);
    const final = { ...characteristic, [field]: update, };

    listeners.forEach((callback) => callback(uuid, final));

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

export function useSmartCharacteristicsContext(uuid) {
  const { subscribe } = useCharacteristicsContext();

  const callback = useCallback(
    (updated, characteristic) => uuid === updated
      ? characteristic
      : undefined,
    uuid,
  );

  return useSyncExternalStore(subscribe, callback);
}
