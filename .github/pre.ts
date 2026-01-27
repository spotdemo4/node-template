import { execSync } from "node:child_process";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const repo = resolve(__dirname, "..");

const ci = execSync("npm ci", { cwd: repo });
console.log(ci.toString());

const prep = execSync("npm run prepare", { cwd: repo });
console.log(prep.toString());
