import UserForm from '../../partials/UserForm';
import ObjectEdit from '../../hoc/EditObject';

const UserEdit = ObjectEdit({ type: 'user', Form: UserForm });

export default UserEdit;