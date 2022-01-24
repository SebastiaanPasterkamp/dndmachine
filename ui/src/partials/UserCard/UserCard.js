import * as React from 'react';
import PropTypes from 'prop-types';
import Avatar from '@mui/material/Avatar';
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import CardContent from '@mui/material/CardContent';
import Chip from '@mui/material/Chip';
import EmailIcon from '@mui/icons-material/Email';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import GroupsIcon from '@mui/icons-material/Groups';
import IconButton from '@mui/material/IconButton';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import MoreVertIcon from '@mui/icons-material/MoreVert';
import Skeleton from '@mui/material/Skeleton';
import { faWizardsOfTheCoast } from '@fortawesome/free-brands-svg-icons/faWizardsOfTheCoast';

import { stringToInitials, stringToColor } from '../../utils';

export default function UserCard(props) {
  const { id, username, name, email, role, dci } = props;
  const loading = id === undefined;
  const displayName = name ? name : username;

  return (
    <Card sx={{ maxWidth: 345, m: 2 }}>
      <CardHeader
        avatar={
          loading ? (
            <Skeleton animation="wave" variant="circular" width={40} height={40} />
          ) : (
            <Avatar
              sx={{
                bgcolor: stringToColor(displayName),
              }}
              children={stringToInitials(displayName)}
              aria-label="name"
            />
          )
        }
        title={
          loading ? (
            <Skeleton
              animation="wave"
              height={10}
              width="80%"
              style={{ marginBottom: 6 }}
            />
          ) : (
            displayName
          )
        }
        subheader={
          loading ? (
            <Skeleton animation="wave" height={10} width="40%" />
          ) : (
            username
          )
        }
      />

      <CardContent>
        {loading ? (
          <React.Fragment>
            <Skeleton animation="wave" height={10} style={{ marginBottom: 6 }} />
            <Skeleton animation="wave" height={10} width="80%" />
          </React.Fragment>
        ) : (
          <List
            sx={{ width: '100%', bgcolor: 'background.paper' }}
            aria-label="contacts"
          >
            <ListItem disablePadding>
              <ListItemIcon>
                <EmailIcon />
              </ListItemIcon>
              <ListItemText primary={email} />
            </ListItem>
            <ListItem disablePadding>
              <ListItemIcon>
                <GroupsIcon />
              </ListItemIcon>
              <ListItemText primary={role && role.map((r) => (
                <Chip key={r} label={r} size="small" />
              ))} />
            </ListItem>
            <ListItem disablePadding>
              <ListItemIcon>
                <FontAwesomeIcon icon={faWizardsOfTheCoast} />
              </ListItemIcon>
              <ListItemText primary={dci} secondary="DCI" />
            </ListItem>
          </List>
        )}
      </CardContent>
    </Card>
  );
}

UserCard.propTypes = {
  id: PropTypes.number,
  username: PropTypes.string,
  name: PropTypes.string,
  email: PropTypes.string,
  role: PropTypes.arrayOf(
    PropTypes.string
  ),
  dci: PropTypes.string,
};

UserCard.defaultProps = {
  role: [],
};
