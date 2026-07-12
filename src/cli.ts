#!/usr/bin/env node
import { readFile } from "node:fs/promises";
import { analyzeText } from "./analyze-text.js";
import { formatSummary } from "./format-summary.js";

interface CliOptions {
  readonly text: string | undefined;
  readonly file: string | undefined;
  readonly topWordLimit: number;
}

function parseArguments(arguments_: readonly string[]): CliOptions {
  let text: string | undefined;
  let file: string | undefined;
  let topWordLimit = 5;

  for (let index = 0; index < arguments_.length; index += 1) {
    const argument = arguments_[index];
    const value = arguments_[index + 1];

    if (argument === "--text" && value !== undefined) {
      text = value;
      index += 1;
      continue;
    }

    if (argument === "--file" && value !== undefined) {
      file = value;
      index += 1;
      continue;
    }

    if (argument === "--top" && value !== undefined) {
      topWordLimit = Number(value);
      index += 1;
      continue;
    }

    if (argument === "--help") {
      printHelp();
      process.exit(0);
    }

    throw new Error(`Unknown or incomplete argument: ${argument ?? "(missing)"}`);
  }

  if ((text === undefined) === (file === undefined)) {
    throw new Error("Provide exactly one of --text or --file");
  }

  return { text, file, topWordLimit };
}

function printHelp(): void {
  console.log(`tiny-text-inspector\n\nUsage:\n  npm start -- --text \"hello world\"\n  npm start -- --file ./README.md\n\nOptions:\n  --text <value>  Analyze a text argument\n  --file <path>   Analyze a UTF-8 text file\n  --top <number>  Number of frequent words to show (default: 5)\n  --help          Show this help`);
}

async function main(): Promise<void> {
  const options = parseArguments(process.argv.slice(2));
  const text = options.file === undefined
    ? options.text ?? ""
    : await readFile(options.file, "utf8");

  console.log(formatSummary(analyzeText(text, options.topWordLimit)));
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  console.error(`Error: ${message}`);
  process.exitCode = 1;
});
