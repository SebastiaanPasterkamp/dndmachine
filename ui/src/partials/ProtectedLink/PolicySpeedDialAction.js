import * as React from 'react';
import PropTypes from 'prop-types';
import { useCurrentUserContext } from '../../context/CurrentUserContext'
import SpeedDialAction from '@mui/material/SpeedDialAction';
import { usePolicyContext } from '../../context/PolicyContext'

export default function PolicySpeedDialAction({ to, path, query, method = 'GET', ...rest }) {
  const { user } = useCurrentUserContext()
  const { isAllowed } = usePolicyContext()

  const allowed = isAllowed({
    path: (path || to).replace(/\/\/+/, '/').replace(/^\/+|\/+$/, '').split('/'),
    method,
    user,
  }, query)

  if (!allowed) {
    return null
  }

  return (
    <SpeedDialAction {...rest} />
  )
}

PolicySpeedDialAction.propTypes = {
  to: PropTypes.string.isRequired,
  path: PropTypes.string,
  query: PropTypes.string,
  method: PropTypes.string,
};
