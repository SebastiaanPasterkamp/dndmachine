import opa from "@open-policy-agent/opa-wasm";

export default async function getPolicy(input, query, data) {
  return fetch('/ui/policy.wasm')
    .then(response => response.arrayBuffer())
    .then(wasm => opa.loadPolicy(wasm))
    .then(policy => {
      policy.setData(data);
      const rules = policy.evaluate(input, query);
      for (const i in rules) {
        if (rules[i].result) {
          return true
        }
      }
      return false
    })
}
