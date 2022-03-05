import * as React from 'react';
import BackspaceIcon from '@mui/icons-material/Backspace';
import Button from '@mui/material/Button';
import Grid from '@mui/material/Grid';
import OutlinedForm, { OutlinedInput, OutlinedRangeSlider } from '../../partials/OutlinedForm';
import SearchIcon from '@mui/icons-material/Search';
import useFormHelper from '../../utils/formHelper';

const defaultFilters = {
  text: "",
  armor: { min: 0, max: 0 },
  damage: { min: 0, max: 0 },
  value: { min: 0, max: 0 },
  weight: { min: 0, max: 0 },
};

const unset = ["∅", "∞"];

const max = {
  armor: 21,
  damage: 22,
  value: 51,
  weight: 76,
};

const marks = {
  armor: [
    { value: 1, label: '+1AC' },
    { value: 5, label: '+5AC' },
    { value: 10, label: '10AC' },
    { value: 15, label: '15AC' },
    { value: 20, label: '20AC' },
  ],
  damage: [
    { value: 1, label: '1' },
    { value: 2.5, label: '1d4' },
    { value: 4.5, label: '1d8' },
    { value: 6.5, label: '1d12' },
    { value: 10.5, label: '1d20' },
    { value: 13, label: '2d12' },
    { value: 21, label: '2d20' },
  ],
  value: [
    { value: 1, label: '1cp' },
    { value: 10, label: '1sp' },
    { value: 20, label: '1gp' },
    { value: 30, label: '1pp' },
    { value: 40, label: '10pp' },
    { value: 50, label: '100pp' },
  ],
  weight: [
    { value: 1, label: '1lb.' },
    { value: 25, label: '25lb.' },
    { value: 50, label: '50lb.' },
    { value: 75, label: '75lb.' },
  ],
};

const dice_sizes = [4, 6, 8, 10, 12, 20, 100];

const text = {
  armor: (step, activeThumb) => {
    if (step === 0 || step >= max.armor) {
      return unset[activeThumb];
    }

    return `${step < 10 ? '+' : ''}${step}AC`;
  },
  damage: (step, activeThumb) => {
    if (step === 0 || step >= max.damage) {
      return unset[activeThumb];
    }

    var dice = '';
    if (step > 2) {
      for (var dice_count = 1; dice_count <= 3; dice_count++) {
        if ((step / dice_count) % 1 === 0.5) {
          const dice_size = (step / dice_count) * 2 - 1;
          if (dice_size in dice_sizes) {
            dice = ` (${dice_count}d${dice_size})`;
          }
        }
      }
    }

    return `x̄${step}${dice}`;
  },
  value: (step, activeThumb) => {
    if (step === 0 || step >= max.value) {
      return unset[activeThumb];
    }

    var coin = '', value = step;
    for (var i = 0; i < stepValues.length; i++) {
      const { label, mark } = stepValues[i];
      if (step > mark) {
        value = step - mark;
        coin = label;
        break;
      }
    }

    return `${value}${coin}`;
  },
  weight: (step, activeThumb) => {
    if (step === 0 || step >= max.weight) {
      return unset[activeThumb];
    }

    return `${step}lb.`;
  },
};

const minMax = ({ min, max }, maxDefault) => {
  return ([min, max || maxDefault]);
};

const minMaxValue = ({ min, max }) => {
  return ([
    valueToStep(min, 0),
    valueToStep(max, 1),
  ]);
};

const stepValues = [
  { label: '0pp', mark: 40, value: 10000 },
  { label: 'pp', mark: 30, value: 1000 },
  { label: 'gp', mark: 20, value: 100 },
  { label: 'sp', mark: 10, value: 10 },
  { label: 'cp', mark: 1, value: 1 },
];

const stepToValue = (step) => {
  if (step === 0 || step >= max.value) {
    return 0;
  }

  for (var i = 0; i < stepValues.length; i++) {
    const { mark, value } = stepValues[i];
    if (step > mark) {
      return (step - mark) * value;
    }
  }

  return step;
}

const valueToStep = (step, activeThumb) => {
  if (step === 0) {
    return max.value * activeThumb;
  }

  for (var i = 0; i < stepValues.length; i++) {
    const { mark, value } = stepValues[i];
    if (step > value) {
      return step / value + mark;
    }
  }

  return step;
}

export default function EquipmentFilter({ onFilter, onClose }) {
  const {
    values,
    handleInputChange,
  } = useFormHelper(defaultFilters, null, false)

  const handleMinMaxChange = (defaultMax) => (e) => {
    var [min, max] = e.target.value;
    if (max >= defaultMax) max = 0;
    e.target.value = { min, max };
    handleInputChange(e);
  }

  const handleMinMaxValueChange = (e) => {
    var [min, max] = e.target.value;
    min = stepToValue(min);
    max = stepToValue(max);
    e.target.value = { min, max };
    handleInputChange(e);
  }

  const handleClear = async (e) => {
    e.preventDefault();
    onFilter(defaultFilters);
    onClose();
  }

  const handleFilter = async (e) => {
    e.preventDefault();
    onFilter(values);
  }

  return (
    <OutlinedForm onSubmit={onFilter}>
      <Grid container>
        <Grid item xs={12} sm={6} sx={{ px: 1 }}>

          <OutlinedInput
            label="Text"
            name="text"
            value={values.text}
            onChange={handleInputChange}
          />

          <OutlinedRangeSlider
            label="Cost / Value"
            name="value"
            valueLabelDisplay="auto"
            getAriaValueText={text.value}
            valueLabelFormat={text.value}
            step={1}
            disableSwap
            marks={marks.value}
            value={minMaxValue(values.value)}
            min={0}
            max={max.value}
            onChange={handleMinMaxValueChange}
          />
        </Grid>

        <Grid item xs={12} sm={6} sx={{ px: 1 }}>
          <OutlinedRangeSlider
            label="Weight"
            name="weight"
            valueLabelDisplay="auto"
            getAriaValueText={text.weight}
            valueLabelFormat={text.weight}
            step={1 / 16}
            disableSwap
            marks={marks.weight}
            value={minMax(values.weight, max.weight)}
            min={0}
            max={max.weight}
            onChange={handleMinMaxChange(max.weight)}
          />

          <OutlinedRangeSlider
            label="Armor"
            name="armor"
            valueLabelDisplay="auto"
            getAriaValueText={text.armor}
            valueLabelFormat={text.armor}
            step={1}
            disableSwap
            marks={marks.armor}
            value={minMax(values.armor, max.armor)}
            min={0}
            max={max.armor}
            onChange={handleMinMaxChange(max.armor)}
          />

          <OutlinedRangeSlider
            label="Damage"
            name="damage"
            valueLabelDisplay="auto"
            getAriaValueText={text.damage}
            valueLabelFormat={text.damage}
            step={0.5}
            disableSwap
            marks={marks.damage}
            value={minMax(values.damage, max.damage)}
            min={0}
            max={max.damage}
            onChange={handleMinMaxChange(max.damage)}
          />
        </Grid>

        <Grid item xs={12} style={{ display: "flex", justifyContent: "space-evenly", alignItems: "center" }}>
          <Button
            variant="contained"
            type="submit"
            color="primary"
            onClick={handleFilter}
            startIcon={<SearchIcon />}
          >
            Search
          </Button>
          <Button
            variant="contained"
            type="cancel"
            color="secondary"
            onClick={handleClear}
            startIcon={<BackspaceIcon />}
          >
            Clear
          </Button>
        </Grid>
      </Grid>
    </OutlinedForm>
  );
}
