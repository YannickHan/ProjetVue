// Configuration and constants
const pool = require('./db');

const TOKEN = 'WebProjectToken12345';
const PORT = 3000;

const USER_SELECT = `
    SELECT idUser AS id,
      nameUser AS name,
      mailUser AS email,
      passwordUser AS password,
      IF(adminUser = 1, 'admin', 'user') AS role
    FROM User
    `;

module.exports = {
  TOKEN,
  PORT,
  USER_SELECT,
  pool,
};
