let timerInterval;
Shiny.addCustomMessageHandler('startCountdown', function(message) {
  const { inputId } = message;
  clearInterval(timerInterval);
  const countdownElement = document.getElementById(inputId);
  let timeLeft = parseInt(countdownElement.getAttribute('data-start-time'), 10);
  const format = countdownElement.getAttribute('data-format');
  const animate = countdownElement.getAttribute('data-animate');
  debugger;
  const updateDisplay = () => {
    const newContent = formatTime(timeLeft, format);
    if (animate === 'roll-down') {
      countdownElement.classList.remove('roll');
      void countdownElement.offsetWidth;
      countdownElement.classList.add('roll');
    } else if (animate === 'fade') {
      countdownElement.classList.add('fade-out');
      setTimeout(() => {
        countdownElement.textContent = newContent;
        countdownElement.classList.remove('fade-out');
      }, 500);
    } else if (animate === 'slide') {
      countdownElement.classList.add('slide-out-left');
      setTimeout(() => {
        countdownElement.classList.remove('slide-out-left');
        countdownElement.classList.add('slide-in-right');
        countdownElement.textContent = newContent;
        setTimeout(() => { countdownElement.classList.remove('slide-in-right'); }, 500);
      }, 500);
    } else if (animate === 'flip') {
      countdownElement.classList.add('flip');
      setTimeout(() => { countdownElement.classList.remove('flip'); }, 500);
    } else if (animate === 'bounce') {
      countdownElement.classList.add('bounce');
    } else {
      countdownElement.textContent = newContent;
    }
  };
  
  countdownElement.textContent = formatTime(timeLeft, format);
  
  if (animate) {
    countdownElement.classList.add(animate);
  }
  
  timerInterval = setInterval(function() {
    timeLeft--;
    updateDisplay();

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

  if (startTime !== undefined) {
    countdownElement.setAttribute('data-start-time', start);
  }

  if (format !== undefined) {
    countdownElement.setAttribute('data-format', format);
  }

  if (animate !== undefined) {
    countdownElement.setAttribute('data-animate', animate);
  }

  if (label !== undefined && labelElement) {
    labelElement.textContent = label;
  }
  
  const currentStartTime = parseInt(countdownElement.getAttribute('data-start-time'), 10);
  const currentFormat = countdownElement.getAttribute('data-format');
  let timeLeft = currentStartTime;

  countdownElement.textContent = formatTime(timeLeft, currentFormat);
});
