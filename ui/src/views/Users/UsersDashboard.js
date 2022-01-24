import * as React from 'react';
import Dashboard from '../../partials/Dashboard';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import { PolicySpeedDialAction } from '../../partials/ProtectedLink';
import SpeedDial from '@mui/material/SpeedDial';
import SpeedDialIcon from '@mui/material/SpeedDialIcon';
import UserCard from '../../partials/UserCard';
import PersonAddIcon from '@mui/icons-material/PersonAdd';

const actions = [
  { icon: <PersonAddIcon />, to: `/user/new`, path: `/api/user`, method: "POST", name: 'New', operation: 'new' },
];

export default function UsersDashboard() {
  return (
    <ObjectsContext types={['user']}>
      <Objects.Consumer>
        {({ user }) => (
          <PolicyContext data={{ user }} query={`authz/user/allow`}>
            <SpeedDial
              ariaLabel="SpeedDial openIcon users"
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

            <Dashboard type="user" component={UserCard} />
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}