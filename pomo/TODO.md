# Elmify Lock Stock Pomodoros

Execution checklist. The reasoning lives in [`core-requirements.txt`](core-requirements.txt) —
this file is only *what to do next* and *how we know it worked*.

## The one rule for this file

**This document points at sources. It does not contain code.**

Every step cites a section of `core-requirements.txt` and the real files to read.
Where that document shows code, it is *illustrative* — the canonical source is
always `js/main.js`, `js/chuck.js`, `index.html`, or `~/external-projects/pingolin/pwa/src/`.
Go and read them. A checklist that pastes code becomes a competing source of
truth and the implementation silently drifts to match the summary instead of
the thing.

If a step here contradicts `core-requirements.txt`, the requirements win and
this file is wrong — say so rather than following it.

---

## Constraints discovered (these bind the plan)

- **`pomo/` is an independent project inside the Pages site.** The repo root is
  one level up and hosts unrelated things (`mofoforms/`, `archive/`, `files/`,
  `index.htm`). So everything the Elm build needs — `package.json`, `elm.json`,
  `.gitignore`, `node_modules/`, `elm-stuff/` — lives **in `pomo/`**. Nothing
  about this port should be visible from the root, and the root `.gitignore`
  stays site-wide.
- **No CI.** There is no `.github/` in the repo. GitHub Pages serves `master`
  directly, so **the compiled Elm output must be committed**. This is the
  opposite of pingolin, which gitignores `public/main.js` because it builds to
  `dist/`. Do not copy pingolin's `.gitignore` blindly.
- **`elm` is not installed.** `npm` and `node` are.
- **Commits go straight to `master`**, Conventional Commits style, matching the
  existing log (`feat:`, `fix:`, `refactor:`, `style:`). One commit per step.

## Pinned toolchain — DONE, verified by a successful compile

Drift here is silent and expensive, so these are checklist items, not a footnote.

- [x] Elm **0.19.2**, pinned exactly (`"elm": "0.19.2-0"`, no caret) in
      `pomo/package.json`.

      **This overrides pingolin, deliberately.** pingolin runs `^0.19.1-6` and
      an earlier draft of this file said to copy that. It was wrong: 0.19.2 is
      an official `elm/compiler` release with Mac installers, and
      `~/external-projects/guide.elm-lang.org` — the canonical docs — pins
      `"elm-version": "0.19.2"` in `repl/elm.json`. The guide wins; pingolin is
      simply older. Package versions are identical either way
      (`elm/core` 1.0.5, `elm/browser` 1.0.2, `elm/html` 1.0.1), so only the
      compiler differs.

- [x] Direct deps installed: `elm/core`, `elm/browser`, `elm/html`, `elm/time`,
      `elm/random`, `elm/http`. Installed up front rather than per-step, purely
      to prove `package.elm-lang.org` is reachable — the corporate proxy is the
      failure mode you want to discover now, not at Step 4. It resolved clean.
- [x] `pomo/.gitignore` — `node_modules/`, `elm-stuff/`, `.DS_Store`.
      It does **not** ignore `main.js`; that is the deliverable.
- [x] Build is a single `elm make` invocation. **No bundler, no framework, no
      Parcel, no Vite.** If a step seems to need one, stop — it doesn't.
- [x] Verified end to end: a throwaway `src/Main.elm` compiled under
      `--optimize` to an 89K `main.js`, then both were deleted. Step 1 writes
      the first real module.

### Gotcha for whoever runs `npm i` again

npm 11 prints an `allow-scripts` warning because `elm`'s postinstall
(`node install.js`) is not approved. **Ignore it** — the binary arrives via a
platform-specific optional dependency and `npx elm --version` works regardless.
Do not "fix" this by running `npm approve-scripts`; nothing is broken.

### 0.19.2 is brand new — trust the compiler over any model's memory

0.19.1 shipped in 2019 and 0.19.2 landed roughly six years later, in July 2026.
Any LLM working on this repo — including whichever one wrote this line — was
almost certainly trained before it existed.

The CLI is unchanged (`repl`, `init`, `reactor`, `make`, `install`, `bump`,
`diff`), so all 0.19.1 habits transfer and this is very likely a
maintenance/compatibility release rather than a language change. But when
anything version-specific comes up, the order of authority is:

  1. the compiler's own error message — Elm's are the best in the business and
     they are *from this build*
  2. `~/external-projects/guide.elm-lang.org` (pins 0.19.2) and
     `~/external-projects/error-message-catalog`
  3. recollection — last, and flag it as such

Do not "fix" a compiler error by pattern-matching a remembered 0.19.1 idiom.
Read what it actually says.

`elm reactor` is available for poking at things without a static server.

---

## Decisions taken (reverse freely, but knowingly)

Defaults so nothing blocks. Each is cheap to reverse; the cost is stated.

