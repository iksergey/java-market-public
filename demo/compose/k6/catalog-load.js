import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.BASE_URL || "http://host.docker.internal:8181";
const VUS = Number(__ENV.VUS || 1000);
const HOLD = __ENV.HOLD || "8m";

export const options = {
  stages: [
    { duration: "1m", target: VUS },
    { duration: HOLD, target: VUS },
    { duration: "1m", target: 0 },
  ],
  thresholds: {
    http_req_failed: ["rate<0.05"],
    http_req_duration: ["p(95)<800"],
  },
};

const PAGES = [
  `${BASE_URL}/api/v1/items`,
  `${BASE_URL}/api/v1/brands`,
  `${BASE_URL}/api/v1/categories`,
  `${BASE_URL}/api/v2/items`,
  `${BASE_URL}/api/v1/items/missing-item`,
];

export default function () {
  const url = PAGES[Math.floor(Math.random() * PAGES.length)];
  const response = http.get(url);
  check(response, { "status 200 or 404": (r) => r.status === 200 || r.status === 404 });
  sleep(2 + Math.random() * 2);
}
