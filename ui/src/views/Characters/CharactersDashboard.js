import SpeedDial from '@mui/material/SpeedDial';
import SpeedDialIcon from '@mui/material/SpeedDialIcon';
import * as React from 'react';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import UpdatingCharacterCard from '../../partials/CharacterCard';
import Dashboard from '../../partials/Dashboard';
import { PolicySpeedDialAction } from '../../partials/ProtectedLink';

import { faUserSecret } from '@fortawesome/free-solid-svg-icons/faUserSecret';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

export default function CharactersDashboard() {
  const actions = [
    {
      icon: <FontAwesomeIcon icon={faUserSecret} />,
      to: `/character/new`,
      path: `/api/character`,
      method: "POST",
      name: 'New',
      operation: 'new',
    },
  ];

  return (
    <ObjectsContext types={['character']}>
      <Objects.Consumer>
        {({ character }) => (
          <PolicyContext data={{ character }} query={`authz/character/allow`}>
            <SpeedDial
              ariaLabel="SpeedDial openIcon characters"
              sx={{ position: 'fixed', bottom: 16, right: 16 }}
              icon={<SpeedDialIcon />}
            >
              {actions.map(({ name, ...rest }) => (
                <PolicySpeedDialAction
                  key={name}
                  tooltipTitle={name}
                  {...rest}
                />
              ))}
            </SpeedDial>

            <Dashboard type="character" component={UpdatingCharacterCard} />
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}
