import PersonAddIcon from '@mui/icons-material/PersonAdd';
import Dialog from '@mui/material/Dialog';
import SpeedDial from '@mui/material/SpeedDial';
import SpeedDialIcon from '@mui/material/SpeedDialIcon';
import * as React from 'react';
import { useNavigate } from 'react-router-dom';
import Dashboard from '../../partials/Dashboard';
import { PolicySpeedDialAction } from '../../partials/ProtectedLink';
import UserCard from '../../partials/UserCard';
import UserForm from '../../partials/UserForm';

export default function UsersDashboard() {
  const navigate = useNavigate();
  const [open, setOpen] = React.useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  const handleDone = (newUser) => {
    navigate(`/user/${newUser.id}`);
  }

  const actions = [
    {
      icon: <PersonAddIcon />,
      onClick: handleOpen,
      to: `/user/new`, path: `/api/user`, method: "POST", name: 'New', operation: 'new'
    },
  ];

  return (
    <>
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
        <UserForm onClose={handleClose} onDone={handleDone} />
      </Dialog>
    </>
  );
}
