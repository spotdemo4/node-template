import assert from "node:assert/strict";
import { test } from "node:test";
import { hello } from "../src/hello.ts";

test("says hello", () => {
	assert.equal(hello(), "Hello, world!");
});
