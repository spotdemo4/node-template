import { defineConfig } from "rolldown";

export default defineConfig({
	input: "src/index.ts",
	platform: "node",
	tsconfig: true,
	output: {
		dir: "build",
		cleanDir: true,
	},
});
