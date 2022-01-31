import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import ObjectView from '../../partials/ObjectView';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import UserForm from '../../partials/UserForm';

export default function UserEdit() {
  const navigate = useNavigate();

  const handleDone = (updatedUser) => {
    navigate(`/user/${updatedUser.id}`);
  }

  const userEdit = ({ user }) => {
    const handleClose = () => {
      navigate(`/user/${user.id}`);
    }

    return (
      <UserForm
        user={user}
        onDone={handleDone}
        onClose={handleClose}
      />
    );
  }

  return (
    <ObjectsContext types={['user']}>
      <Objects.Consumer>
        {({ user }) => (
          <PolicyContext data={{ user }} query={`authz/user/allow`}>
            <ObjectView type="user" propName="user" component={userEdit} />
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}