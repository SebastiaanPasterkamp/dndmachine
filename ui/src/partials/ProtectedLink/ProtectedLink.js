import * as React from 'react';
import PropTypes from 'prop-types';
import PolicyContext from '../../context/PolicyContext';
import PolicyLink from './PolicyLink';

export default function ProtectedLink({ data, query, ...rest }) {
  return (
    <PolicyContext data={data} query={`authz/${query}/allow`}>
      <PolicyLink {...rest} />
    </PolicyContext>
  )
}

ProtectedLink.propTypes = {
  to: PropTypes.string.isRequired,
  query: PropTypes.string.isRequired,
  children: PropTypes.any.isRequired,
  data: PropTypes.object,
  method: PropTypes.string,
};
