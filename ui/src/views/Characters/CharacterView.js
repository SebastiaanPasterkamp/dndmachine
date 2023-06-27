import * as React from 'react';
import DnDMachineContext from '../../context/DnDMachineContext';
import ObjectsContext, { useObjectsContext } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import { UpdatingCharacterCard } from '../../partials/CharacterCard';
import ObjectView from '../../partials/ObjectView';

export default function CharacterView() {
  return (
    <DnDMachineContext>
      <ObjectsContext types={['character']}>
        <PolicyContext useContext={useObjectsContext} query={`authz/character/allow`}>
          <ObjectView type="character" component={UpdatingCharacterCard} />
        </PolicyContext>
      </ObjectsContext>
    </DnDMachineContext>
  );
}
