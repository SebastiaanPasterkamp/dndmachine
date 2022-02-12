import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import ObjectView from '../partials/ObjectView';
import ObjectsContext, { Objects, useObjectsContext } from '../context/ObjectsContext';
import PolicyContext from '../context/PolicyContext';

export default function EditObject({ type, Form }) {

  const ChangeHandler = function ({ [type]: object }) {
    const navigate = useNavigate();
    const { updateObject } = useObjectsContext();

    const handleClose = () => {
      navigate(`/${type}/${object.id}`);
    }

    const handleDone = () => {
      updateObject(type, object.id);
      handleClose();
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
      <ObjectsContext types={[type]}>
        <Objects.Consumer>
          {({ [type]: object }) => (
            <PolicyContext data={{ [type]: object }} query={`authz/${type}/allow`}>
              <ObjectView type={type} propName={type} component={ChangeHandler} />
            </PolicyContext>
          )}
        </Objects.Consumer>
      </ObjectsContext>
    );
  }
};