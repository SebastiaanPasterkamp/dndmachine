import * as React from 'react';
import RaceFilter from './RaceFilter';
import filterMethod from '../../utils/filterMethod';
import ListObjects from '../../hoc/ListObjects';
import Markdown from '../../partials/Markdown';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import tableOrder from '../../utils/tableOrder';
import Tooltip from '@mui/material/Tooltip';
import Typography from '@mui/material/Typography';

const descStyle = {
  maxHeight: '1.5em',
  overflow: 'hidden',
  textOverflow: 'ellipsis',
};

const columns = [
  {
    name: 'name',
    align: 'left',
    label: 'Name',
    sx: { maxWidth: "15vw" },
    render: ({ name, sub }) => (
      <>
        {name}
        {sub && "Subrace"}
      </>
    ),
  },
  {
    name: 'description',
    align: 'right',
    label: 'Description',
    sx: { maxWidth: "39vw" },
    render: ({ description }) => (
      <Tooltip
        component="div"
        variant="body2"
        title={
          <Markdown description={description} />
        }
      >
        <Typography sx={descStyle}>
          <Markdown description={description} />
        </Typography>
      </Tooltip>
    ),
  },
];

function filter(filter, row) {
  if (!filterMethod.text(filter.text, row.name)) return false;
  if (!filterMethod.text(filter.text, row.description)) return false;

  return true;
}

export default function RaceTable() {
  return (
    <ObjectsContext types={['race']}>
      <Objects.Consumer>
        {({ race = {} }) => (
          <PolicyContext data={{ race }} query={`authz/race/allow`}>

            <ListObjects
              title="Race"
              data={race}
              columns={columns}
              order={tableOrder}
              filter={filter}
              searchForm={RaceFilter}
            />

          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}
