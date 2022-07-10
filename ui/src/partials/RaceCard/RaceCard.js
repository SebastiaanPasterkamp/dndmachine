import * as React from 'react';
import PropTypes from 'prop-types';
import BadgedAvatar from '../BadgedAvatar';
import Card from '@mui/material/Card';
import CardActions from '@mui/material/CardActions';
import CardActionArea from '@mui/material/CardActionArea';
import CardHeader from '@mui/material/CardHeader';
import CardContent from '@mui/material/CardContent';
import Collapse from '@mui/material/Collapse';
import DescriptionIcon from '@mui/icons-material/Description';
import ExpandMore from '../ExpandMore';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import { Link } from 'react-router-dom'
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import { useObjectsContext } from '../../context/ObjectsContext';
import { PolicyLink } from '../ProtectedLink';
import Skeleton from '@mui/material/Skeleton';

export default function RaceCard(props) {
  const { id, sub, name, description, avatar } = props;

  const mounted = React.useRef(true);
  const { race: races } = useObjectsContext();
  const [parent, setParent] = React.useState(null);
  const loading = id === undefined;

  const [expanded, setExpanded] = React.useState(false);

  const handleExpandClick = () => {
    setExpanded(!expanded);
  };

  const handleDelete = async (e) => {
    e.preventDefault();

    fetch(`/api/race/${id}`, {
      method: 'DELETE',
      credentials: 'same-origin',
    })
      .then(response => (response.ok ? response.json() : null))
      .catch((error) => console.error('Error:', error));
  }

  React.useEffect(() => {
    if (!mounted.current) {
      return () => mounted.current = false;
    }

    if (!sub) {
      setParent(null);
      return;
    }

    if (!races.length) {
      setParent(null);
    }

    const { name, avatar } = races[sub] || {};
    if (mounted.current) {
      setParent({ name, avatar });
    }

    return () => mounted.current = false;
  }, [sub, races])

  return (
    <Card sx={{ maxWidth: 345, m: 2 }}>
      <CardActionArea component={Link} to={`/race/${id}`}>
        <CardHeader
          avatar={
            loading ? (
              <Skeleton animation="wave" variant="circular" width={40} height={40} />
            ) : (
              <BadgedAvatar
                name={name}
                avatar={avatar}
                badge={parent}
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
              name
            )
          }
          subheader={
            loading ? (
              <Skeleton animation="wave" height={10} width="40%" />
            ) : (parent ? parent.name : null)
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
                  <DescriptionIcon />
                </ListItemIcon>
                <Collapse collapsedSize="5em" in={expanded}>
                  <ListItemText primary={description} />
                </Collapse>
              </ListItem>
            </List>
          )}
        </CardContent>
      </CardActionArea>

      <CardActions style={{ display: "flex", justifyContent: "space-evenly", alignItems: "center" }}>
        <PolicyLink
          to={`/race/${id}`}
          path={`/api/race/${id}`}
          size="small"
          color="primary"
        >
          View
        </PolicyLink>
        <PolicyLink
          to={`/race/${id}/edit`}
          path={`/api/race/${id}`}
          method="PATCH"
          size="small"
          color="secondary"
        >
          Edit
        </PolicyLink>
        <PolicyLink
          to={`/race/${id}`}
          path={`/api/race/${id}`}
          onClick={handleDelete}
          method="DELETE"
          size="small"
          color="warning"
        >
          Delete
        </PolicyLink>
        <ExpandMore
          expand={expanded}
          onClick={handleExpandClick}
          aria-expanded={expanded}
          aria-label="show more"
        >
          <ExpandMoreIcon />
        </ExpandMore>
      </CardActions>
    </Card >
  );
}

RaceCard.propTypes = {
  id: PropTypes.number,
  sub: PropTypes.number,
  name: PropTypes.string,
  description: PropTypes.string,
  avatar: PropTypes.string,
};
