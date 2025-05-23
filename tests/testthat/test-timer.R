library(testthat)
library(shiny)
library(shinyTimer)

# Mock session object to capture custom messages
MockShinySession <- R6::R6Class(
  "MockShinySession",
  public = list(
    customMessages = list(),
    sendCustomMessage = function(type, message) {
      self$customMessages[[type]] <- message
    },
    getLastCustomMessage = function(type) {
      self$customMessages[[type]]
    }
  )
)

test_that("shinyTimer function works correctly", {
  # Test with default parameters
  ui <- shinyTimer("timer1")
  expect_true(inherits(ui, "shiny.tag.list"))
  
  # Test with specific parameters
  ui <- shinyTimer("timer2", label = "Timer", hours = 1, minutes = 30, seconds = 45, 
                   type = "hh:mm:ss", frame = "circle")
  expect_true(inherits(ui, "shiny.tag.list"))
  
  # Test invalid type
  expect_error(shinyTimer("timer3", type = "invalid"), "Invalid type")
  
  # Test invalid frame
  expect_error(shinyTimer("timer4", frame = "invalid"), "Invalid frame")
})

test_that("updateShinyTimer function works correctly", {
  session <- MockShinySession$new()
  updateShinyTimer("timer1", hours = 1, minutes = 30, seconds = 45, type = "hh:mm:ss", label = "Updated Timer", 
                   frame = "rectangle", session = session)
  message <- session$getLastCustomMessage("updateShinyTimer")
  expect_true(!is.null(message))
  expect_equal(message$inputId, "timer1")
  expect_equal(message$start, 5445) # 1 hour, 30 minutes, 45 seconds in total seconds
  expect_equal(message$type, "hh:mm:ss")
  expect_equal(message$label, "Updated Timer")
  expect_equal(message$frame, "rectangle")
})

test_that("countDown function works correctly", {
  session <- MockShinySession$new()
  countDown("timer1", session = session)
  message <- session$getLastCustomMessage("countDown")
  expect_true(!is.null(message))
  expect_equal(message$inputId, "timer1")
})

test_that("countUp function works correctly", {
  session <- MockShinySession$new()
  countUp("timer1", session = session)
  message <- session$getLastCustomMessage("countUp")
  expect_true(!is.null(message))
  expect_equal(message$inputId, "timer1")
})

test_that("pauseTimer function works correctly", {
  session <- MockShinySession$new()
  pauseTimer("timer1", session = session)
  message <- session$getLastCustomMessage("pauseTimer")
  expect_true(!is.null(message))
  expect_equal(message$inputId, "timer1")
})

test_that("resetTimer function works correctly", {
  session <- MockShinySession$new()
  resetTimer("timer1", hours = 1, minutes = 30, seconds = 45, session = session)
  message <- session$getLastCustomMessage("resetTimer")
  expect_true(!is.null(message))
  expect_equal(message$inputId, "timer1")
  expect_equal(message$start, 5445) # 1 hour, 30 minutes, 45 seconds in total seconds
})