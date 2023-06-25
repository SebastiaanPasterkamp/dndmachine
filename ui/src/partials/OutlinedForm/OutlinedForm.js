import React from 'react'
import Box from '@mui/material/Box'

export default function OutlinedForm({ children, ...rest }) {
  return (
    <Box
      component="form"
      autoComplete="off"
      sx={{ px: 1, py: 2 }}
      {...rest}
    >
      {children}
    </Box>
  )
}