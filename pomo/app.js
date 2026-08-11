const params = new URLSearchParams(window.location.search);

const app = Elm.Main.init({
  flags: { says: params.get("says"), silent: params.get("silent") },
});

// Page-load concern, not a model concern: ask once, fire later.
if ("Notification" in window) {
  Notification.requestPermission().catch((error) => {
    console.warn("Notification permission was not granted:", error);
  });
}

// Elm decides what the space bar *means*; this only says it does not also
// scroll the page and re-press whichever button happens to have focus.
// `Browser.Events` listeners are registered `{ passive: true }`, so Elm cannot
// cancel this itself. Nothing is read, nothing is remembered.
document.addEventListener("keydown", (event) => {
  if (event.key === " ") {
    event.preventDefault();
  }
});

app.ports.notify.subscribe(({ title, body }) => {
  if (!("Notification" in window) || Notification.permission !== "granted") {
    return;
  }

  try {
    const notification = new Notification(title, { body });
    window.setTimeout(() => notification.close(), 10000);
  } catch (error) {
    console.warn("Notification could not be displayed:", error);
  }
});

app.ports.play.subscribe(() => {
  const alarm = document.querySelector("#alarm");
  if (alarm) {
    alarm.play().catch((error) => {
      console.warn("Alarm could not be played:", error);
    });
  }
});

app.ports.updateUrl.subscribe((says) => {
  const url = new URL(window.location);
  url.searchParams.set("says", says);
  window.history.replaceState({}, "", url);
});
