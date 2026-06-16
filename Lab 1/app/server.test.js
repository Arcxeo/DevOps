const request = require("supertest");
const app = require("./server");

test("GET / should return hello message", async () => {
  const response = await request(app).get("/");
  expect(response.statusCode).toBe(200);
  expect(response.text).toContain("Hello from CI/CD pipeline!");
});

test("GET /health should return OK", async () => {
  const response = await request(app).get("/health");
  expect(response.statusCode).toBe(200);
  expect(response.body.status).toBe("OK");
});
