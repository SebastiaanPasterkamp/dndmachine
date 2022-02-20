import * as React from 'react';
import Coinage from '../../partials/Coinage';
import Damage from '../../partials/Damage';
import ListObjects from '../../hoc/ListObjects';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import Typography from '@mui/material/Typography';
import Weight from '../../partials/Weight';

const columns = [
  {
    name: 'name',
    align: 'left',
    label: 'Name',
    sx: { maxWidth: "39vw" },
    render: ({ name, description }) => (
      <>
        {name}
        <Typography noWrap>
          {description}
        </Typography>
      </>
    ),
  },
  {
    name: 'cost',
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
    align: 'right',
    label: 'Armor / Damage',
    sx: { minWidth: "29vw" },
    render: ({ armor, damage, versatile, range }) => (
      <>
        {armor.value}
        <Damage damage={damage} versatile={versatile} />
        <Typography>
          {range.min}
          {range.min <= range.max && ` / ${range.max}`}
        </Typography>
      </>
    ),
  },
];

function order(a, b, orderBy) {
  if (b[orderBy] < a[orderBy]) {
    return -1;
  }
  if (b[orderBy] > a[orderBy]) {
    return 1;
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
