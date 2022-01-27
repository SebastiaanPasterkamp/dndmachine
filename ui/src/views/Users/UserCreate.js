import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import PolicyContext from '../../context/PolicyContext';
import UserForm from '../../partials/UserForm';

export default function UserCreate(props) {
  const navigate = useNavigate();

  const handleDone = (newUser) => {
    console.log({ newUser })
    navigate(`/user/${newUser.id}`);
  }

  return (
    <PolicyContext query={`authz/user/allow`}>
      <UserForm onDone={handleDone} />
    </PolicyContext>
  );
}