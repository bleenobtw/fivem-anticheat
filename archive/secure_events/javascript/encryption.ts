import { AES, enc, HmacMD5 } from "crypto-js";

console.log("hello")

globalThis.exports("Encrypt", (event: string) => {
  return enc.Base64.stringify(enc.Utf8.parse(HmacMD5(event, "thisisatest").toString()));
})