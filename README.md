# tiny-text-inspector

A deliberately small TypeScript CLI for testing GitHub automation. It analyzes text and reports character, word, line, and frequency statistics.

## Requirements

- Node.js 20 or newer
- npm

## Setup

```bash
npm install
npm test
```

## Usage

Analyze a string:

```bash
npm start -- --text "Hello hello, TypeScript!"
```

Analyze a UTF-8 file:

```bash
npm start -- --file ./README.md --top 10
```

## Commands

- `npm run build` — compile TypeScript into `dist/`
- `npm test` — compile and run the Node.js test suite
- `npm start -- ...` — run the compiled CLI

The project has no runtime dependencies. TypeScript and Node.js type definitions are development-only dependencies.
