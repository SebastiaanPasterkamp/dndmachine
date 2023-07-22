import CreateObject from '../../hoc/CreateObject';
import CharacterEditor from '../../partials/CharacterEditor';

const CharacterCreate = CreateObject({
  type: 'character',
  form: CharacterEditor,
});

export default CharacterCreate;