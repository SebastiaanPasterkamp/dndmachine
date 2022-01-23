import * as React from 'react';
import PropTypes from 'prop-types';
import { useCurrentUserContext } from '../../context/CurrentUserContext'
import { Link } from 'react-router-dom'
import MenuItem from '@mui/material/MenuItem';
import { usePolicyContext } from '../../context/PolicyContext'

export default function PolicyLink({ to, method = 'GET', ...rest }) {
  const { user } = useCurrentUserContext()
  const { isAllowed } = usePolicyContext()

  const allowed = isAllowed({
    path: to.replace(/\/\/+/, '/').replace(/^\/+|\/+$/, '').split('/'),
    method,
    user,
  })

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
  method: PropTypes.string,
};
