const timer = document.querySelector("#chker");

if (!timer) {
  throw new Error("Pomodoro timer element was not found.");
}

const start = timer.querySelector(".start");
const stop = timer.querySelector(".stop");
const reminderLink = document.querySelector("#reminder");
const reminder = document.querySelector(".reminder");

if (!start || !stop || !reminderLink || !reminder) {
  throw new Error("Pomodoro timer markup is incomplete.");
}

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
