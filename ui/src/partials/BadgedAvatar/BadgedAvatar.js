import Avatar from '@mui/material/Avatar';
import Badge from '@mui/material/Badge';
import PropTypes from 'prop-types';
import * as React from 'react';

import { stringToColor, stringToInitials } from '../../utils';

export default function BadgedAvatar(props) {
  const { name, avatar, badge, ...rest } = props;

  const avatarProps = {
    alt: name,
    src: avatar,
    sx: {
      bgcolor: stringToColor(name),
    },
    children: stringToInitials(name),
    ...rest
  };

  if (!badge?.name) {
    return (
      <Avatar {...avatarProps} />
    );
  }

  const badgeProps = {
    alt: badge.name,
    src: badge.avatar,
    sx: {
      width: 32,
      height: 32,
      bgcolor: stringToColor(badge.name),
    },
    children: stringToInitials(badge.name),
  };

  return (
    <Badge
      anchorOrigin={{
        vertical: 'bottom',
        horizontal: 'right',
      }}
      badgeContent={
        <Avatar {...badgeProps} />
      }
    >
      <Avatar {...avatarProps} />
    </Badge>
  );
}

BadgedAvatar.propTypes = {
  name: PropTypes.string.isRequired,
  avatar: PropTypes.string,
  badge: PropTypes.shape({
    name: PropTypes.string.isRequired,
    avatar: PropTypes.string,
  }),
};
