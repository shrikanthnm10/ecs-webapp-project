const express = require("express");
const os = require("os");

const app = express();
const PORT = process.env.PORT || 3000;
const ENV = process.env.ENVIRONMENT || "Development";

// API - Health Check (for ALB)
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "UP",
    environment: ENV,
    time: new Date()
  });
});

// API - System Info
app.get("/api/info", (req, res) => {
  res.json({
    app: "Business Web App",
    environment: ENV,
    hostname: os.hostname(),
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    time: new Date()
  });
});

// Beautiful UI Dashboard
app.get("/", (req, res) => {
  res.send(`
  <!DOCTYPE html>
  <html>
  <head>
    <title>Business Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
      body { background-color: #f4f6f9; }
      .card { box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-dark bg-dark">
      <div class="container-fluid">
        <span class="navbar-brand mb-0 h1">My Business App</span>
        <span class="text-white">Environment: ${ENV}</span>
      </div>
    </nav>

    <div class="container mt-5">
      <div class="row">
        <div class="col-md-3">
          <div class="card p-3">
            <h5>Status</h5>
            <p class="text-success">Running</p>
          </div>
        </div>

        <div class="col-md-3">
          <div class="card p-3">
            <h5>Hostname</h5>
            <p>${os.hostname()}</p>
          </div>
        </div>

        <div class="col-md-3">
          <div class="card p-3">
            <h5>Uptime</h5>
            <p>${Math.floor(process.uptime())} seconds</p>
          </div>
        </div>

        <div class="col-md-3">
          <div class="card p-3">
            <h5>Current Time</h5>
            <p>${new Date().toLocaleString()}</p>
          </div>
        </div>
      </div>

      <div class="mt-4">
        <div class="card p-4">
          <h4>About This App</h4>
          <p>This application is deployed using:</p>
          <ul>
            <li>AWS ECS Fargate</li>
            <li>Application Load Balancer</li>
            <li>Docker & ECR</li>
            <li>CloudFormation Infrastructure</li>
          </ul>
        </div>
      </div>

      <div class="mt-4 text-center">
        <a href="/api/info" class="btn btn-primary">View API Info</a>
        <a href="/health" class="btn btn-success">Health Check</a>
      </div>
    </div>
  </body>
  </html>
  `);
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
