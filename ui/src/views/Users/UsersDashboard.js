import * as React from 'react';
import Dashboard from '../../partials/Dashboard/Dashboard';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import UserCard from '../../partials/UserCard';

export default function UsersDashboard() {
  return (
    <ObjectsContext types={['user']}>
      <Objects.Consumer>
        {({ user }) => (
          <PolicyContext data={user} query="user">
            <Dashboard type="user" component={UserCard} />
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}