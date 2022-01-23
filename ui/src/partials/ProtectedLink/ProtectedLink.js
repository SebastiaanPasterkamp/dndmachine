import * as React from 'react';
import PropTypes from 'prop-types';
import { CurrentUserContext } from '../../context/CurrentUser'
import { Link } from 'react-router-dom'
import MenuItem from '@mui/material/MenuItem';
import getPolicy from './policy'

export default function ProtectedLink({ to, path, query, data, children, method = 'GET', ...rest }) {
  const { user } = CurrentUserContext()

  const [allowed, setAllowed] = React.useState();

  const mounted = React.useRef(undefined);

  React.useEffect(() => {
    mounted.current = true;

    if (allowed !== undefined) {
      return;
    }

    const input = {
      path: (path || to).replace(/\/\/+/, '/').replace(/^\/+|\/+$/, '').split('/'),
      method,
      user,
    }

    getPolicy(input, `authz/${query}/allow`, data)
      .then(allowed => setAllowed(allowed))

    return () => mounted.current = false;
  }, [user, data, to, path, method, query, allowed])

  if (!allowed) {
    return null
  }

  return (
    <MenuItem
      component={Link}
      to={to}
      {...rest}
    >
      {children}
    </MenuItem>
  )
}

ProtectedLink.propTypes = {
  to: PropTypes.string.isRequired,
  data: PropTypes.object,
};
