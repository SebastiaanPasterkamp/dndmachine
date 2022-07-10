import CreateObject from '../../hoc/CreateObject';
import RaceForm from '../../partials/RaceForm';

const RaceCreate = CreateObject({
  type: 'race',
  form: RaceForm,
  context: ['race'],
});

export default RaceCreate;