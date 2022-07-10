import RaceForm from '../../partials/RaceForm';
import ObjectEdit from '../../hoc/EditObject';

const RaceEdit = ObjectEdit({
  type: 'race',
  form: RaceForm,
  context: ['race'],
});

export default RaceEdit;