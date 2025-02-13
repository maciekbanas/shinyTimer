let timerInterval;
Shiny.addCustomMessageHandler('startCountdown', function(message) {
  const { inputId } = message;
  clearInterval(timerInterval);
  const countdownElement = document.getElementById(inputId);
  let timeLeft = parseInt(countdownElement.getAttribute('data-start-time'), 10);
  const format = countdownElement.getAttribute('data-format');

  countdownElement.textContent = formatTime(timeLeft, format);
  
  timerInterval = setInterval(function() {
    timeLeft--;
    countdownElement.textContent = formatTime(timeLeft, format);

    if (timeLeft <= 0) {
      clearInterval(timerInterval);
      Shiny.setInputValue('timer_done', true);
    }
  }, 1000);
});

function formatTime(time, format) {
  if (format === 'clock') {
    const minutes = Math.floor(time / 60);
    const seconds = time % 60;
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
  } else {
    return time;
  }
};