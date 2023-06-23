import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import ObjectView from '../partials/ObjectView';
import ObjectsContext, { Objects, useObjectsContext } from '../context/ObjectsContext';
import PolicyContext from '../context/PolicyContext';

export default function EditObject({ type, form: Form, context = [] }) {

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
      <ObjectsContext types={[type, ...context]}>
        <Objects.Consumer>
          {(ctx) => (
            <PolicyContext data={ctx} query={`authz/${type}/allow`}>
              <ObjectView
                type={type}
                propName={type}
                component={ChangeHandler}
              />
            </PolicyContext>
          )}
        </Objects.Consumer>
      </ObjectsContext>
    );
  }
};