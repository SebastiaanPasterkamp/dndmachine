import * as React from 'react';
import Box from '@mui/material/Box';
import Divider from '@mui/material/Divider';
import Drawer from '@mui/material/Drawer';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import List from '@mui/material/List';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import PolicyContext from '../../context/PolicyContext';
import { PolicyLink } from '../ProtectedLink';

import items from './items';

export default function Menu({ menuOpen, toggleMenu }) {
  return (
    <Drawer
      anchor='left'
      open={menuOpen}
      onClose={toggleMenu(false)}
    >
      <Box
        sx={{ width: 250 }}
        role="presentation"
        onClick={toggleMenu(false)}
        onKeyDown={toggleMenu(false)}
      >
        <List>
          <PolicyContext query={`authz/pages/allow`}>
            {items.map(({ title, divider, icon: Icon, faIcon, to }) => (
              <div key={title}>
                {divider ? (<Divider />) : null}
                <PolicyLink to={to}>
                  <ListItemButton >
                    <ListItemIcon>
                      {faIcon
                        ? (<FontAwesomeIcon icon={faIcon} />)
                        : <Icon />
                      }
                    </ListItemIcon>
                    <ListItemText>
                      {title}
                    </ListItemText>
                  </ListItemButton>
                </PolicyLink>
              </div>
            ))}
          </PolicyContext>
        </List>
      </Box>
    </Drawer >
  );
}
