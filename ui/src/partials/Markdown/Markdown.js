import * as React from 'react';
import PropTypes from 'prop-types';
import ReactMarkdown from 'react-markdown';
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles({
  markdown: {
    '&> p': {
      margin: 0,
      padding: 0,
    },
  }
});

export default function Markdown({ description }) {
  const classes = useStyles();

  if (!description) {
    return null;
  }

  return (
    <ReactMarkdown className={classes.markdown}>
      {description}
    </ReactMarkdown>
  );
}

Markdown.propTypes = {
  description: PropTypes.string,
};
