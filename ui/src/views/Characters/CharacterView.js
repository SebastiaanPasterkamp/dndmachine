import * as React from 'react';

import { UpdatingCharacterCard } from '../../partials/CharacterCard';
import ObjectView from '../../partials/ObjectView';

export default function CharacterView() {
  return (
    <ObjectView
      type="character"
      component={UpdatingCharacterCard}
    />
  );
}
