import * as React from 'react';
import PropTypes from 'prop-types';
import IconButton from '@mui/material/IconButton';
import { styled } from '@mui/material/styles';

const ExpandMore = styled(({ expand, ...rest }) => {
  return <IconButton {...rest} />;
})(({ theme, expand }) => ({
  transform: !expand ? 'rotate(0deg)' : 'rotate(180deg)',
  marginLeft: 'auto',
  transition: theme.transitions.create('transform', {
    duration: theme.transitions.duration.shortest,
  }),
}));

ExpandMore.propTypes = {
  ...IconButton.propTypes,
  expand: PropTypes.bool.isRequired,
}

export default ExpandMore;