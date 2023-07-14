import { faWizardsOfTheCoast } from '@fortawesome/free-brands-svg-icons/faWizardsOfTheCoast';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import EmailIcon from '@mui/icons-material/Email';
import GroupsIcon from '@mui/icons-material/Groups';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardHeader from '@mui/material/CardHeader';
import Chip from '@mui/material/Chip';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import Skeleton from '@mui/material/Skeleton';
import PropTypes from 'prop-types';
import * as React from 'react';
import { Link } from 'react-router-dom';
import { PolicyLink } from '../ProtectedLink';

import BadgedAvatar from '../BadgedAvatar/BadgedAvatar';

export default function UserCard(props) {
  const { id, username, name, avatar, email, role, dci } = props;
  const loading = id === undefined;
  const displayName = name ? name : username;

  const handleDelete = async (e) => {
    e.preventDefault();

    fetch(`/api/user/${id}`, {
      method: 'DELETE',
      credentials: 'same-origin',
    })
      .then(response => (response.ok ? response.json() : null))
      .catch((error) => console.error('Error:', error));
  }

  return (
    <Card sx={{ maxWidth: 345, m: 2 }}>
      <CardActionArea component={Link} to={`/user/${id}`}>
        <CardHeader
          avatar={
            loading ? (
              <Skeleton animation="wave" variant="circular" width={40} height={40} />
            ) : (
              <BadgedAvatar
                name={displayName}
                avatar={avatar}
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
      </CardActionArea>

      <CardActions style={{ display: "flex", justifyContent: "space-evenly", alignItems: "center" }}>
        <PolicyLink
          to={`/user/${id}`}
          path={`/api/user/${id}`}
          size="small"
          color="primary"
        >
          View
        </PolicyLink>
        <PolicyLink
          to={`/user/${id}/edit`}
          path={`/api/user/${id}`}
          method="PATCH"
          size="small"
          color="secondary"
        >
          Edit
        </PolicyLink>
        <PolicyLink
          to={`/user/${id}`}
          path={`/api/user/${id}`}
          onClick={handleDelete}
          method="DELETE"
          size="small"
          color="warning"
        >
          Delete
        </PolicyLink>
      </CardActions>
    </Card >
  );
}

UserCard.propTypes = {
  id: PropTypes.number,
  username: PropTypes.string,
  name: PropTypes.string,
  avatar: PropTypes.string,
  email: PropTypes.string,
  role: PropTypes.arrayOf(
    PropTypes.string
  ),
  dci: PropTypes.string,
};

UserCard.defaultProps = {
  avatar: "",
  role: [],
};
