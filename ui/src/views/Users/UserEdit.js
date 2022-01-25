import * as React from 'react';
import ObjectView from '../../partials/ObjectView';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import UserForm from '../../partials/UserForm';

export default function UserView() {
  return (
    <ObjectsContext types={['user']}>
      <Objects.Consumer>
        {({ user }) => (
          <PolicyContext data={{ user }} query={`authz/user/allow`}>
            <ObjectView type="user" propname="user" component={UserForm} />
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}