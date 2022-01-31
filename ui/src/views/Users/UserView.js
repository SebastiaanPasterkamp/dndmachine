import * as React from 'react';
import ObjectView from '../../partials/ObjectView';
import ObjectsContext, { useObjectsContext } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import UserCard from '../../partials/UserCard';

export default function UserView() {
  return (
    <ObjectsContext types={['user']}>
      <PolicyContext useContext={useObjectsContext} query={`authz/user/allow`}>
        <ObjectView type="user" component={UserCard} />
      </PolicyContext>
    </ObjectsContext>
  );
}