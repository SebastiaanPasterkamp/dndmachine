import * as React from 'react';

const CurrentUser = React.createContext({});

async function currentUser() {
  return fetch('/auth/current-user', {
    method: 'GET',
    credentials: 'same-origin',
  })
    .then(response => {
      if (!response.ok) {
        return null;
      }
      return response.json();
    })
    .catch((error) => {
      console.error('Error:', error);
    });
}

export default function CurrentUserContext({ children }) {
  const [user, setUser] = React.useState(null);

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    currentUser()
      .then(user => {
        if (!mounted.current) return;

        setUser(user);
      })

    return () => mounted.current = false;
  }, [])

  return (
    <CurrentUser.Provider value={{ user, setUser }}>
      {children}
    </CurrentUser.Provider>
  );
}

export function useCurrentUserContext() {
  const context = React.useContext(CurrentUser);
  if (context === undefined) {
    throw new Error("Context must be used within a Provider");
  }
  return context;
}
