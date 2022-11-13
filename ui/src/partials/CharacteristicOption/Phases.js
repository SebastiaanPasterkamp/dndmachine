import React from 'react';
import PropTypes from 'prop-types';
import Box from '@mui/material/Box';
import { uuidv4 } from '../../utils';
import CharacteristicOption from './CharacteristicOption';
import PlusIcon from '@mui/icons-material/PlusOne';
import Tab from '@mui/material/Tab';
import Tabs from '@mui/material/Tabs';
import { useCharacteristicsContext } from '../../context/CharacteristicsContext';

const Phases = ({ phases, onChange, onSwitch }) => {
  const [tab, setTab] = React.useState(phases[0] || "start");
  const { setFocus, updateCharacteristic } = useCharacteristicsContext();

  const handleTabChange = (_, uuid) => {
    if (uuid === "phase-tab-add") {
      uuid = uuidv4();
      onChange((phases) => ([...(phases || []), uuid]));
      updateCharacteristic(uuid, 'type', () => 'config');
    }

    setTab(uuid);
    setFocus(uuid);
    if (onSwitch) onSwitch(uuid);
  }

  return (
    <span >
      <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
        <Tabs value={tab} onChange={handleTabChange} aria-label="phases tabs">
          {phases.length === 0 ? (
            <Tab
              label="No phases"
              id="start"
              value="start"
              disabled
              data-testid="phase-tab-start"
              aria-controls="phases-tabpanel-start"
            />
          ) : null}
          {phases.map((uuid, index) => (
            <Tab
              label={`Phase ${index}`}
              id={`phase-tab-${uuid}`}
              key={`phase-tab-${uuid}`}
              data-testid={`phase-tab-${uuid}`}
              value={uuid}
              aria-controls={`phases-tabpanel-${index}`}
            />
          ))}
          <Tab
            label={<PlusIcon />}
            id="phase-tab-add"
            value="phase-tab-add"
            data-testid="phase-tab-add"
            aria-controls="phases-tabpanel-add"
          />
        </Tabs>
      </Box>

      {phases.length === 0 ? "" : (
        <CharacteristicOption
          uuid={tab}
          type="config"
        />
      )}
    </span>
  )
};

Phases.propTypes = {
  phases: PropTypes.arrayOf(PropTypes.string).isRequired,
  onChange: PropTypes.func.isRequired,
  onSwitch: PropTypes.func,
};

export default Phases;