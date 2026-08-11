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

## Step 1 — Static shell ✅ DONE

*Mode: feature. Markup only, zero logic.*

- [x] `src/Main.elm` renders today's markup — read `index.html` for the truth,
      including every joke in a `title` attribute (§10)
- [x] `index.html` reduced to head, CSS, mount point, `<script src="main.js">`
- [x] Commit the compiled `main.js` alongside the source — no CI builds it
- [x] **Done when:** visually indistinguishable from before; old `js/main.js`
      still loaded and still driving the clock

`feat: elm renders the shell`

### Three deviations from the wording above, all forced

1. **There is no mount point.** Decision 9 picked `Browser.document`, which
   takes over `<body>` — `Elm.Main.init({})` gets no `node`. pingolin uses
   `Browser.element` + `#elm-app`, so don't copy its `index.html` shape.
2. **The scripts live in `<head>`, not at the end of `<body>`.** `Browser.document`
   *virtualizes* the existing body (`_VirtualDom_virtualize(bodyNode)`) and diffs
   the view against it, so anything in `<body>` that isn't in the view is patched
   away — including a `<script type="module" src="js/main.js">` that has not
   executed yet. In `<head>` Elm can't reach it. Order is `main.js` (defer) →
   `app.js` (defer) → `js/main.js` (module): all three share the one deferred
   list in document order, and `_Browser_makeAnimator` calls `draw(model)`
   *synchronously*, so the DOM exists by the time `js/main.js` queries it.
3. **`href="javascript:void(0);"` became `href="#"`.** `Html.Attributes.href`
   runs `noJavaScriptUri`, so Elm would have silently emitted `""`. `js/main.js`
   `preventDefault`s the click either way.

Also gone: `<body class="light">` — Elm renders `<body>` with no attributes.
Nothing uses it; the only mention is a comment in `css/style.css`, which
`index.html` doesn't even link.

### Verified end to end, not by eye

Headless Chrome (the playwright cache at
`~/Library/Caches/ms-playwright/chromium_headless_shell-1223`, no npm install
needed) driving a throwaway `probe.html` in an iframe, since removed:

    h1=DO IT  chker=true  tabs=5  reminderLink=+  alarm=true
    notifications=true  stopTitle=Hammertime
    before=25:00 00 → after=24:57 01   ticking=true
    title=24 : 57 01 - Lock Stock Pomodoros : ianchanning
    reminderOpen=block glyph=×
    quote=“You did take care of the shotguns?”— says Soap @ 3:04 PM

`pomo` reading `01` after three seconds **is the §1b t=1 payout**, reproduced
against Elm-rendered markup. Step 2 is supposed to delete it. If a later change
makes it vanish early, that's a regression in the proof, not a win.

## Step 2 — The timer ⭐ ✅ DONE

*Mode: refactor + bug fix. **This is where the argument is won or lost.***

Read §1b, §1b-ii and §1c in full first. The point is not to port chuck — it is
that `//` and `modBy` **are** the carry chain, so the t=1 payout and the
1501-second period cannot be expressed, let alone fixed.

- [x] `Timer = Idle | Running Time.Posix` (§2 option D, §11)
- [x] Display derived from `now - startedAt` (§1c)
- [x] `subscriptions` is a two-branch `case` — no `timerId`, no `clearInterval`
- [x] Title from `Browser.document`, deleting the childNode-scraping in
      `main.js`'s `updateTitle`
- [x] Reward fires on the derived pomodoro count changing (§11)
- [x] **Delete `js/chuck.js`** — and read §1b-ii on why this isn't killing chuck
- [x] **Done when:** the proof below passes

`refactor: replace chuck with divMod`

### What landed beyond the checklist

- **A fourth Msg, `Started Time.Posix`.** §11 lists `Start`, but deadline-based
  timing needs `Task.perform Started Time.now` to learn the instant. §11's
  "seven messages" is a budget, not a cap — this spends one of them early.
- **A temporary `reward : () -> Cmd msg` port**, bridged in `app.js` to a
  `pomodoro` CustomEvent that `js/main.js` listens for. Elm now decides *when* a
  pomodoro lands; JS still owns *what that means* until Step 4 (quotes) and
  Step 6 (notify/alarm). This port does not survive to Step 6's "exactly three".
- **`sw.js` partially swept early.** `js/chuck.js` had to leave `APP_SHELL` in
  the same commit that deleted it, so `./main.js` and `./app.js` went in at the
  same time and `CACHE_NAME` went to `pomo-v2`. Step 8 still owns dropping
  `./js/main.js` + `./js/hjson.min.js` and adding `quotes/*.txt`.
