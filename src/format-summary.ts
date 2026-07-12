import type { TextSummary } from "./analyze-text.js";

export function formatSummary(summary: TextSummary): string {
  const topWords = summary.topWords.length === 0
    ? "(none)"
    : summary.topWords.map(({ word, count }) => `${word}: ${count}`).join(", ");

  return [
    `Characters: ${summary.characters}`,
    `Characters (no whitespace): ${summary.charactersWithoutWhitespace}`,
    `Words: ${summary.words}`,
    `Lines: ${summary.lines}`,
    `Unique words: ${summary.uniqueWords}`,
    `Top words: ${topWords}`,
  ].join("\n");
}
