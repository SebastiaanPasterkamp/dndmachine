import * as React from 'react';
import Link from '@mui/material/Link';
import Typography from '@mui/material/Typography';

export default function Copyright(props) {
  return (
    <Typography variant="body2" color="text.secondary" align="center" {...props}>
      {'Copyright © '}
      <Link color="inherit" href="https://dndmachine.nl.eu.org">
        D&amp;D Machine
      </Link>
      {' by Sebastiaan Pasterkamp '}
      {new Date().getFullYear()}
      {'.'}
    </Typography>
  );
}
