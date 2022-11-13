import AbilityScore from './AbilityScore';
import CharacteristicConfigs from './CharacteristicConfigs';

const types = {
  'ability-score': {
    id: 'ability-score',
    name: 'Ability Score',
    component: AbilityScore,
  },
  'config': {
    id: 'config',
    name: 'Multiple Features',
    component: CharacteristicConfigs,
  }
};

export default types;