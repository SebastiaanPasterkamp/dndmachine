import * as React from 'react';

export const Objects = React.createContext({});

async function getObjects(type) {
  return fetch(`/api/${type}`, {
    method: 'GET',
    credentials: 'same-origin',
  })
    .then(response => {
      if (!response.ok) {
        throw new Error(`${response.status}: ${response.statusText}`);
      }
      return response.json();
    })
    .then(data => data.result)
    .catch((error) => console.error('Error:', error));
}

export default function ObjectsContext({ types, children }) {
  const [objects, setObjects] = React.useState(null);
  const [loading, setLoading] = React.useState(types.reduce((l, t) => ({ ...l, [t]: true }), {}));

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    for (const i in types) {
      const type = types[i];
      getObjects(type)
        .then(result => {
          if (!mounted.current) return;

          setObjects(objects => ({ ...objects, [type]: result.reduce((l, o) => ({ ...l, [o.id]: o }), {}) }));
          setLoading(loading => ({ ...loading, [type]: false }));
        })
        .catch(() => setObjects(objects => ({ ...objects, [type]: {} })))
    }

    return () => mounted.current = false;
  }, [types])

  return (
    <Objects.Provider value={{ loading, ...objects }}>
      {children}
    </Objects.Provider>
  );
}

export function useObjectsContext() {
  const context = React.useContext(Objects);
  if (context === undefined) {
    throw new Error("Context must be used within a Provider");
  }
  return context;
}
