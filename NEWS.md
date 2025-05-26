# shinyTimer (development version)

* Added new feedback value (text content of the timer) returned after pausing `shinyTimer` (#63).
* Renamed `background` parameter to `frame` to better reflect its purpose. Added `fill` parameter to pass colors to the background of the `shinyTimer` (#60).

# shinyTimer 0.1.0

This is the first release presenting the timer widget for `Shiny` applications with the following features:

* Basic UI and server functions: `shinyTimer()`, `updateShinyTimer()`, `countDown()` and `countUp()` functions ([#1](https://github.com/maciekbanas/shinyTimer/issues/1), [#11](https://github.com/maciekbanas/shinyTimer/issues/11), [#28](https://github.com/maciekbanas/shinyTimer/issues/28)).
* Possibility to set different units with `hours`, `minutes` and `seconds` parameters and different formats of the timer with the `type` parameter ([#9](https://github.com/maciekbanas/shinyTimer/issues/9), [#13](https://github.com/maciekbanas/shinyTimer/issues/13), [#30](https://github.com/maciekbanas/shinyTimer/issues/30), [#31](https://github.com/maciekbanas/shinyTimer/issues/31)).
* Possibility to `pauseTimer()` ([#23](https://github.com/maciekbanas/shinyTimer/issues/23)) and `resetTimer()` ([#10](https://github.com/maciekbanas/shinyTimer/issues/10)).
* Option to add a `background` to `shinyTimer()` ([#47](https://github.com/maciekbanas/shinyTimer/issues/47)).
