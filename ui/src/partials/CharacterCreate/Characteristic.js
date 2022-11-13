import * as React from 'react';
import PropTypes from 'prop-types';
import { useObjectsContext } from '../../context/ObjectsContext';
import BadgedAvatar from '../BadgedAvatar';
import CharacteristicOption from './CharacteristicOption';
import CardHeader from '@mui/material/CardHeader';
import Markdown from '../../partials/Markdown';
import Paper from '@mui/material/Paper';

export default function Characteristic({ sub, name, description, avatar, phases }) {
  const mounted = React.useRef(true);
  const { race: races } = useObjectsContext();
  const [parent, setParent] = React.useState(null);

  React.useEffect(() => {
    mounted.current = true;

    if (!sub) {
      setParent(null);
      return;
    }

    if (races && races[sub]) {
      const { name, avatar } = races[sub];
      if (mounted.current) setParent({ name, avatar });
    }

    return () => mounted.current = false;
  }, [sub, races]);

  return (
    <Paper>
      <CardHeader
        avatar={
          <BadgedAvatar
            name={name}
            avatar={avatar}
            badge={parent}
          />
        }
        title={name}
        subheader={parent?.name}
      />

      <Markdown description={description} />

      {phases ? (
        <CharacteristicOption
          uuid={phases[0]}
        />
      ) : null}
    </Paper>
  )
}

Characteristic.propTypes = {
  name: PropTypes.string,
  sub: PropTypes.number,
  description: PropTypes.string,
  avatar: PropTypes.string,
  phases: PropTypes.arrayOf(PropTypes.string),
};
