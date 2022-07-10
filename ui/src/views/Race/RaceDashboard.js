import * as React from 'react';
import Badge from '@mui/material/Badge';
import Dashboard from '../../partials/Dashboard';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import AddIcon from '@mui/icons-material/Add';
import PolicyContext from '../../context/PolicyContext';
import { PolicySpeedDialAction } from '../../partials/ProtectedLink';
import { faSnowflake } from '@fortawesome/free-solid-svg-icons/faSnowflake';
import SpeedDial from '@mui/material/SpeedDial';
import SpeedDialIcon from '@mui/material/SpeedDialIcon';
import RaceCard from '../../partials/RaceCard';

export default function RaceDashboard() {
  const actions = [
    {
      icon: (
        <Badge
          anchorOrigin={{ vertical: 'top', horizontal: 'left' }}
          badgeContent={<AddIcon fontSize="small" />}
          overlap="circular"
        >
          <FontAwesomeIcon icon={faSnowflake} />
        </Badge>
      ),
      to: `/race/new`, path: `/api/race`, method: "POST", name: 'New', operation: 'new'
    },
  ];

  return (
    <ObjectsContext types={['race']}>
      <Objects.Consumer>
        {({ race }) => (
          <PolicyContext data={{ race }} query={`authz/race/allow`}>
            <SpeedDial
              ariaLabel="SpeedDial openIcon race"
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

            <Dashboard type="race" component={RaceCard} />
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}
