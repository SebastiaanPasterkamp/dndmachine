import React, { useMemo } from 'react';
import PropTypes from 'prop-types';
import Button from '@mui/material/Button';
import ButtonGroup from '@mui/material/ButtonGroup';
import Markdown from '../Markdown';
import ListObjects from '../../hoc/ListObjects';
import Tooltip from '@mui/material/Tooltip';
import Typography from '@mui/material/Typography';
import Bonus from '../Bonus/Bonus';

const rows = [
  {
    id: "strength",
    name: "Strength",
    description: "Strength is being able to crush a tomato.",
  }, {
    id: "dexterity",
    name: "Dexterity",
    description: "Dexterity is being able to dodge a tomato.",
  }, {
    id: "constitution",
    name: "Constitution",
    description: "Constitution is being able to eat a bad tomato.",
  }, {
    id: "intelligence",
    name: "Intelligence",
    description: "Intelligence is knowing a tomato is a fruit.",
  }, {
    id: "wisdom",
    name: "Wisdom",
    description: "Wisdom is knowing not to put a tomato in a fruit salad.",
  }, {
    id: "charisma",
    name: "Charisma",
    description: "Charisma is being able to sell a tomato based fruit salad.",
  },
];

export default function StatisticsEdit({ onChange, bonuses, increase, increases, statistics }) {
  const table = useMemo(
    () => rows.map(({ id, name, description }) => ({
      ...statistics[id],
      asi: (bonuses[id] || 0) + (increases[id] || 0),
      increase: increases[id] || 0,
      id, name, description,
    })),
    [statistics, bonuses, increases]
  );

  const columns = useMemo(
    () => {
      var columns = [
        {
          name: 'statistic',
          align: 'left',
          label: 'Statistic',
          render: ({ name, description }) => (
            <Tooltip
              component="div"
              variant="body2"
              title={<Markdown description={description} />}
            >
              <Typography>
                {name}
              </Typography>
            </Tooltip>
          ),
        },
        {
          name: 'base',
          align: 'center',
          label: 'Base',
          render: ({ base }) => base,
        },
        {
          name: 'bonus',
          align: 'center',
          label: 'Bonus',
          render: ({ bonus, asi }) => (
            <>
              <Bonus bonus={bonus} />
              {!!asi && (
                <Bonus bonus={asi} />
              )}
            </>
          ),
        },
      ];

      if (increase) {
        columns.push(
          {
            name: 'increase',
            align: 'center',
            label: 'Increase',
            render: ({ id, increase }) => (
              <ButtonGroup>
                <Button onClick={() => onChange(
                  'increases',
                  (increases) => {
                    const { [id]: increase = 0 } = increases || {};
                    return { ...increases, [id]: increase - 1 };
                  }
                )} />
                <Bonus bonus={increase} />
                <Button onClick={() => onChange(
                  'increases',
                  (increases) => {
                    const { [id]: increase = 0 } = increases || {};
                    return { ...increases, [id]: increase + 1 };
                  }
                )} />
              </ButtonGroup>
            ),
          }
        );
      }

      columns.push(
        {
          name: 'total',
          align: 'center',
          label: 'Total',
          render: ({ total }) => total,
        },
        {
          name: 'modifier',
          align: 'center',
          label: 'Modifier',
          render: ({ modifier }) => (
            <Bonus bonus={modifier} />
          ),
        },
      );

      return columns;
    },
    [increase, onChange]
  );

  return (
    <ListObjects
      title="Ability Scores"
      data={table}
      columns={columns}
      rowsPerPageOptions={[10]}
      rowHeight={10}
    />
  )
}

StatisticsEdit.defaultProps = {
  bonuses: {},
  increases: {},
  increase: 0,
}

StatisticsEdit.propTypes = {
  onChange: PropTypes.func.isRequired,
  statistics: PropTypes.object.isRequired,
  bonuses: PropTypes.objectOf(PropTypes.number),
  increases: PropTypes.objectOf(PropTypes.number),
  increase: PropTypes.number,
};
