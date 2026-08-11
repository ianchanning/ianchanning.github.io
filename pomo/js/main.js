const timer = document.querySelector("#chker");

if (!timer) {
  throw new Error("Pomodoro timer element was not found.");
}

const start = timer.querySelector(".start");
const stop = timer.querySelector(".stop");
const reminderLink = document.querySelector("#reminder");
const reminder = document.querySelector(".reminder");
const alarm = document.querySelector("#alarm");

if (!start || !stop || !reminderLink || !reminder || !alarm) {
  throw new Error("Pomodoro timer markup is incomplete.");
}

const param = (key) => new URLSearchParams(window.location.search).get(key);

const shouldPlaySound = () => !["true", "1", ""].includes(param("silent"));

if ("Notification" in window) {
  Notification.requestPermission().catch((error) => {
    console.warn("Notification permission was not granted:", error);
  });
}

if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker
      .register("./sw.js", { scope: "./" })
      .then((registration) => {
        console.info("Pomodoro service worker registered:", registration.scope);
      })
      .catch((error) => {
        console.error("Pomodoro service worker registration failed:", error);
      });
  });
}

/**
 * Play the alarm and fire the OS notification. Elm owns the log.
 *
 * @param {{quote: string, speaker: string}} detail
 */
const randomNotification = ({ quote, speaker }) => {
  if (shouldPlaySound()) {
    alarm.play();
  }

  if ("Notification" in window && Notification.permission === "granted") {
    try {
      const notification = new Notification(`${speaker} says`, { body: quote });
      window.setTimeout(() => notification.close(), 10000);
    } catch (error) {
      console.warn("Notification could not be displayed:", error);
    }
  }
};

const checkToggle = () => (timer.classList.contains("ticking") ? stop : start);

const toggleButtonState = (button) => {
  button.classList.toggle("button-activated");
};

const activateButton = (button) => {
  button.click();
  button.focus();
  toggleButtonState(button);
};

document.addEventListener("keydown", (event) => {
  if (event.code === "Space") {
    event.preventDefault();
    toggleButtonState(checkToggle());
  }
});

document.addEventListener("keyup", (event) => {
  if (event.code === "Space") {
    event.preventDefault();
    activateButton(checkToggle());
  }
});

reminderLink.addEventListener("click", (event) => {
  event.preventDefault();
  const isClosed = reminderLink.textContent === "+";
  reminder.style.display = isClosed ? "block" : "none";
  reminderLink.textContent = isClosed ? "×" : "+";
});

// Elm owns the clock now; this is all that is left of the timer here.
document.addEventListener("pomodoro", (event) => randomNotification(event.detail));
