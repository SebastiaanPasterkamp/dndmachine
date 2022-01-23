import React from 'react';
import ReactDOM from 'react-dom';
import App from './views/App';
import CurrentUserProvider from './context/CurrentUser'

ReactDOM.render(
  <React.StrictMode>
    <CurrentUserProvider>
      <App />
    </CurrentUserProvider>
  </React.StrictMode>,
  document.getElementById('root')
);
