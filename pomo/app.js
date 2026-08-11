const app = Elm.Main.init({});

// Temporary bridge. Elm decides *when* a pomodoro lands; js/main.js still owns
// what that means until Steps 4 and 6 move quotes and notifications into Elm.
app.ports.reward.subscribe(() => {
  document.dispatchEvent(new CustomEvent("pomodoro"));
});
