let timerInterval;
Shiny.addCustomMessageHandler('startCountdown', function(message) {
  const { startTime, timerId } = message;
  clearInterval(timerInterval);
  let timeLeft = startTime;
  const countdownElement = document.getElementById(timerId);
  countdownElement.textContent = timeLeft;
  timerInterval = setInterval(function() {
    timeLeft--;
    countdownElement.textContent = timeLeft;

    if (timeLeft <= 0) {
      clearInterval(timerInterval);
      Shiny.setInputValue('timer_done', true);
    }
  }, 1000);
});
