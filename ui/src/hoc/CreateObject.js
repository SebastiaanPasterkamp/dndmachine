import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import ObjectsContext, { Objects, useObjectsContext } from '../context/ObjectsContext';
import PolicyContext from '../context/PolicyContext';

export default function CreateObject({ type, form: Form, context = [] }) {

  const CreationHandler = function () {
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
        onDone={handleDone}
        onClose={handleClose}
      />
    );
  };

  return function () {
    return (
      <ObjectsContext types={context}>
        <Objects.Consumer>
          {(ctx) => (
            <PolicyContext data={ctx} query={`authz/${type}/allow`}>
              <CreationHandler />
            </PolicyContext>
          )}
        </Objects.Consumer>
      </ObjectsContext>
    );
  }
};