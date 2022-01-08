import * as React from 'react';
import Container from '@mui/material/Container';
import Grid from '@mui/material/Grid';
import Link from '@mui/material/Link';
import Typography from '@mui/material/Typography';

import Copyright from '../Copyright';

const footers = [
  {
    title: 'Legal',
    items: [
      {title: 'Project License', link: 'https://github.com/SebastiaanPasterkamp/dndmachine/blob/master/LICENSE'},
      {title: 'Privacy Policy', link: '/privacy-policy'},
      {title: 'Source Code', link: 'https://github.com/SebastiaanPasterkamp/dndmachine'},
    ],
  },
  {
    title: 'External',
    items: [
      {title: 'Basic Rules for D&D', link: 'http://dnd.wizards.com/articles/features/basicrules'},
      {title: 'D&D Adventurers League', link: 'https://dnd.wizards.com/playevents/organized-play'},
    ],
  },
];

function Column({ title, items }) {
  return (
    <Grid item xs={12} sm={4} key={title}>
      <Typography variant="h6" color="text.primary" gutterBottom>
        {title}
      </Typography>
      <ul>
        {items.map((item) => (
          <li key={item.title}>
            <Link href={item.link} variant="subtitle1" color="text.secondary">
              {item.title}
            </Link>
          </li>
        ))}
      </ul>
    </Grid>
  )
}

export default function Footer() {
  return (
    <Container
      maxWidth="max"
      component="footer"
      sx={{
        bgcolor: 'primary.dark',
        borderTop: (theme) => `1px solid ${theme.palette.divider}`,
        mt: 8,
        py: [3, 6],
      }}
    >
      <Grid container spacing={4} justifyContent="space-evenly">
        {footers.map(({ title, items }) => (
          <Column
            key={title}
            title={title}
            items={items}
          />
        ))}
      </Grid>
      <Copyright sx={{ mt: 5 }} />
    </Container>
  );
}