import ObjectEdit from '../../hoc/EditObject';
import CharacterEditor from '../../partials/CharacterEditor/CharacterEditor';

const CharacterEdit = ObjectEdit({
  type: 'character',
  form: CharacterEditor,
});

export default CharacterEdit;