- **`#chker` still gets the `ticking` class**, now rendered by Elm via
  `classList`. That is not decoration: `js/main.js`'s space-bar `checkToggle()`
  reads it, so the keyboard keeps working until Step 7 takes it.
- **The minutes box is still an `<input>`** and Elm now overwrites it every
  tick, so typing in it reverts within a second. Decision 3 already fixed
  minutes at 25; Step 7 turns it into a non-input so it stops lying.
- **Stop now resets the title** to the bare `Lock Stock Pomodoros : ianchanning`
  and the clock to `25:00`, because both are functions of `Idle`. The old app
  left the last ticked values frozen on screen.

### The proof — PASSED

Both halves rebuilt from scratch, since `/tmp/chucksim` had been deleted again.

**chuck half.** `/tmp/chucksim.mjs`, importing `pomo/js/chuck.js` *before* it was
deleted, with fake elements reporting `tagName: "INPUT"` and seeded `mm="25"`,
`ss="00"`, `pp="00"` exactly as `index.html` did. This is one-shot by nature:
after this commit the fork is gone, and `~/external-projects/chuck/chuck.js` has
no INPUT branch, so it cannot stand in (§1b-ii).

**Elm half.** A throwaway `src/Proof.elm` importing the *shipped* `clock` and
`pad` from `Main` and rendering all 3011 lines, compiled and dumped from the
real DOM. `Main` therefore exposes `Clock`, `clock` and `pad` — the only reason
its exposing list isn't just `main`.

Result over `0..3010`:

| | chuck | Elm |
|---|---|---|
| fires at | `1, 1501, 3001` | `1500, 3000` |
| ever renders `00:00` | yes | no |
| ticks where `MM:SS` differs | — | **2** (t=1500, t=3000: `00:00` → `25:00`) |

Every other second of `MM:SS` is identical, exactly as §1c predicted. The
pomodoro column differs from t=1 onward for one reason only: chuck banked a
phantom pomodoro on tick one. That is BUG 1, and it is now gone.

Live, through the real `update` → port → `js/main.js` path, with `Date.now()`
stubbed to a synthetic clock so 25 minutes takes milliseconds: quotes appeared
at **t=1500 and t=3000 and nowhere else**. The `if (pp.value >= 1) stopTimer()`
guard is deleted and the timer now loops forever (Decision 5).

### Headless caveat — SOLVED at Step 5

**`chrome-headless-shell` never fires `requestAnimationFrame`.** Elm repaints on
rAF, so in that binary the DOM only updates on ticks that also dispatch a `Cmd`
(which happens to be the reward ticks). Full `Google Chrome for Testing` with
`--headless=new` hangs on this page.

**The fix, found at Step 5.** Elm's kernel binds rAF *once*, at load:

```js
var _Browser_requestAnimationFrame =
    typeof requestAnimationFrame !== 'undefined'
        ? requestAnimationFrame
        : function(callback) { return setTimeout(callback, 1000 / 60); };
```

So take rAF away *before `main.js` executes* and Elm uses `setTimeout`, which
`--virtual-time-budget` does fast-forward:

```html
<!-- injected as the first thing in <head> -->
<script>
  Object.defineProperty(window, "requestAnimationFrame", { value: undefined });
  window.__off = 0;
  const __base = 1700000000000;
  Date.now = () => __base + window.__off;
</script>
```

"Before `main.js` executes" rules out the iframe harness used in Steps 1–4 —
generate a copy of `index.html` with the block injected and drive that instead.
Step 5 read `#pomo` as `03` after three walked pomodoros, so **per-tick repaint
is now asserted headlessly** and the Step 2/3 caveat is retired. Use this for
the Step 7 keyboard work, which is otherwise unverifiable.

## Step 3 — The cast ✅ DONE

*Mode: feature. Deleted cleverness per line added is highest here (§3).*

- [x] `Speaker` custom type; tab bar is a `List.map`, not five `<li>`s
- [x] `?says` as a flag; out-of-range falls back to random with no error path
- [x] Two display functions — tabs say "Rory", attribution says "Rory Breaker"
- [x] Live switching, URL updated one-way (§7; pingolin's `updateUrl` port is
      the reference — read `src/Main.elm` and `public/app.js`)
- [x] Delete `quoter()`/`ucwords()` filename surgery
- [x] **Done when:** changing speaker mid-pomodoro no longer kills the timer
      (a real bug fix, shipped as a feature)

`feat: speaker type`

### Deviations

1. **Four functions on `Speaker`, not two.** §3 asks for two because it is
   talking about the display asymmetry. `quoteFile` replaces the `files[]`
   array and `saysIndex` replaces the URL contract, so both had to come across
   too. No wildcard branches anywhere: adding `Bill` makes the compiler list
   all four sites, which is the entire sales pitch.
