import * as React from 'react';
import PropTypes from 'prop-types';
import { CurrentUserContext } from '../../context/CurrentUser'
import { Link } from 'react-router-dom'
import MenuItem from '@mui/material/MenuItem';
import getPolicy from './policy'

export default function ProtectedLink({ to, data, children, ...rest }) {
  const { user } = CurrentUserContext()

  const [allowed, setAllowed] = React.useState();

  const mounted = React.useRef(undefined);

  React.useEffect(() => {
    mounted.current = true;

    if (allowed !== undefined) {
      return;
    }

    getPolicy().then(policy => {
      policy.setData(data)

      const input = {
        path: to.trim('/').split('/'),
        method: 'GET',
        user,
      }

      const result = policy.evaluate(input)

      setAllowed(result)
    })

    return () => mounted.current = false;
  }, [user, data, to, allowed])

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
