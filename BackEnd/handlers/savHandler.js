// SAV (Customer Support) handlers
const { pool } = require('../config');

const addSAVHandler = async (req, res) => {
  const { message, firstName, lastName, email } = req.body;
  if (!firstName || !lastName || !email || !message) {
    return res.status(400).json({ message: 'Missing required fields' });
  }
  try {
    await pool.query(
      'INSERT INTO `sav`(`messageSAV`, `firstNameSAV`, `lastnameSAV`, `mailSAV`, `dateSAV`) VALUES (?, ?, ?, ?, ?)',
      [message, firstName, lastName, email, new Date()]
    );
    res.status(201).json({ message: 'SAV request submitted successfully' });
  } catch (error) {
    console.error('AddSAV error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const getSAVHandler = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM sav ORDER BY dateSAV DESC, idSAV DESC');
    res.json(rows);
  } catch (error) {
    console.error('GetSAV error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const updateStatusSAVHandler = async (req, res) => {
  const { idSAV } = req.params;
  const { status } = req.body;
  if (!status) {
    return res.status(400).json({ message: 'Missing status field' });
  }
  try {
    // map status string to integer stateSAV
    // pending -> 0, in progress -> 1, done -> 2
    let stateValue = 0;
    if (status === 'pending') stateValue = 0;
    else if (status === 'in progress') stateValue = 1;
    else if (status === 'done') stateValue = 2;

    const [result] = await pool.query(
      'UPDATE sav SET stateSAV = ? WHERE idSAV = ?',
      [stateValue, idSAV]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'SAV request not found' });
    }
    res.json({ message: 'SAV request status updated successfully' });
  } catch (error) {
    console.error('UpdateStatusSAV error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

const updateAdminNoteSAVHandler = async (req, res) => {
  const { idSAV } = req.params;
  let { adminNote } = req.body;
  if (!adminNote) {
    return res.status(400).json({ message: 'Missing adminNote field' });
  } else {
    adminNote = `${adminNote} - ${new Date().toLocaleString()}`;
  }
  try {
    const [result] = await pool.query(
      'UPDATE sav SET adminNoteSAV = ? WHERE idSAV = ?',
      [adminNote, idSAV]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'SAV request not found' });
    }
    res.json({ message: 'SAV request admin note updated successfully' });
  } catch (error) {
    console.error('UpdateAdminNoteSAV error:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

module.exports = {
  addSAVHandler,
  getSAVHandler,
  updateStatusSAVHandler,
  updateAdminNoteSAVHandler,
};
