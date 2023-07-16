import * as React from 'react';
import { useNavigate } from 'react-router-dom';

import { useObjectsContext } from '../context/ObjectsContext';

export default function CreateObject({ type, form: Form }) {

  const CreationHandler = function () {
    const navigate = useNavigate();
    const { updateObject } = useObjectsContext();

    const handleClose = (object) => {
      if (object?.id !== undefined) {
        navigate(`/${type}/${object.id}`);
      } else {
        navigate(`/${type}`);
      }
    }

    const handleDone = (object) => {
      updateObject(type, object.id);
      handleClose(object);
    }

    return (
      <Form
        onDone={handleDone}
        onClose={handleClose}
      />
    );
  };

  return function () {
    return (
      <CreationHandler />
    );
  }
};