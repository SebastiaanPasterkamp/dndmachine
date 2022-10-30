import * as React from 'react';

export const Characteristics = React.createContext({});

export default function CharacteristicsContext({ children }) {
  const mounted = React.useRef(true);

  const [characteristics, setCharacteristics] = React.useState({});
  const [loadings, setLoadings] = React.useState({});

  const getCharacteristic = (uuid) => {
    const { [uuid]: characteristic = {} } = characteristics;
    const { [uuid]: loading = false } = loadings;
    return { characteristic, loading };
  }

  const updateCharacteristic = async (uuid, field, change) => setCharacteristics(characteristics => {
    const { [uuid]: characteristic } = characteristics;
    const { [field]: original } = characteristic || {};
    const update = change(original);

    console.log({ uuid, field, original, update })

    return {
      ...characteristics,
      [uuid]: {
        ...characteristic,
        [field]: update,
      },
    };
  });

  return (
    <Characteristics.Provider value={{ getCharacteristic, updateCharacteristic }}>
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
