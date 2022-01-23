import opa from "@open-policy-agent/opa-wasm";

export default async function getPolicy() {
  return fetch('/ui/policy.wasm')
    .then(response => response.arrayBuffer())
    .then((wasm) => opa.loadPolicy(wasm))
}
