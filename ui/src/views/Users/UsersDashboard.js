import * as React from 'react';
import Dashboard from '../../partials/Dashboard/Dashboard';
import ObjectsContext from '../../context/ObjectsContext';
import UserCard from '../../partials/UserCard';

export default function UsersDashboard() {
  return (
    <ObjectsContext types={['user']}>
      <Dashboard type="user" component={UserCard} />
    </ObjectsContext>
  );
}