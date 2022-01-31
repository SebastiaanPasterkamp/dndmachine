import * as React from 'react';
import { useParams } from "react-router-dom";

async function getObject(type, id) {
  return fetch(`/api/${type}/${id}`, {
    method: 'GET',
    credentials: 'same-origin',
  })
    .then(response => {
      if (!response.ok) {
        return null;
      }
      return response.json()
    })
    .catch((error) => {
      console.error('Error:', error);
    });
}

export default function ObjectView({ component: Component, type, propName }) {
  const { id } = useParams();

  const [error, setError] = React.useState(false);
  const [object, setObject] = React.useState(null);

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    getObject(type, id)
      .then(data => {
        if (!mounted.current) return;

        if (data == null || data.error) {
          setError(true)
          return;
        }

        setObject(propName
          ? { [propName]: data.result }
          : data.result
        );
      })

    return () => mounted.current = false;
  }, [type, id, propName])

  if (!object) {
    return null;
  }

  if (error) {
    return null;
  }

  return (
    <Component {...object} />
  );
}
