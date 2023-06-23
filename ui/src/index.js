import React from 'react';
import ReactDOM from 'react-dom';
import App from './views/App';
import CurrentUserContext from './context/CurrentUserContext'
import PolicyEngineContext from './context/PolicyEngineContext';

ReactDOM.render(
  <React.StrictMode>
    <CurrentUserContext>
      <PolicyEngineContext>
        <App />
      </PolicyEngineContext>
    </CurrentUserContext>
  </React.StrictMode>,
  document.getElementById('root')
);
