import grpc from "k6/net/grpc";
import { check } from "k6";
import { global_options } from "./settings.js";
export let options = global_options;

const client = new grpc.Client();

client.load(null, "cards.proto");

export default function () {
  const data = {
    merchantId: "kartikey",
    customerId: "hedge",
    cardNo: "4242424242424242",
    cardName: "kritik modi",
    expMo: 2,
    expYr: 24,
  };

  if (__ITER == 0) {
    // active
    client.connect("rust_grpc_server:8080", { timeout: "5s", plaintext: true });
  } // active

  const response = client.invoke("cards.Card/AddCard", {
    merchantId: "kartikey",
    customerId: "hedge",
    cardNo: "4242424242424242",
    cardName: "kritik modi",
    expMo: 2,
    expYr: 24,
  });

  check(response, { "status is OK": (r) => r && r.status === grpc.StatusOK });

  // client.close(); // not-active
}
