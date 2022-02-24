import * as React from 'react';
import Armor from '../../partials/Armor';
import Coinage from '../../partials/Coinage';
import Damage from '../../partials/Damage';
import Grid from '@mui/material/Grid';
import ListObjects from '../../hoc/ListObjects';
import Markdown from '../../partials/Markdown';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import Range from '../../partials/Range';
import sortMethod from '../../utils/sortMethod';
import Tooltip from '@mui/material/Tooltip';
import Typography from '@mui/material/Typography';
import Weight from '../../partials/Weight';

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
    sx: { maxWidth: "39vw" },
    render: ({ name, description }) => (
      <>
        {name}
        {description && (
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
        )
        }
      </>
    ),
  },
  {
    name: 'cost',
    sortFields: ['cost', 'value'],
    align: 'right',
    label: 'Cost / Value',
    sx: { minWidth: "15vw" },
    render: ({ cost, value }) => (
      cost
        ? <Coinage {...cost} />
        : <Coinage {...value} />
    ),
  },
  {
    name: 'weight',
    align: 'right',
    label: 'Weight',
    sx: { minWidth: "15vw" },
    render: ({ weight }) => (
      <Weight {...weight} />
    ),
  },
  {
    name: 'attribute',
    sortFields: ['damage', 'versatile', 'range', 'armor'],
    align: 'right',
    label: 'Damage / Armor',
    sx: { minWidth: "15vw" },
    render: ({ armor, damage, versatile, range }) => (
      <Grid container>
        <Grid item xs={12}><Damage damage={damage} versatile={versatile} /></Grid>
        <Grid item xs={12}><Range {...range} /></Grid>
        <Grid item xs={12}><Armor {...armor} /></Grid>
      </Grid>
    ),
  },
];


function order(a, b, sortFields) {
  var i, field;
  for (i = 0, field = sortFields[i]; i < sortFields.length; i++, field = sortFields[i]) {
    const cmp = field in sortMethod
      ? sortMethod[field]
      : sortMethod.default;

    const sort = cmp(a[field], b[field]);
    if (sort === 0) {
      continue;
    }

    return sort
  }

  return 0;
}

export default function EquipmentTable() {
  return (
    <ObjectsContext types={['equipment']}>
      <Objects.Consumer>
        {({ equipment = {} }) => (
          <PolicyContext data={{ equipment }} query={`authz/equipment/allow`}>

            <ListObjects
              title="Equipment"
              data={equipment}
              columns={columns}
              order={order}
            />

          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}
