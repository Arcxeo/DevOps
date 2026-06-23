<<<<<<< HEAD
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
=======
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
>>>>>>> 2f33162d6da5a0e1d9219c8d2315db3716c4d6ad
