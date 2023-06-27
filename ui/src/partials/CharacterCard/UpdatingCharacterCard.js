import * as React from 'react';
import { useDnDMachineContext } from '../../context/DnDMachineContext';
import CharacterCard from './CharacterCard';

export default function UpdatingCharacterCard(character) {
  const { characterCompute } = useDnDMachineContext()
  const [updated, setUpdated] = React.useState(character);

  const mounted = React.useRef(true);

  React.useEffect(() => {
    if (!mounted.current) return;
    if (!characterCompute) return;

    characterCompute(character)
      .then((update) => setUpdated(update));

    return () => mounted.current = false;
  }, [characterCompute, character]);

  return (
    <CharacterCard
      {...updated}
    />
  )
}
