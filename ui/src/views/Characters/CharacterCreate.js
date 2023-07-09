import CreateObject from '../../hoc/CreateObject';
import CharacterEditor from '../../partials/CharacterEditor/CharacterEditor';

const CharacterCreate = CreateObject({
  type: 'character',
  form: CharacterEditor,
});

export default CharacterCreate;