2. **`reward` widened to `{ file, speaker }`.** It was `()`. Elm now owns *who*
   as well as *when*, which is what let `files`, `quotesFile`, `ucwords`,
   `quoter`, the `.tabs a` `.active` loop and the "invalid quote file" guard all
   die in one go. Still temporary — Steps 4 and 6 split it.
3. **`elm/json` promoted from indirect to direct** in `elm.json`.
   `preventDefaultOn` needs a `Decoder`. Step 4 wants it anyway.
4. **Six messages now** (`Start`, `Started`, `Stop`, `Tick`, `ChangeSpeaker`,
   `ChoseSpeaker`). §11's seven is a budget and Steps 4–5 still want theirs.
   `ChangeSpeaker` and `ChoseSpeaker` are not the same event: the user's choice
   updates the URL, the dice's choice deliberately does not.
5. **Behaviour change: a random speaker now highlights its tab.** The old code
   compared `?says` strings, so a bare URL matched no link and no tab lit up.
   Silent about who is talking. Elm renders `active` from the model, so it
   lights up. The URL is left alone, so refresh still means "surprise me".
6. `href` stays real (`?says=N&silent=0`) and the click is intercepted with
   `preventDefaultOn`. Right-click, middle-click and no-JS all still work.

### Proof (headless, `chrome-headless-shell` + `--virtual-time-budget`)

| Claim | Result |
|---|---|
| `?says=4` → Rory tab active | ✅ |
| reward at t=1500 | `{"file":"rory_breaker.txt","speaker":"Rory Breaker"}` |
| click Bacon → no navigation | ✅ `pathname` unchanged |
| URL rewritten, `silent` preserved | ✅ `?says=0&silent=1` |
| **reward at t=3000 after the switch** | `{"file":"bacon.txt","speaker":"Bacon"}` |
| no `?says` → random, URL untouched | ✅ varied across runs |
| `?says=9`, `?says=eddie` → random | ✅ no error path |

That last-but-two row *is* the "done when": the timer banked its second
pomodoro across a speaker change, which the old page could not do because
switching speaker was a page load.

The repaint caveat from Step 2 applied at the time — `active` and the clock
digits read stale in headless. **Step 5 solved it**; see the caveat section
above. Re-running this probe today would show the `active` class moving.

## Step 4 — Quotes ✅ DONE

*Mode: feature. Guard §0b: paste ergonomics beat cleanliness.*

- [x] Fetch + `String.lines`, filtering blanks (§4B)
- [x] Prefetch at init — never at the moment of reward
- [x] `Random.uniform` fed by a cons-cell match, so "no quotes" needs no
      invented fallback (§4)
- [x] Speaker and quote randomness both become `Cmd` (§5)
- [x] **Delete `js/hjson.min.js`**
- [x] **Done when:** pasting a new line into `quotes/bacon.txt` and reloading
      shows it — **no build step.** If a build step crept in, Decision 7 broke.

`feat: quotes without hjson`

### Deviations

1. **`lines` trims before filtering.** §4B says `not << String.isEmpty`; a
   whitespace-only line survives that and would have shipped a blank quote.
   `String.trim` first, which also eats a stray `\r` from a Windows paste.
   Strictly more forgiving to the paste, which is the point of §4.
2. **`reward` narrowed from `{ file, speaker }` to `{ quote, speaker }`.**
   Elm now picks the quote, so JS never sees a filename again. Still temporary:
   Steps 5 and 6 split the log from the alarm and this port dies.
3. **`GotQuotes (Err _)` is silent.** No error UI exists and §4 says the honest
   answer to "no quotes" is "don't fire a reward". Consequence worth naming:
   **a failed fetch currently also swallows the alarm**, because the alarm is
   inside the same port. Step 6 gives the alarm its own port and fixes that —
   the pomodoro completed either way and should still make a noise.
4. **Eight messages** (`GotQuotes`, `GotQuote` added). §11 budgeted seven and
   `GotZone` is still owed at Step 5. Reasons on the record: `Started` is
   required by `Task.perform`, and `ChangeSpeaker`/`ChoseSpeaker` differ by
   whether the URL is rewritten. Nothing here is a stored derived value, which
   is the constraint §11 actually cared about.
5. **Quote files added to the service worker's `APP_SHELL`**, `CACHE_NAME`
   bumped to `pomo-v3`. §4 chose B partly because it "keeps the app honestly
   offline-first via the service worker". `sw.js` is network-first, so without
   this a fresh offline install has a working timer and no quotes.
   Only the five in use — `bacon2`/`bill`/`lockstock` stay out of scope (§3).

