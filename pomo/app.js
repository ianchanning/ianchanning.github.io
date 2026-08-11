const app = Elm.Main.init({
  flags: { says: new URLSearchParams(window.location.search).get("says") },
});

// Temporary bridge. Elm decides *when* a pomodoro lands and *who* is talking;
// js/main.js still owns what that means until Steps 4 and 6 move quotes and
// notifications into Elm.
app.ports.reward.subscribe((detail) => {
  document.dispatchEvent(new CustomEvent("pomodoro", { detail }));
});

app.ports.updateUrl.subscribe((says) => {
  const url = new URL(window.location);
  url.searchParams.set("says", says);
  window.history.replaceState({}, "", url);
});
