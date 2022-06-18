import * as React from 'react';
import Armor from '../../partials/Armor';
import Coinage from '../../partials/Coinage';
import Damage from '../../partials/Damage';
import EquipmentFilter from './EquipmentFilter';
import filterMethod from '../../utils/filterMethod';
import Grid from '@mui/material/Grid';
import ListObjects from '../../hoc/ListObjects';
import Markdown from '../../partials/Markdown';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import Range from '../../partials/Range';
import tableOrder from '../../utils/tableOrder';
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
        )}
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

function filter(filter, row) {
  if (!filterMethod.text(filter.text, row.name)) return false;
  if (!filterMethod.text(filter.text, row.description)) return false;
  if (!(
    filterMethod.cost(filter.value, row.cost)
    || filterMethod.cost(filter.value, row.value)
  )) return false;
  if (!(
    filterMethod.damage(filter.damage, row.damage)
    || filterMethod.damage(filter.damage, row.versatile)
  )) return false;
  if (!filterMethod.weight(filter.weight, row.weight)) return false;
  if (!filterMethod.armor(filter.armor, row.armor)) return false;

  return true;
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
              order={tableOrder}
              filter={filter}
              searchForm={EquipmentFilter}
            />

          </PolicyContext>
        )}
      </Objects.Consumer>
    </ObjectsContext>
  );
}
