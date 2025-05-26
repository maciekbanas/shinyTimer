let timerInterval;
let pausedTime;
let timerDirection;

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

function startTimer(inputId) {
  const timerElement = document.getElementById(inputId);
  let time = pausedTime !== undefined ? pausedTime : parseFloat(timerElement.getAttribute('data-start-time'));
  const type = timerElement.getAttribute('data-type');

  clearInterval(timerInterval);
  timerElement.textContent = formatTime(time, type);

  timerInterval = setInterval(function() {
    if (timerDirection === 'down') {
      if (time <= 0) {
        clearInterval(timerInterval);
        timerElement.textContent = formatTime(0, type);
        pausedTime = 0;
        Shiny.setInputValue('timer_done', true);
      } else {
        time = Math.max(time - 0.01, 0);
        pausedTime = time;
        timerElement.textContent = formatTime(time, type);
      }
    } else if (timerDirection === 'up') {
      time += 0.01;
      pausedTime = time;
      timerElement.textContent = formatTime(time, type);
    }
  }, 10);
}

Shiny.addCustomMessageHandler('countDown', function(message) {
  const { inputId } = message;
  timerDirection = 'down';
  startTimer(inputId);
});

Shiny.addCustomMessageHandler('countUp', function(message) {
  const { inputId } = message;
  timerDirection = 'up';
  startTimer(inputId);
});

Shiny.addCustomMessageHandler('pauseTimer', function(message) {
  const { inputId, start } = message;
  clearInterval(timerInterval);
  const timerElement = document.getElementById(inputId);
  Shiny.setInputValue("shinytimer_content", timerElement.textContent)
});

Shiny.addCustomMessageHandler('resetTimer', function(message) {
  const { inputId, start } = message;
  clearInterval(timerInterval);
  const timerElement = document.getElementById(inputId);
  timerElement.setAttribute('data-start-time', start);
  pausedTime = start;
  const type = timerElement.getAttribute('data-type');
  timerElement.textContent = formatTime(start, type);
});

Shiny.addCustomMessageHandler('updateShinyTimer', function(message) {
  const { inputId, start, type, label, frame } = message;
  const countdownElement = document.getElementById(inputId);
  const labelElement = document.querySelector(`label[for=${inputId}]`);

  if (!countdownElement) {
    console.error(`Element with ID ${inputId} not found.`);
    return;
  }

  clearInterval(timerInterval);

  if (start !== undefined) {
    countdownElement.setAttribute('data-start-time', start);
    pausedTime = start;
  } else {
    pausedTime = parseFloat(countdownElement.getAttribute('data-start-time'));
  }

  if (type !== undefined) {
    countdownElement.setAttribute('data-type', type);
  }

  countdownElement.textContent = formatTime(pausedTime, countdownElement.getAttribute('data-type'));

  if (frame !== undefined) {
    const frameClass = frame === 'circle' ? 'shiny-timer-circle' :
                       frame === 'rectangle' ? 'shiny-timer-rectangle' : '';
    countdownElement.className = `shiny-timer ${frameClass}`;
  }

  if (label !== undefined && labelElement) {
    labelElement.textContent = label;
  }
});
