import http from "k6/http";
import { check, sleep } from "k6";

const BASKET_URL = __ENV.BASKET_URL || "http://host.docker.internal:8182";
const VUS = Number(__ENV.VUS || 100);
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

export default function () {
  const body = JSON.stringify({
    accountName: `k6user${__VU}`,
    items: [
      { itemId: "item-10", quantity: 1, unitPrice: 10000.0, itemTitle: "Смартфон", itemNote: "" },
      { itemId: "item-20", quantity: 2, unitPrice: 4990.0, itemTitle: "Колонка", itemNote: "" },
    ],
  });
  const response = http.post(`${BASKET_URL}/api/v1/cart`, body, {
    headers: { "Content-Type": "application/json" },
  });
  check(response, { "status 200": (r) => r.status === 200 });
  sleep(0.5);
}
