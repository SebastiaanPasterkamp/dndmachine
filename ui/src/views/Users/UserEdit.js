import ObjectEdit from '../../hoc/EditObject';
import UserForm from '../../partials/UserForm';

const UserEdit = ObjectEdit({
  type: 'user',
  form: UserForm,
});

export default UserEdit;