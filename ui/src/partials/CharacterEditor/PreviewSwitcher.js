import TabContext from '@mui/lab/TabContext';
import TabList from '@mui/lab/TabList';
import TabPanel from '@mui/lab/TabPanel';
import Box from '@mui/material/Box';
import Tab from '@mui/material/Tab';
import * as React from 'react';

import { useCurrentUserContext } from '../../context/CurrentUserContext';
import useFormHelper from '../../utils/formHelper';
import UpdatingCharacterCard from '../CharacterCard/UpdatingCharacterCard';
import CharacterEditor from './CharacterEditor';

const defaultCharacter = {
  name: "",
  avatar: "",
  level: 1,
  choices: {},
}

export default function PreviewSwitcher({ character, onClose, onDone }) {
  const { user } = useCurrentUserContext();

  const {
    values,
    setValues,
    isValid,
    resetForm,
  } = useFormHelper({ user_id: user.id, ...defaultCharacter, ...character }, () => ({}), false)

  const [tab, setTab] = React.useState("create");

  const handleChange = (event, newTab) => {
    setTab(newTab);
  };

  return (
    <TabContext value={tab}>
      <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
        <TabList onChange={handleChange} aria-label="Character creation and preview" centered>
          <Tab label="Create" value="create" />
          <Tab label="Preview" value="preview" />
        </TabList>
      </Box>
      <TabPanel value="create">
        <CharacterEditor
          values={values}
          setValues={setValues}
          isValid={isValid}
          onClose={onClose}
          onDone={onDone}
          resetForm={resetForm}
        />
      </TabPanel>
      <TabPanel value="preview">
        <UpdatingCharacterCard {...values} />
      </TabPanel>
    </TabContext>
  )
}
