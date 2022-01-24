import * as React from 'react';
import ObjectView from '../../partials/ObjectView';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import UserCard from '../../partials/UserCard';

export default function UserView() {
  return (
    <ObjectsContext types={['user']}>
      <Objects.Consumer>
        {({ user }) => (
          <PolicyContext data={{ user }} query={`authz/user/allow`}>
            <ObjectView type="user" component={UserCard} />
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}