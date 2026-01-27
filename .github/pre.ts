import { execSync } from "node:child_process";

const ls = execSync("ls -Rla");
console.log(ls.toString());

execSync("npm ci");
execSync("npm run prepare");
