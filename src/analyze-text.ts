export interface WordFrequency {
  readonly word: string;
  readonly count: number;
}

export interface TextSummary {
  readonly characters: number;
  readonly charactersWithoutWhitespace: number;
  readonly words: number;
  readonly lines: number;
  readonly uniqueWords: number;
  readonly topWords: readonly WordFrequency[];
}

const WORD_PATTERN = /[\p{L}\p{N}]+(?:['’_-][\p{L}\p{N}]+)*/gu;

export function analyzeText(text: string, topWordLimit = 5): TextSummary {
  if (!Number.isInteger(topWordLimit) || topWordLimit < 0) {
    throw new RangeError("topWordLimit must be a non-negative integer");
  }

  const normalizedWords = [...text.matchAll(WORD_PATTERN)].map((match) =>
    match[0].toLocaleLowerCase(),
  );
  const frequencies = new Map<string, number>();

  for (const word of normalizedWords) {
    frequencies.set(word, (frequencies.get(word) ?? 0) + 1);
  }

  const topWords = [...frequencies.entries()]
    .map(([word, count]) => ({ word, count }))
    .sort((left, right) => right.count - left.count || left.word.localeCompare(right.word))
    .slice(0, topWordLimit);

  return {
    characters: [...text].length,
    charactersWithoutWhitespace: [...text].filter((character) => !/\s/u.test(character)).length,
    words: normalizedWords.length,
    lines: text.length === 0 ? 0 : text.split(/\r?\n/u).length,
    uniqueWords: frequencies.size,
    topWords,
  };
}
