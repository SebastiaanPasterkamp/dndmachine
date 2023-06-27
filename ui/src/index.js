import React from 'react';
import ReactDOM from 'react-dom';
import CurrentUserContext from './context/CurrentUserContext';
import PolicyEngineContext from './context/PolicyEngineContext';
import App from './views/App';

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
