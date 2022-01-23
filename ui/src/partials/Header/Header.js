import * as React from 'react';
import PropTypes from 'prop-types';
import AppBar from '@mui/material/AppBar';
import Avatar from '@mui/material/Avatar';
import { CurrentUserContext } from '../../context/CurrentUser'
import IconButton from '@mui/material/IconButton';
import Menu from '@mui/material/Menu';
import MenuIcon from '@mui/icons-material/Menu';
import MenuItem from '@mui/material/MenuItem';
import ProtectedLink from '../ProtectedLink';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';

import { stringToInitials, stringToColor } from '../../utils';

async function logoutUser(credentials) {
  return fetch('/auth/logout', {
    method: 'GET',
    credentials: 'same-origin',
    headers: {
      'Content-Type': 'application/json'
    },
  })
}

export default function Header({ menuOpen, toggleMenu }) {
  const { user, setUser } = CurrentUserContext();
  const { name, username } = user || {};
  const displayName = name ? name : username;

  const [anchorEl, setAnchorEl] = React.useState(null);

  const handleMenu = (event) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
  };

  const handleLogout = async () => {
    await logoutUser()
    setAnchorEl(null);
    setUser(null);
  };

  return (
    <AppBar position="static">
      <Toolbar>
        <IconButton
          size="large"
          edge="start"
          color="inherit"
          aria-label="menu"
          sx={{ mr: 2, ...(menuOpen && { display: 'none' }) }}
          onClick={toggleMenu(true)}
        >
          <MenuIcon />
        </IconButton>
        <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
          D&amp;D Machine
        </Typography>
        {user && (
          <div>
            <IconButton
              size="large"
              aria-label="account of current user"
              aria-controls="menu-appbar"
              aria-haspopup="true"
              onClick={handleMenu}
              color="inherit"
            >
              <Avatar
                sx={{
                  bgcolor: stringToColor(displayName),
                }}
                children={stringToInitials(displayName)}
                aria-label="name"
              />
            </IconButton>
            <Menu
              id="menu-appbar"
              anchorEl={anchorEl}
              anchorOrigin={{
                vertical: 'top',
                horizontal: 'right',
              }}
              keepMounted
              transformOrigin={{
                vertical: 'top',
                horizontal: 'right',
              }}
              open={Boolean(anchorEl)}
              onClose={handleClose}
            >
              <ProtectedLink to="/user/1">Profile</ProtectedLink>
              <ProtectedLink to="/user/2">Profile</ProtectedLink>
              <MenuItem onClick={handleLogout}>Logout</MenuItem>
            </Menu>
          </div>
        )}
      </Toolbar>
    </AppBar>
  );
}

Header.propTypes = {
  toggleMenu: PropTypes.func.isRequired,
  menuOpen: PropTypes.bool,
};