### Proof (headless, 40 rewards per run)

| Claim | Result |
|---|---|
| quotes come from the file, prefetched | ✅ 15 distinct of 18 in 40 draws |
| apostrophes survive (`Don't`, `I'm`, `c'mon`) | ✅ verbatim |
| §4's named hjson stress case, `"Too late, too late"` mid-sentence | ✅ verbatim |
| **paste a line, reload → drawn** | ✅ and `main.js` mtime **unchanged** |
| blank and whitespace-only lines | ✅ never drawn |
| missing quote file (404) | ✅ 0 rewards, no crash |
| switch speaker → refetch | ✅ 6× Bacon then 6× Rory Breaker |

The mtime row is the whole of Decision 7: the sentinel line reached the reward
without `elm make` running. Paste-and-save-and-reload survived the port.

## Step 5 — The log ✅ DONE

*Mode: feature.*

- [x] `Note` records, newest first (§6)
- [x] `Time.here` at init; timestamp captured at event time, not render time
- [x] No HTML string building, no `&rsquo;` mangling — typography via CSS or
      fixed once in the source `.txt` (§6)
- [x] **Done when:** re-rendering can't relabel an old quote's time

`feat: quote log`

### Deviations

1. **The apostrophe fix went into `lines`, not the source `.txt` files.**
   §6 prefers fixing them "once, at generation time" rather than "on every
   render forever". We have no generator, and editing the eight `.txt` files
   would make a fresh IMDB paste render subtly differently from its
   neighbours — a paste-ergonomics regression, which §4 says overrides
   cleanliness. `lines` is the parse boundary, runs once per fetch rather than
   per render, and satisfies both. **One line to move if you disagree.**
2. **The quote text is wrapped in `<span class="quote">`.** `::after` on the
   `blockquote` would put the closing quote mark after the `figcaption`. The
   original DOM was `<blockquote>“quote”<figcaption>…` — the span reproduces
   it exactly and gives the pseudo-elements something to attach to.
3. **Nine messages** (`GotZone` added), one over §11's budget for the reasons
   already logged at Steps 3 and 4. Model is at six fields against §11's seven,
   and `silent` at Step 6 makes seven — on target.
4. `&ldquo;`/`&rdquo;` became `quotes:` + `content: open-quote` in the inline
   `<style>` in `index.html`, since `css/style.css` is not linked. `&mdash;`
   became a literal `—` in the Elm source — it is a static label, not data.

### Proof

**`clockTime` vs the `toLocaleTimeString` it replaced** — a throwaway
`src/Proof.elm` dumped all 1440 minutes of a UTC day, diffed in the browser
against `toLocaleTimeString("en-US", { hour: "numeric", minute: "numeric",
hour12: true })`:

| | |
|---|---|
| rows compared | 1440 |
| **mismatches** | **0** |
| midnight | `12:00 AM` |
| noon | `12:00 PM` |

**The log** — three pomodoros walked from a stubbed `22:13:20 UTC`:

| Claim | Result |
|---|---|
| newest first | `["@ 11:28 PM","@ 11:03 PM","@ 10:38 PM"]` |
| markup | `<blockquote><span class="quote">…</span><figcaption>— says Bacon <cite>@ 11:28 PM</cite></figcaption></blockquote>` |
| curly apostrophe, no straight one | ✅ `It’s as long as my arm.` |
| CSS quote marks resolve | ✅ `open-quote` / `close-quote` |
| **clock jumped ~8h, speaker switched, 2 more notes** | **old three timestamps byte-identical** |
| old notes keep their own speaker | ✅ 2× Rory Breaker then 3× Bacon |

That last pair is the "done when". The old code built `new Date()` inside
`formatQuote` at render time, so any re-render relabelled every quote to *now*.
Ours cannot: the `Time.Posix` is captured in the `Note`, and so is the
`Speaker`.

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

- [ ] `sw.js` `APP_SHELL`: drop `./js/main.js` and `./js/hjson.min.js`; add
      `quotes/*.txt` — Decision 7 makes offline caching of the quotes
      mandatory, not optional. (`./js/chuck.js` already left, and `./main.js`
      + `./app.js` already arrived, in Step 2 — see there for why.)
- [ ] Bump `CACHE_NAME` past `pomo-v2`
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
| `js/chuck.js` | 274 | Step 2 — **gone** |
| `js/main.js` | 252 | Steps 2–7 — **94 left** after Step 5 |
| `js/hjson.min.js` | 11 | Step 4 — **gone** |
| **Total** | **537** | **94 left** |

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
