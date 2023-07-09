import SpeedDial from '@mui/material/SpeedDial';
import SpeedDialIcon from '@mui/material/SpeedDialIcon';
import * as React from 'react';

import { faUserSecret } from '@fortawesome/free-solid-svg-icons/faUserSecret';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { UpdatingCharacterCard } from '../../partials/CharacterCard';
import Dashboard from '../../partials/Dashboard';
import { PolicySpeedDialAction } from '../../partials/ProtectedLink';

const character = {
  id: 1,
  name: "",
  user_id: 1,
  level: 1,
  choices: {
    "c4826704-86dc-4daf-985b-d4514ece5bc5": { "name": "Testy McTestFace" },
    "867fde51-ed0d-4ec6-bed4-a6e561f08ff4": { "choice": "6a09ab55-21bc-4b87-82a3-e35110c1c3ae" },
  },
}

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
    <>
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

      <UpdatingCharacterCard {...character} />

      <Dashboard type="character" component={UpdatingCharacterCard} />
    </>
  );
}
