import React from 'react';
import PropTypes from 'prop-types';
import Typography from '@mui/material/Typography';

const Bonus = ({ bonus }) => (
    <Typography component="span" data-testid="bonus">
        {`${bonus > 0 ? '+' : ''}${bonus}`}
    </Typography>
);

Bonus.propTypes = {
    bonus: PropTypes.number.isRequired,
};

export default Bonus;