import * as React from 'react';
import Dashboard from '../../partials/Dashboard';
import Dialog from '@mui/material/Dialog';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import { PolicySpeedDialAction } from '../../partials/ProtectedLink';
import SpeedDial from '@mui/material/SpeedDial';
import SpeedDialIcon from '@mui/material/SpeedDialIcon';
import UserCard from '../../partials/UserCard';
import UserForm from '../../partials/UserForm';
import PersonAddIcon from '@mui/icons-material/PersonAdd';

export default function UsersDashboard() {
  const [open, setOpen] = React.useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  const actions = [
    {
      icon: <PersonAddIcon />,
      onClick: handleOpen,
      to: `/user/new`, path: `/api/user`, method: "POST", name: 'New', operation: 'new'
    },
  ];

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

            <Dialog
              open={open}
              onClose={handleClose}
            >
              <UserForm onClose={handleClose} />
            </Dialog>
          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}