| # | Decision | Ref | Reversal |
|---|---|---|---|
| 1 | One stored number: `startedAt`. Everything else derived. | §1c, §11 | Rewrite — this is the whole design |
| 2 | Never display `00:00`; `00:01` flips straight to the reward | §1c | One token |
| 3 | 25 minutes fixed; minutes box stops being an input | §1c Q4, §10 | Small; retires the chuck fork |
| 4 | Two-digit pomodoro padding, no `log10` | §1b-ii Q5 | Settled by chuck's own tests |
| 5 | Auto-restart survives (the loop is the point) | §1c | Free either way |
| 6 | `quotes/*.txt` unchanged: one quote per line, zero escaping | §0b, §4 | Non-negotiable |
| 7 | Fetch + `String.lines`, not baked-in | §4 | Moderate — swaps Step 4 |
| 8 | Tabs switch live, timer survives a speaker change | §7 | ~10 lines |
| 9 | `Browser.document` + flags. **Not** `Browser.application` | §7 | Cheap now, expensive later |
| 10 | `<details>` for the "+", no model state | §9 | 3 lines |
| 11 | `pomo/main.js` = Elm output, `pomo/app.js` = port glue | below | Touches `sw.js` |

**On Decision 11.** Mirrors pingolin exactly: `public/main.js` is its compiler
output, `public/app.js` its hand-written glue. pomo's web root *is* `pomo/`, so
they sit at `pomo/`. This matters more than it looks — an earlier draft had the
output going to `js/app.js`, which **Step 8 would then have deleted**, taking
the app with it. Nothing compiled ever goes in `js/`; `js/` only ever shrinks.

---

## Step 0 — Toolchain ✅ DONE

*Mode: setup. No behaviour changes.*

- [x] `package.json` + Elm installed **in `pomo/`**. Nothing landed at the repo
      root — verified with `git status`.
- [x] `elm.json` at 0.19.2 with the six direct deps
- [x] `pomo/.gitignore`
- [x] `npm run build` → `elm make src/Main.elm --output=main.js --optimize`
      (plus `npm run dev`, same without `--optimize`)
- [x] Compile verified end to end, scratch module then removed

**`npm run build` will fail until Step 1 exists** — there is no `src/` yet.
That is expected, not a broken commit: the toolchain is proven, the app is not
written.

`chore: elm toolchain`

## Step 1 — Static shell

*Mode: feature. Markup only, zero logic.*

- [ ] `src/Main.elm` renders today's markup — read `index.html` for the truth,
      including every joke in a `title` attribute (§10)
- [ ] `index.html` reduced to head, CSS, mount point, `<script src="main.js">`
- [ ] Commit the compiled `main.js` alongside the source — no CI builds it
- [ ] **Done when:** visually indistinguishable from before; old `js/main.js`
      still loaded and still driving the clock

`feat: elm renders the shell`

## Step 2 — The timer ⭐

*Mode: refactor + bug fix. **This is where the argument is won or lost.***

Read §1b, §1b-ii and §1c in full first. The point is not to port chuck — it is
that `//` and `modBy` **are** the carry chain, so the t=1 payout and the
1501-second period cannot be expressed, let alone fixed.

- [ ] `Timer = Idle | Running Time.Posix` (§2 option D, §11)
- [ ] Display derived from `now - startedAt` (§1c)
- [ ] `subscriptions` is a two-branch `case` — no `timerId`, no `clearInterval`
- [ ] Title from `Browser.document`, deleting the childNode-scraping in
      `main.js`'s `updateTitle`
- [ ] Reward fires on the derived pomodoro count changing (§11)
- [ ] **Delete `js/chuck.js`** — and read §1b-ii on why this isn't killing chuck
- [ ] **Done when:** the proof below passes

`refactor: replace chuck with divMod`

### The proof (do not skip — it is the only test this project needs)

- [ ] Rebuild the headless chuck harness. `/tmp/chucksim` was deleted; the
      recipe is in §1b, and the elements must fake **`INPUT`**, because
      `pomo/js/chuck.js` is a fork of upstream with `tagName` branches
      (§1b-ii). Using `~/external-projects/chuck/chuck.js` with input objects
      silently does nothing — that mistake already happened once.
- [ ] Run the Elm display function over `0..3010` and diff against the chuck trace
- [ ] **Every second matches except:** no payout at `t=1`; period is 1500 not
      1501; `00:00` never renders
- [ ] Expected fire ticks — chuck: `1, 1501, 3001`. Elm: `1500, 3000`.

## Step 3 — The cast

*Mode: feature. Deleted cleverness per line added is highest here (§3).*

