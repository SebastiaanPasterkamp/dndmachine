import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import CardHeader from '@mui/material/CardHeader';
import Skeleton from '@mui/material/Skeleton';
import PropTypes from 'prop-types';
import * as React from 'react';
import { Link } from 'react-router-dom';
import { PolicyLink } from '../ProtectedLink';

import { useObjectsContext } from '../../context/ObjectsContext';
import BadgedAvatar from '../BadgedAvatar/BadgedAvatar';

export default function CharacterCard(props) {
    const { id, user_id, name, avatar, level, classes, ...rest } = props;
    const { user = {} } = useObjectsContext();
    const loading = id === undefined;
    const { [user_id]: owner } = user;
    const badge = owner ? {
        avatar: owner.avatar,
        name: owner.name ? owner.name : owner.username,
    } : undefined;

    const handleDelete = async (e) => {
        e.preventDefault();

        fetch(`/api/character/${id}`, {
            method: 'DELETE',
            credentials: 'same-origin',
        })
            .then(response => (response.ok ? response.json() : null))
            .catch((error) => console.error('Error:', error));
    }

    return (
        <Card sx={{ maxWidth: 345, m: 2 }}>
            <CardActionArea component={Link} to={`/character/${id}`}>
                <CardHeader
                    avatar={
                        loading ? (
                            <Skeleton animation="wave" variant="circular" width={40} height={40} />
                        ) : (
                            <BadgedAvatar
                                name={name}
                                avatar={avatar}
                                badge={badge}
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
                            `${name} - Level ${level}`
                        )
                    }
                    subheader={
                        loading ? (
                            <Skeleton animation="wave" height={10} width="40%" />
                        ) : (
                            Object.values(classes || {}).map(c => `${c.name} ${c.level}`)
                        )
                    }
                />
            </CardActionArea>

            <CardActions style={{ display: "flex", justifyContent: "space-evenly", alignItems: "center" }}>
                <PolicyLink
                    to={`/character/${id}`}
                    path={`/api/character/${id}`}
                    size="small"
                    color="primary"
                >
                    View
                </PolicyLink>
                <PolicyLink
                    to={`/character/${id}/edit`}
                    path={`/api/character/${id}`}
                    method="PATCH"
                    size="small"
                    color="secondary"
                >
                    Edit
                </PolicyLink>
                <PolicyLink
                    to={`/character/${id}`}
                    path={`/api/character/${id}`}
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

CharacterCard.propTypes = {
    id: PropTypes.number,
    user_id: PropTypes.number,
    name: PropTypes.string,
    level: PropTypes.number,
    classes: PropTypes.object,
};

CharacterCard.defaultProps = {
    name: "",
    level: 1,
    classes: {},
};
