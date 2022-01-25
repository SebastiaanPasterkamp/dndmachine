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

export default function ObjectView({ component: Component, type, propname }) {
  const { id } = useParams();

  const [error, setError] = React.useState(false);
  const [object, setObject] = React.useState(null);

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    if (object || error) {
      return;
    }

    getObject(type, id)
      .then(data => {
        if (data == null || data.error) {
          setError(true)
        } else {
          setObject(propname
            ? { [propname]: data.result }
            : data.result
          );
        }
      })

    return () => mounted.current = false;
  }, [type, id, error, object, propname])

  if (!object) {
    return null;
  }

  return (
    <Component {...object} />
  );
}