import { chuck } from "./chuck.js";
const timer = document.querySelector("#chker");
let timerId = 0;
const tickInterval = 1000;
const appName = "Lock Stock Pomodoros";
const siteName = "ianchanning";

if (!timer) {
  throw new Error("Pomodoro timer element was not found.");
}

const mm = timer.querySelector(".min");
const ss = timer.querySelector(".sec");
const pp = timer.querySelector(".pomo");
const start = timer.querySelector(".start");
const stop = timer.querySelector(".stop");
const reminderLink = document.querySelector("#reminder");
const reminder = document.querySelector(".reminder");
const alarm = document.querySelector("#alarm");

if (!mm || !ss || !pp || !start || !stop || !reminderLink || !reminder || !alarm) {
  throw new Error("Pomodoro timer markup is incomplete.");
}

const files = [
  "bacon.txt",
  "eddie.txt",
  "soap.txt",
  "tom.txt",
  "rory_breaker.txt",
];

const param = (key) => new URLSearchParams(window.location.search).get(key);

const quotesFile = () => {
  const requestedIndex = Number.parseInt(param("says") ?? "", 10);
  const defaultIndex = Math.floor(Math.random() * files.length);
  const index =
    Number.isInteger(requestedIndex) &&
    requestedIndex >= 0 &&
    requestedIndex < files.length
      ? requestedIndex
      : defaultIndex;

  return files[index];
};

const shouldPlaySound = () => !["true", "1", ""].includes(param("silent"));

const fetchQuotes = async (fileName) => {
  if (!files.includes(fileName)) {
    throw new Error("Invalid quote file.");
  }

  const response = await fetch(`quotes/${encodeURIComponent(fileName)}`);
  if (!response.ok) {
    throw new Error(`Failed to fetch quotes: ${response.status} ${response.statusText}`);
  }

  const data = await response.text();
  return Hjson.parse(`[${data}]`);
};

document.querySelectorAll(".tabs a").forEach((link) => {
  const linkParams = new URL(link.href, document.baseURI).searchParams;
  if (linkParams.get("says") === param("says")) {
    link.classList.add("active");
  }
});

if ("Notification" in window) {
  Notification.requestPermission();
}

/**
 * Start the timer
 *
 * Primary method that calls `updateTimer` each second
 */
const startTimer = () => {
  // prevent spamming the link
  if (timerId === 0) {
    timerId = window.setInterval(updateTimer, tickInterval);
    timer.classList.add("ticking");
  }
};

/**
 * Stop the timer
 */
const stopTimer = () => {
  window.clearInterval(timerId);
  timerId = 0;
  timer.classList.remove("ticking");
};

start.addEventListener("click", startTimer);
stop.addEventListener("click", stopTimer);

/**
 * Display the timer in the title.
 */
const updateTitle = () => {
  const timerText = Array.from(timer.querySelector(".time").childNodes)
    .filter((node) => node.nodeName !== "A")
    .map((node) => node.value || node.textContent.trim())
    .join(" ");
  document.title = `${timerText} - ${appName} : ${siteName}`;
};

/**
 * Use the chuck timer as a Pomodoro timer.
 *
 * This function needs to be called once per second. It ticks down 60 seconds,
 * then down 25 minutes, and then up to 100 pomodoros.
 */
const chkIt = () => {
  chuck()
    .down(ss, 60)
    .down(mm, 25)
    .up(pp, 100, randomNotification);
};

/**
 * Timer callback.
 */
const updateTimer = () => {
  chkIt();
  updateTitle();
};

/**
 * Convert the first letter of each word to upper case.
 *
 * @param {string} str Lower case string
 * @return {string}
 */
const ucwords = (str) =>
  `${str}`.replace(/^([a-z])|\s+([a-z])/g, (match) => match.toUpperCase());

const quoter = (fileName) => {
  const file = fileName.split(".");
  return ucwords(file[0].replace(/_/g, " "));
};

const randomNotification = () => {
  // don't stop after the first notification
  if (Number.parseInt(pp.value, 10) >= 1) {
    stopTimer();
  }

  if (shouldPlaySound()) {
    alarm.play();
  }

  const fileName = quotesFile();
  fetchQuotes(fileName)
    .then((quotes) => {
      const randomQuote = quoteChooser(quotes);
      const options = {
        body: randomQuote,
      };

      if ("Notification" in window) {
        const notification = new Notification(`${quoter(fileName)} says`, options);
        window.setTimeout(() => notification.close(), 10000);
      }

      const notificationsElement = document.querySelector(".notifications");
      if (notificationsElement) {
        notificationsElement.insertAdjacentHTML(
          "afterbegin",
          formatQuote(randomQuote, quoter(fileName)),
        );
      } else {
        console.error('Element with class "notifications" not found.');
      }
    })
    .catch((error) => {
      console.error("Failed to fetch quotes:", error);
    });
};

/**
 * Generate the HTML for a quote.
 *
 * @param {string} quote   The raw quote
 * @param {string} speaker Name of the quoter
 * @return {string}         HTML with paragraph and quoter beneath
 */
const formatQuote = (quote, speaker) => {
  const prettyQuote = quote.replace(/'/g, "&rsquo;");
  const timeOptions = { hour: "numeric", minute: "numeric", hour12: true };
  const formattedTime = new Date().toLocaleTimeString("en-US", timeOptions);

  return `<blockquote>&ldquo;${prettyQuote}&rdquo;<figcaption>&mdash; says ${speaker} <cite>@ ${formattedTime}</cite></figcaption></blockquote>`;
};

const quoteChooser = (quotes) => {
  const randomNumber = Math.floor(Math.random() * quotes.length);
  return quotes[randomNumber];
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
