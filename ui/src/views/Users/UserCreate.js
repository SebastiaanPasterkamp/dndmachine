import CreateObject from '../../hoc/CreateObject';
import UserForm from '../../partials/UserForm';

const UserCreate = CreateObject({
  type: 'user',
  form: UserForm,
});

export default UserCreate;