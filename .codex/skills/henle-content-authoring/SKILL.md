---
name: henle-content-authoring
description: Build or enrich latin_website chapter content from Henle Latin PDFs. Use when asked to pull lesson/vocabulary/grammar material from Henle Latin First Year and Latin Grammar PDFs into content/chapter_NN/lesson.md and reference.yaml while preserving existing exercise order.
---

# Henle Content Authoring

Use this skill when updating `content/chapter_NN/lesson.md` or `reference.yaml` from:

- `/home/scottj/Downloads/Henle Latin First Year -- Robert J_ Henle -- Henle Latin.pdf`
- `/home/scottj/Downloads/Latin grammar -- R_ J_ Henle.pdf`

## Goals

- Preserve the existing lesson/exercise flow in `lesson.md`.
- Do **not** overwrite exercise blocks unless explicitly asked.
- Add only educational explanations, vocabulary, grammar notes, tables, and reading guidance.
- Interleave added lesson material at the same points where the First Year book introduces it, immediately before the related exercise blocks.
- When First Year references numbered Grammar sections, consult the *Latin Grammar* PDF by **grammar number**, not by page number.
- Create or update `reference.yaml` in the style of chapters 1 and 2.
- Summarize and adapt source material; do not copy long passages verbatim.

## Required checks before editing

1. Read examples:
   - `content/chapter_01/lesson.md`
   - `content/chapter_02/lesson.md`
   - `content/chapter_01/reference.yaml`
   - `content/chapter_02/reference.yaml`
2. Read the target chapter file, e.g. `content/chapter_03/lesson.md`.
3. Identify existing exercise headings and their order with `rg`, for example:
   ```bash
   rg -n "^## Exercise|^```exercise" content/chapter_03/lesson.md
   ```
4. Confirm whether the target chapter already has `reference.yaml`.

## PDF/OCR workflow

First try embedded text:

```bash
pdftotext -layout "/home/scottj/Downloads/Henle Latin First Year -- Robert J_ Henle -- Henle Latin.pdf" /tmp/henle_first_year.txt
pdftotext -layout "/home/scottj/Downloads/Latin grammar -- R_ J_ Henle.pdf" /tmp/henle_grammar.txt
```

If the First Year PDF extracts only form feeds or empty text, OCR the relevant page range:

```bash
mkdir -p /tmp/henle_pdf/ocr_pages
for p in $(seq START END); do
  out=/tmp/henle_pdf/ocr_pages/page_${p}
  pdftoppm -f $p -l $p -r 200 -png "/home/scottj/Downloads/Henle Latin First Year -- Robert J_ Henle -- Henle Latin.pdf" "$out"
  img=$(ls ${out}-*.png 2>/dev/null | head -1)
  [ -n "$img" ] && tesseract "$img" "$out" --psm 6 -l eng >/dev/null 2>&1 || true
  rm -f ${out}-*.png
 done
```

Search OCR output:

```bash
rg -n "LESSON 3|THE THIRD DECLENSION|EXERCISE 34|VOCABULARY|Grammar|GRAMMAR" /tmp/henle_pdf/ocr_pages
```

For the grammar PDF, `pdftotext` usually works. Search for grammar section numbers and nearby headings:

```bash
rg -n "^\s*46\b|^\s*57\b|^\s*64\b|Third Declension|Gender" /tmp/henle_grammar.txt
```

## OCR cleanup

Before using extracted PDF text as source material:

- Treat OCR text as provisional, especially vocabulary lists, paradigms, and exercise labels.
- Cross-check Latin vocabulary against nearby paradigms, the grammar PDF, and existing chapter/reference files before restoring macrons.
- Restore macrons only when the form is clear from Henle context or standard morphology, for example `lēx, lēgis`, `flūmen`, or case endings in a printed paradigm.
- Watch for common OCR substitutions: `l`/`1`/`I`, `rn`/`m`, `cl`/`d`, `ﬁ`/`fi`, `ﬂ`/`fl`, `ae`/`æ`, `oe`/`œ`, apostrophes or specks inserted inside Latin words, and hyphenated line breaks.
- Normalize ligatures to plain Latin spelling in content files unless the existing source file intentionally uses a special character.
- Preserve meaningful Latin characters with macrons, but do not invent uncertain vowel length. Prefer an unmarked vowel plus an uncertainty note over a guessed macron.
- Compare suspicious words against the exercise context. OCR often damages inflected endings, so verify case, number, gender, person, tense, and agreement before adding examples.
- Mention unresolved uncertainty in the final response, especially if a macron, proper noun, ending, or vocabulary gloss remains ambiguous.

## Content insertion procedure

For each source section in the First Year book:

1. Locate the next exercise block in the target `lesson.md`.
2. Insert the explanatory lesson material **before** that exercise heading.
3. Keep exercise headings and fenced ```exercise blocks intact.
4. Convert vocabulary to the existing HTML definition-list style in `lesson.md`:
   ```html
   <dl class="vocab-list">
   <dt>lēx, lēgis</dt><dd>law</dd>
   </dl>
   ```
5. Use macrons where they are clear from the source/context. If OCR omits macrons, restore obvious forms carefully.
6. Use tables for declensions and grammar rules where helpful.
7. Include short notes where the book says to refer to Grammar Nos. N-M.

## Reference YAML procedure

Create/update `content/chapter_NN/reference.yaml` with:

```yaml
grammar:
  - title: "..."
    body: |
      Markdown body here.

vocab:
  - latin: "lēx, lēgis"
    english: "law"
    notes: "3rd decl.; like lēx"
```

Reference YAML should include:

- core grammar rules introduced in the chapter;
- numbered Henle Grammar references used by the chapter;
- declension/conjugation tables when relevant;
- all chapter vocabulary introduced before/around the target exercises;
- concise notes such as declension, gender, pattern, or verb person/number.

## Chapter 3 mapping example

For Chapter 3, preserve this flow:

- Before Exercise 34: third declension overview, Grammar Nos. 46-52, `lēx` pattern, first vocabulary.
- Before Exercise 36: appositives and related vocabulary.
- Before Exercise 41: expletive “there” and peace/soldier/road vocabulary.
- Before Exercise 46: Grammar Nos. 58-63, `pars` pattern, `-ium`, related vocabulary.
- Before Exercise 51: review of `lēx` vs `pars`, family/mountain/leader vocabulary.
- Before Exercise 56: Grammar No. 64, neuter third declension, `flūmen` vocabulary.
- Before Exercise 59: review vocabulary and `erat`/`erant`.

## Validation

After edits, always run:

```bash
content_check
```

If available as a tool, use the `content_check` tool instead of shelling out.

Also inspect the diff:

```bash
git diff -- content/chapter_NN/lesson.md content/chapter_NN/reference.yaml
```

## Final response

Report:

- changed files;
- which PDF ranges/grammar numbers were used;
- validation result;
- any OCR uncertainty, especially macrons or ambiguous words.
