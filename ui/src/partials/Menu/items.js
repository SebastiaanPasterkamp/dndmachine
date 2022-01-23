import AccountBoxIcon from '@mui/icons-material/AccountBox';
import AdminPanelSettingsIcon from '@mui/icons-material/AdminPanelSettings';
import AutoFixHighIcon from '@mui/icons-material/AutoFixHigh';
import AutoStoriesIcon from '@mui/icons-material/AutoStories';
import ContentPasteIcon from '@mui/icons-material/ContentPaste';
import FormatListBulletedIcon from '@mui/icons-material/FormatListBulleted';
import GavelIcon from '@mui/icons-material/Gavel';
import GroupsIcon from '@mui/icons-material/Groups';
import HomeIcon from '@mui/icons-material/Home';
import PetsIcon from '@mui/icons-material/Pets';
import ShieldIcon from '@mui/icons-material/Shield';
import SportsEsportsIcon from '@mui/icons-material/SportsEsports';
import TranslateIcon from '@mui/icons-material/Translate';

import { faCommentDots } from '@fortawesome/free-solid-svg-icons/faCommentDots';
import { faDAndD } from '@fortawesome/free-brands-svg-icons/faDAndD';
import { faUserSecret } from '@fortawesome/free-solid-svg-icons/faUserSecret';
import { faUtensils } from '@fortawesome/free-solid-svg-icons/faUtensils';

const items = [
  {
    title: "Home",
    icon: HomeIcon,
    to: `/`,
  },
  {
    title: "Admin",
    divider: true,
    icon: AdminPanelSettingsIcon,
    to: `/admin`
  },
  {
    title: "Users",
    icon: AccountBoxIcon,
    to: `/user`
  },
  {
    title: "Dungeon Master",
    divider: true,
    icon: GavelIcon,
    to: `/dungeon-master`,
  },
  {
    title: "Monsters",
    icon: PetsIcon,
    to: `/monster`,
  },
  {
    title: "NPCs",
    faIcon: faCommentDots,
    to: `/npc`,
  },
  {
    title: "Encounters",
    icon: SportsEsportsIcon,
    to: `/encounter`,
  },
  {
    title: "Campaigns",
    icon: AutoStoriesIcon,
    to: `/campaign`,
  },
  {
    title: "Characters",
    divider: true,
    faIcon: faUserSecret,
    to: `/character`,
  },
  {
    title: "Session",
    icon: ContentPasteIcon,
    to: `/session-log`,
  },
  {
    title: "Adventure League",
    faIcon: faDAndD,
    to: `/adventure-league`,
  },
  {
    title: "Parties",
    icon: GroupsIcon,
    to: `/party`,
  },
  {
    title: "Items",
    divider: true,
    icon: FormatListBulletedIcon,
    to: `/item`,
  },
  {
    title: "Spells",
    icon: AutoFixHighIcon,
    to: `/spell`,
  },
  {
    title: "Languages",
    icon: TranslateIcon,
    to: `/language`,
  },
  {
    title: "Weapons",
    faIcon: faUtensils,
    to: `/weapon`,
  },
  {
    title: "Armor",
    icon: ShieldIcon,
    to: `/armor`,
  },
];

export default items;