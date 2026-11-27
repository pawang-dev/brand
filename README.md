# pawang-dev/brand

Brand assets for Pawang.dev: logo, mascot, colors, fonts, and decorative elements.

## Layout

| Path | Contents |
| --- | --- |
| `logo/` | Horizontal logo and monogram (light and dark backgrounds), app icon, favicon |
| `mascot/` | Mascot, light background (high-res) and dark-background sticker |
| `colors/` | `tokens.json` (source of truth) and `tokens.css` |
| `fonts/` | Web fonts (`.woff`), `fonts.css`, licenses in `fonts/licenses/` |
| `elements/svg/`, `elements/png/` | Decorative elements, designed for dark backgrounds (`#0B0E14`) |
| `reference/` | Board slices and palette/typography previews. Moodboard only, not for print or production |
| `docs/canva.md` | How to load this kit into Canva |

## Usage rules

- Text on an orange button is Biru Malam (`#14213D`), never white.
- Light background: `*-latar-terang` logo. Dark background: `*-latar-gelap` logo.
- Logo files are raster (PNG). For print, get the original vector logo.

## Consuming from other repos

Raw URL for READMEs: `https://raw.githubusercontent.com/pawang-dev/brand/main/logo/logo-horizontal-latar-gelap.png`

For versioned use, pin to a release tag, not `main`.

## Contributing

Every change follows `AGENTS.md`: issue, branch `<type>/<issue>-<slug>`, PR, review, merge.

One-time setup after cloning:

```bash
git config core.hooksPath .githooks
bash tests/flow.test.sh
```

Repository ruleset: import `.github/ruleset.json` under Settings > Rules > Rulesets, after the first push to `main`.
