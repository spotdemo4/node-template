import { exec } from "node:child_process";

exec("npm ci");
exec("npm run prepare");
