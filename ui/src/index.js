import React from 'react';
import ReactDOM from 'react-dom';
import App from './views/App';
import CurrentUserContext from './context/CurrentUserContext'

ReactDOM.render(
  <React.StrictMode>
    <CurrentUserContext>
      <App />
    </CurrentUserContext>
  </React.StrictMode>,
  document.getElementById('root')
);
