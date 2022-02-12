import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import ObjectView from '../../partials/ObjectView';
import ObjectsContext, { Objects, useObjectsContext } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import UserForm from '../../partials/UserForm';

const UserEditHandler = function ({ user }) {
  const navigate = useNavigate();
  const { updateObject } = useObjectsContext();

  const handleClose = () => {
    navigate(`/user/${user.id}`);
  }

  const handleDone = () => {
    updateObject('user', user.id);
    handleClose();
  }

  return (
    <UserForm
      user={user}
      onDone={handleDone}
      onClose={handleClose}
    />
  );
};

export default function UserEdit() {
  return (
    <ObjectsContext types={['user']}>
      <Objects.Consumer>
        {({ user }) => (
          <PolicyContext data={{ user }} query={`authz/user/allow`}>
            <ObjectView type="user" propName="user" component={UserEditHandler} />
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}