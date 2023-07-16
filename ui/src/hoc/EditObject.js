import * as React from 'react';
import { useNavigate } from 'react-router-dom';

import { useObjectsContext } from '../context/ObjectsContext';
import ObjectView from '../partials/ObjectView';

export default function EditObject({ type, form: Form }) {

  const ChangeHandler = function ({ [type]: object }) {
    const navigate = useNavigate();
    const { updateObject } = useObjectsContext();

    const handleClose = (object) => {
      if (object) {
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
        {...{ [type]: object }}
        onDone={handleDone}
        onClose={handleClose}
      />
    );
  };

  return function () {
    return (
      <ObjectView
        type={type}
        propName={type}
        component={ChangeHandler}
      />
    );
  }
};