import * as React from 'react';
import ListObjects from '../../hoc/ListObjects';
import ObjectsContext, { Objects } from '../../context/ObjectsContext';
import PolicyContext from '../../context/PolicyContext';
import Typography from '@mui/material/Typography';

const columns = [
  {
    name: 'name',
    align: 'left',
    label: 'Name',
    render: ({ name, description }) => (
      <>
        {name}
        <Typography>
          {description}
        </Typography>
      </>
    ),
  },
  {
    name: 'cost',
    align: 'right',
    label: 'Cost / Value',
    render: ({ cost, value }) => (
      <Typography>
        {cost.gp || value.gp} gp
      </Typography>
    ),
  },
  {
    name: 'weight',
    align: 'right',
    label: 'Weight',
    render: ({ weight }) => (
      <Typography>
        {weight.lb} lb.
      </Typography>
    ),
  },
  {
    name: 'attribute',
    align: 'right',
    label: 'Armor / Damage',
    render: ({ armor, damage, versatile, range }) => (
      <>
        {armor.value || damage.type}
        {versatile && ` / ${versatile.type}`}
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
