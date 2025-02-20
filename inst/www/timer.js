let timerInterval;

function formatTime(time, format) {
  if (format === 'clock') {
    const minutes = Math.floor(time / 60);
    const seconds = Math.floor(time % 60);
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
  } else if (format === 'stopwatch') {
    const minutes = Math.floor(time / 60);
    const seconds = Math.floor(time % 60);
    const centiseconds = Math.floor((time * 100) % 100);
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}:${String(centiseconds).padStart(2, '0')}`;
  } else {
    return Math.floor(time);
  }
}

Shiny.addCustomMessageHandler('countDown', function(message) {
  const { inputId } = message;
  clearInterval(timerInterval);
  const countdownElement = document.getElementById(inputId);
  let timeLeft = parseFloat(countdownElement.getAttribute('data-start-time'));
  const format = countdownElement.getAttribute('data-format');

  countdownElement.textContent = formatTime(timeLeft, format);

  timerInterval = setInterval(function() {
    timeLeft -= 0.01;
    countdownElement.textContent = formatTime(timeLeft, format);

    if (timeLeft <= 0) {
      clearInterval(timerInterval);
      countdownElement.textContent = formatTime(0, format);
      Shiny.setInputValue('timer_done', true);
    }
  }, 10);
});

Shiny.addCustomMessageHandler('countUp', function(message) {
  const { inputId } = message;
  clearInterval(timerInterval);
  const countElement = document.getElementById(inputId);
  let timeStart = parseFloat(countElement.getAttribute('data-start-time'));
  const format = countElement.getAttribute('data-format');

  countElement.textContent = formatTime(timeStart, format);
  
  timerInterval = setInterval(function() {
    timeStart += 0.01;
    countElement.textContent = formatTime(timeStart, format);
  }, 10); // Update every 10 milliseconds for precision
});

Shiny.addCustomMessageHandler('stopTimer', function(message) {
  clearInterval(timerInterval);
});

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
  
  const currentStartTime = parseFloat(countdownElement.getAttribute('data-start-time'));
  const currentFormat = countdownElement.getAttribute('data-format');
  let timeLeft = currentStartTime;

  countdownElement.textContent = formatTime(timeLeft, currentFormat);
});
