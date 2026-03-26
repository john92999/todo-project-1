// src/config.js
const backendUrl =
  (window._env_ && window._env_.REACT_APP_BACKEND_SERVER_URL) ||
  process.env.REACT_APP_BACKEND_SERVER_URL ||
  "http://localhost:8080";

export default backendUrl;
