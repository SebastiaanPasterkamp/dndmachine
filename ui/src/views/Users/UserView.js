import * as React from 'react';
import ObjectView from '../../partials/ObjectView';
import UserCard from '../../partials/UserCard';

export default function UserView() {
  return (
    <ObjectView type="user" component={UserCard} />
  );
}