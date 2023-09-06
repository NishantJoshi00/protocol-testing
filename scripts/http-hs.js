import http from "k6/http";
import { check } from "k6";
import { global_options } from "./settings.js";
export let options = global_options;

export default function () {
  const data = {
    merchantId: "kartikey",
    customerId: "hedge",
    cardNo: "4242424242424242",
    cardName: "kritik modi",
    expMo: 2,
    expYr: 24,
  };
  const response = http.post(
    "http://haskell_http_server:8080/cards",
    JSON.stringify(data),
    {
      headers: { "Content-Type": "application/json" },
    },
  );
  check(response, { "status is 200": (r) => r.status === 200 });
}
