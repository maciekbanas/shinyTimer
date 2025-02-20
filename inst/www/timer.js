let timerInterval;

function formatTime(time, type) {
  if (type === 'mm:ss') {
    const minutes = Math.floor(time / 60);
    const seconds = Math.floor(time % 60);
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
  } else if (type === 'hh:mm:ss') {
    const hours = Math.floor(time / 3600);
    const minutes = Math.floor((time % 3600) / 60);
    const seconds = Math.floor(time % 60);
    return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
  } else if (type === 'mm:ss.cs') {
    const minutes = Math.floor(time / 60);
    const seconds = Math.floor(time % 60);
    const centiseconds = Math.floor((time * 100) % 100);
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}.${String(centiseconds).padStart(2, '0')}`;
  } else {
    return String(Math.floor(time));
  }
}

Shiny.addCustomMessageHandler('countDown', function(message) {
  const { inputId } = message;
  clearInterval(timerInterval);
  const countdownElement = document.getElementById(inputId);
  let timeLeft = parseFloat(countdownElement.getAttribute('data-start-time'));
  const type = countdownElement.getAttribute('data-type');

  countdownElement.textContent = formatTime(timeLeft, type);

  timerInterval = setInterval(function() {
    timeLeft -= 0.01;
    countdownElement.textContent = formatTime(timeLeft, type);

    if (timeLeft <= 0) {
      clearInterval(timerInterval);
      countdownElement.textContent = formatTime(0, type);
      Shiny.setInputValue('timer_done', true);
    }
  }, 10);
});

Shiny.addCustomMessageHandler('countUp', function(message) {
  const { inputId } = message;
  clearInterval(timerInterval);
  const countElement = document.getElementById(inputId);
  let timeStart = parseFloat(countElement.getAttribute('data-start-time'));
  const type = countElement.getAttribute('data-type');

  countElement.textContent = formatTime(timeStart, type);
  
  timerInterval = setInterval(function() {
    timeStart += 0.01;
    countElement.textContent = formatTime(timeStart, type);
  }, 10);
});

Shiny.addCustomMessageHandler('stopTimer', function(message) {
  clearInterval(timerInterval);
});

Shiny.addCustomMessageHandler('updateShinyTimer', function(message) {
  const { inputId, start, type, label } = message;
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

  if (type !== undefined) {
    countdownElement.setAttribute('data-type', type);
  }

  if (label !== undefined && labelElement) {
    labelElement.textContent = label;
  }
  
  const currentStartTime = parseFloat(countdownElement.getAttribute('data-start-time'));
  const currentType = countdownElement.getAttribute('data-type');
  let timeLeft = currentStartTime;

  countdownElement.textContent = formatTime(timeLeft, currentType);
});