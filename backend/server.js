const express = require("express");
const path = require('path');
const cors = require("cors");  // Re-enable for ALB

const app = express();

// Middleware
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use(cors());  // Allow ALB traffic

// HEALTH CHECKS (Target Group + Monitoring) 👈 CRITICAL
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'healthy', 
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

app.get('/api/health', (req, res) => {
  res.status(200).json({ api: 'healthy', status: 'ok' });
});

// API ROUTES FIRST (Nginx /api/* proxy)
app.get('/api', (req, res) => {
  res.json({ 
    message: "API Live - Orpheus Backend", 
    endpoints: ['/api/tutorials', '/health'],
    port: process.env.PORT || 3000 
  });
});

// Root route (direct backend access)
app.get("/", (req, res) => {
  res.json({ 
    message: "Welcome to Orpheus Backend API v1.0.0",
    docs: '/api',
    health: '/health'
  });
});

// Database connection
const db = require("./app/models");
db.mongoose
  .connect(db.url, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  })
  .then(() => {
    console.log("✅ Connected to MongoDB!");
  })
  .catch(err => {
    console.error("❌ Database connection failed:", err);
    process.exit(1);
  });

// Load routes AFTER health checks
require("./app/routes/turorial.routes")(app);  // Note: typo? should be "tutorial"?

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  db.mongoose.connection.close(() => {
    process.exit(0);
  });
});

// Production port (CodePipeline + PM2)
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Backend LIVE on port ${PORT}`);
  console.log(`📊 Health: http://localhost:${PORT}/health`);
});
