import * as React from 'react';
import { getObject } from './ObjectsContext'

export const Character = React.createContext({});

export default function CharacterContext({ id, children }) {
  const mounted = React.useRef(true);

  const [character, setCharacter] = React.useState({});
  const [loading, setLoading] = React.useState(true);

  React.useEffect(() => {
    if (id) {
      setLoading(true);

      getObject('character', id)
        .then(character => {
          if (!mounted.current) return;

          setCharacter(computed(character));
          setLoading(false);
        })
        .catch(() => {
          if (!mounted.current) return;

          setCharacter(computed({}));
          setLoading(false);
        });

    } else {
      setCharacter(computed({}));
      setLoading(false);
    }

    return () => mounted.current = false;
  }, [id]);

  const getDecision = (uuid) => {
    const { decisions } = character;
    const { [uuid]: decision } = decisions || {};
    return decision || {};
  }

  const updateDecision = async (uuid, field, change) => setCharacter(character => {
    const { decisions } = character;
    const { [uuid]: decision } = decisions || {};
    const { [field]: original } = decision || {};
    const update = change(original);

    return computed({
      ...character,
      decisions: {
        ...decisions,
        [uuid]: {
          ...decision,
          [field]: update,
        },
      },
    });
  });

  return (
    <Character.Provider value={{ loading, character, getDecision, updateDecision }}>
      {children}
    </Character.Provider>
  );
}

export function useCharacterContext() {
  const context = React.useContext(Character);
  if (context === undefined) {
    throw new Error("Context must be used within a Provider");
  }
  return context;
}

function computed(character) {
  const fields = ["strength", "dexterity", "constitution", "intelligence", "wisdom", "charisma"];

  const { statistics } = character || {};

  return {
    ...character,
    statistics: Object.fromEntries(fields.map(field => {
      const { [field]: { base, bonus } = {} } = statistics || {};
      const total = (base || 10) + (bonus || 0);
      const modifier = Math.floor((total - 10) / 2);
      return [field, {
        base: base || 10,
        bonus: bonus || 0,
        total,
        modifier,
      }];
    })),
  }
}
