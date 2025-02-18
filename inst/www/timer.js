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

Shiny.addCustomMessageHandler('updateShinyTimer', function(message) {
  const { inputId, start, format, label } = message;
  const countdownElement = document.getElementById(inputId);
  const labelElement = document.querySelector(`label[for=${inputId}]`);
  
  if (!countdownElement) {
    console.error(`Element with ID ${inputId} not found.`);
    return;
  }
  
  clearInterval(timerInterval);

  if (start !== undefined) {
    countdownElement.setAttribute('data-start-time', start);
  }

  if (format !== undefined) {
    countdownElement.setAttribute('data-format', format);
  }

  if (label !== undefined && labelElement) {
    labelElement.textContent = label;
  }
  
  const currentStartTime = parseInt(countdownElement.getAttribute('data-start-time'), 10);
  const currentFormat = countdownElement.getAttribute('data-format');
  let timeLeft = currentStartTime;

  countdownElement.textContent = formatTime(timeLeft, currentFormat);
});
