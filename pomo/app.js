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
