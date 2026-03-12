const express = require("express");
const app = express();

app.use(express.json());

// HEALTH CHECK (for CodeDeploy)
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', uptime: process.uptime() });
});

// ROOT
app.get('/', (req, res) => {
  res.json({ message: "Orpheus Backend LIVE on port 8080!" });
});

console.log("🚀 Starting WITHOUT MongoDB");

const PORT = process.env.PORT || 8080;  // ← CHANGED: 3000 → 8080

app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server LIVE: http://localhost:${PORT}/health`);
});
