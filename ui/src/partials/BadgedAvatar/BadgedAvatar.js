import * as React from 'react';
import PropTypes from 'prop-types';
import Avatar from '@mui/material/Avatar';
import Badge from '@mui/material/Badge';

import { stringToInitials, stringToColor } from '../../utils';

export default function BadgedAvatar(props) {
  const { name, avatar, badge, ...rest } = props;

  if (!badge?.name) {
    return (
      <Avatar
        sx={{
          bgcolor: stringToColor(name),
        }}
        children={stringToInitials(name)}
        src={avatar}
        {...rest}
      />
    );
  }

  return (
    <Badge
      anchorOrigin={{
        vertical: 'bottom',
        horizontal: 'right',
      }}
      badgeContent={
        <Avatar
          alt={badge.name}
          src={badge.avatar}
          sx={{ width: 32, height: 32 }}
        />
      }
    >
      <Avatar
        sx={{
          bgcolor: stringToColor(name),
        }}
        children={stringToInitials(name)}
        src={avatar}
        {...rest}
      />
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
