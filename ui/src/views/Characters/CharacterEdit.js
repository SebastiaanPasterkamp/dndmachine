import ObjectEdit from '../../hoc/EditObject';
import PreviewSwitcher from '../../partials/CharacterEditor/PreviewSwitcher';

const CharacterEdit = ObjectEdit({
  type: 'character',
  form: PreviewSwitcher,
});

export default CharacterEdit;