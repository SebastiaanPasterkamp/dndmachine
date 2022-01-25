import * as React from 'react';
import PropTypes from 'prop-types';
import { useCurrentUserContext } from '../../context/CurrentUserContext'
import { Link } from 'react-router-dom'
import MenuItem from '@mui/material/MenuItem';
import { usePolicyContext } from '../../context/PolicyContext'

export default function PolicyLink({ to, path, query, method = 'GET', ...rest }) {
  const { user } = useCurrentUserContext()
  const { isAllowed } = usePolicyContext()

  const [allowed, setAllowed] = React.useState(false);

  const mounted = React.useRef(true);

  React.useEffect(() => {
    mounted.current = true;

    const allowed = isAllowed({
      path: (path || to).replace(/\/\/+/, '/').replace(/^\/+|\/+$/, '').split('/'),
      method,
      user,
    }, query);

    setAllowed(allowed);

    return () => mounted.current = false;
  }, [to, path, query, method, user, isAllowed])

  if (!allowed) {
    return null
  }

  return (
    <MenuItem
      component={Link}
      to={to}
      {...rest}
    />
  )
}

PolicyLink.propTypes = {
  to: PropTypes.string.isRequired,
  path: PropTypes.string,
  query: PropTypes.string,
  method: PropTypes.string,
};
