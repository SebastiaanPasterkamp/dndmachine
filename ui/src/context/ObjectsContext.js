import * as React from 'react';

const Objects = React.createContext({});

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
    .then(data => data.results)
    .catch((error) => console.error('Error:', error));
}

async function getObject(type, id) {
  return fetch(`/api/${type}/${id}`, {
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
  const mounted = React.useRef(true);

  const [objects, setObjects] = React.useState(null);
  const [loading, setLoading] = React.useState(types.reduce((l, t) => ({ ...l, [t]: true }), {}));

  const updateObject = async (type, id) => {
    getObject(type, id)
      .then(object => {
        if (!mounted.current) return;

        setObjects(objects => {
          const { [type]: current } = objects;
          return {
            ...objects,
            [type]: { ...current, [id]: object },
          }
        });
      })
  };

  React.useEffect(() => {
    for (let i = 0; i < types.length; i++) {
      const type = types[i];
      getObjects(type)
        .then(result => {
          if (!mounted.current) return;

          setObjects(objects => ({ ...objects, [type]: result.reduce((l, o) => ({ ...l, [o.id]: o }), {}) }));
          setLoading(loading => ({ ...loading, [type]: false }));
        })
        .catch(() => {
          if (!mounted.current) return;

          setObjects(objects => ({ ...objects, [type]: {} }));
        })
    }

    return () => mounted.current = false;
  }, [types])

  return (
    <Objects.Provider value={{ loading, updateObject, ...objects }}>
      {children}
    </Objects.Provider>
  );
}

function MockObjectsContext({ types, loading: defaultLoading = false, children, ...initial }) {
  const [objects, setObjects] = React.useState(initial);
  const [loading, setLoading] = React.useState(types.reduce((l, t) => ({ ...l, [t]: defaultLoading }), {}));

  const updateObject = async (type, id) => {
    setObjects(objects => {
      const { [type]: current } = objects;
      return {
        ...objects,
        [type]: { ...current, [id]: object },
      }
    });
  };

  return (
    <Objects.Provider value={{ loading, updateObject, ...objects }}>
      {children}
    </Objects.Provider>
  );
}

function useObjectsContext() {
  const context = React.useContext(Objects);
  if (context === undefined) {
    throw new Error("Context must be used within a Provider");
  }
  return context;
}

export {
  MockObjectsContext, Objects, getObject,
  getObjects, useObjectsContext
};

