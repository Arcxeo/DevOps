const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("Hello from CI/CD pipeline!");
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "OK" });
});

module.exports = app;

if (require.main === module) {
  app.listen(3000, () => {
    console.log("App running on port 3000");
  });
}