- [ ] `Speaker` custom type; tab bar is a `List.map`, not five `<li>`s
- [ ] `?says` as a flag; out-of-range falls back to random with no error path
- [ ] Two display functions — tabs say "Rory", attribution says "Rory Breaker"
- [ ] Live switching, URL updated one-way (§7; pingolin's `updateUrl` port is
      the reference — read `src/Main.elm` and `public/app.js`)
- [ ] Delete `quoter()`/`ucwords()` filename surgery
- [ ] **Done when:** changing speaker mid-pomodoro no longer kills the timer
      (a real bug fix, shipped as a feature)

`feat: speaker type`

## Step 4 — Quotes

*Mode: feature. Guard §0b: paste ergonomics beat cleanliness.*

- [ ] Fetch + `String.lines`, filtering blanks (§4B)
- [ ] Prefetch at init — never at the moment of reward
- [ ] `Random.uniform` fed by a cons-cell match, so "no quotes" needs no
      invented fallback (§4)
- [ ] Speaker and quote randomness both become `Cmd` (§5)
- [ ] **Delete `js/hjson.min.js`**
- [ ] **Done when:** pasting a new line into `quotes/bacon.txt` and reloading
      shows it — **no build step.** If a build step crept in, Decision 7 broke.

`feat: quotes without hjson`

## Step 5 — The log

*Mode: feature.*

- [ ] `Note` records, newest first (§6)
- [ ] `Time.here` at init; timestamp captured at event time, not render time
- [ ] No HTML string building, no `&rsquo;` mangling — typography via CSS or
      fixed once in the source `.txt` (§6)
- [ ] **Done when:** re-rendering can't relabel an old quote's time

`feat: quote log`

## Step 6 — The edges

*Mode: feature. Keep the port list brutally short (§7).*

- [ ] Notification port (permission + fire)
- [ ] Alarm port calling `.play()` — not autoplay-on-render (§7)
- [ ] `?silent` as a `Bool` with one obvious convention, fixing the backwards
      `!["true","1",""].includes()` logic
- [ ] Service worker registration stays in `index.html`, untouched
- [ ] **Done when:** exactly three ports exist and each is justified in §7

`feat: notification and alarm ports`

## Step 7 — Keyboard, disclosure, polish

*Mode: refactor + UX.*

- [ ] Space via `Browser.Events`, emitting the same Msg as the button;
      `:active` does the press animation (§8). Check the Elm guide for
      `preventDefault` rather than guessing — it's the one fiddly bit.
- [ ] `<details>`/`<summary>` for the reminder, no model state (§9)
- [ ] Boxed digits become bordered spans/`<output>`; no disabled inputs
      lying to assistive tech (§10)
- [ ] `aria-live`: `off` on the clock, `polite` on the notifications (§10)
- [ ] Confirm the focus ring survived commit `3cad920` (§10)
- [ ] "+" stays after Stop, per the newer screenshot (§10)

`style: keyboard, disclosure, focus`

## Step 8 — Sweep

*Mode: cleanup.*

- [ ] `sw.js` `APP_SHELL`: drop `./js/main.js`, `./js/chuck.js`,
      `./js/hjson.min.js`; add `./main.js`, `./app.js` **and `quotes/*.txt`** —
      Decision 7 makes offline caching of the quotes mandatory, not optional
- [ ] Bump `CACHE_NAME` past `pomo-v1`
- [ ] **Delete `js/` entirely**
- [ ] `README.md` — it currently shows the old screenshot
- [ ] **Done when:** offline in a fresh PWA window completes a pomodoro and
      pays out a quote

`chore: delete the javascript`

---

## Deletion ledger

The scoreboard. Anti-slop means this column only goes down (§0b).

| File | Lines | Dies at |
|---|---:|---|
| `js/chuck.js` | 274 | Step 2 |
| `js/main.js` | 252 | Steps 2–7 |
| `js/hjson.min.js` | 11 | Step 4 |
| **Total** | **537** | |

Target: one `Main.elm`, in the shape sketched in §11 — seven fields, seven
messages, three types. **If it outgrows that, stop and reopen
`core-requirements.txt` rather than pushing on.**

## Definition of done

- [ ] `js/` gone; no JavaScript but the ports, the service worker and the mount
- [ ] Timer correct per the Step 2 proof
- [ ] Adding a quote is still paste-and-save
- [ ] Works offline in a standalone PWA window
- [ ] Every `title` joke survived
- [ ] Still fuck-you simple: one screen, no settings, no streaks (§0b)

## Open rulings

Defaults above hold unless overruled — none of these block a start.

- §1c — never show `00:00`? (assumed yes)
- Q4 — minutes fixed at 25? (assumed yes; retires the chuck fork)
- §4 — fetch vs bake in? (assumed fetch)
- §7 — tabs live? (assumed yes)
- §10 — tomato glyphs for the pomodoro count, or leave the third box?
  The one genuine legibility gap; the only item here that is taste, not
  mechanism.
