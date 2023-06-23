import * as React from 'react';
import PropTypes from 'prop-types';
import Button from '@mui/material/Button';
import { useCurrentUserContext } from '../../context/CurrentUserContext'
import { usePolicyContext } from '../../context/PolicyContext'

export default function PolicyButton({ query, method, path, ...props }) {
  const { user } = useCurrentUserContext()
  const { isAllowed } = usePolicyContext()

  const input = {
    path: path.replace(/\/\/+/, '/').replace(/^\/+|\/+$/, '').split('/'),
    method,
    user,
  }
  const allowed = isAllowed(input, query);

  if (!allowed) {
    return null
  }

  return (
    <Button {...props} />
  )
}


PolicyButton.propTypes = {
  path: PropTypes.string.isRequired,
  method: PropTypes.string.isRequired,
  query: PropTypes.string.isRequired,
};
