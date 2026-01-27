import { exec } from "node:child_process";

exec("npm ci", (error, stdout, stderr) => {
	if (error) {
		console.error(`Error during npm ci: ${error.message}`);
		return;
	}
	if (stderr) {
		console.error(`npm ci stderr: ${stderr}`);
		return;
	}
	console.log(`npm ci stdout: ${stdout}`);
});

exec("npm run prepare", (error, stdout, stderr) => {
	if (error) {
		console.error(`Error during npm run prepare: ${error.message}`);
		return;
	}
	if (stderr) {
		console.error(`npm run prepare stderr: ${stderr}`);
		return;
	}
	console.log(`npm run prepare stdout: ${stdout}`);
});
