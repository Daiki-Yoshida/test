import assert from "node:assert/strict";
import test from "node:test";
import { analyzeText } from "../src/analyze-text.js";
import { formatSummary } from "../src/format-summary.js";

test("summarizes words, lines, and Unicode characters", () => {
  const result = analyzeText("Hello hello\n世界 world", 3);

  assert.equal(result.characters, 20);
  assert.equal(result.words, 4);
  assert.equal(result.lines, 2);
  assert.equal(result.uniqueWords, 3);
  assert.deepEqual(result.topWords, [
    { word: "hello", count: 2 },
    { word: "world", count: 1 },
    { word: "世界", count: 1 },
  ]);
});

test("handles empty text", () => {
  const result = analyzeText("");

  assert.equal(result.characters, 0);
  assert.equal(result.words, 0);
  assert.equal(result.lines, 0);
  assert.deepEqual(result.topWords, []);
  assert.match(formatSummary(result), /Top words: \(none\)/u);
});

test("rejects invalid top-word limits", () => {
  assert.throws(() => analyzeText("hello", -1), RangeError);
  assert.throws(() => analyzeText("hello", 1.5), RangeError);
});
