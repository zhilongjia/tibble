context("frame_data()")

test_that("frame_data() constructs 'data_frame' as expected", {

  result <- frame_data(
    ~colA, ~colB,
    "a", 1,
    "b", 2
  )

  compared <- data_frame(colA = c("a", "b"), colB = c(1, 2))
  expect_equal(result, compared)

  expect_identical(frame_data(~a, ~b), data_frame())

  ## wide
  wide <- frame_data(
    ~colA, ~colB, ~colC, ~colD,
    1, 2, 3, 4,
    5, 6, 7, 8
  )

  wide_expectation <- data_frame(
    colA = c(1, 5),
    colB = c(2, 6),
    colC = c(3, 7),
    colD = c(4, 8)
  )

  expect_equal(wide, wide_expectation)

  ## long
  long <- frame_data(
    ~colA, ~colB,
    1, 6,
    2, 7,
    3, 8,
    4, 9,
    5, 10
  )

  long_expectation <- data_frame(
    colA = as.numeric(1:5),
    colB = as.numeric(6:10)
  )

  expect_equal(long, long_expectation)

})

test_that("frame_data() creates lists for non-atomic inputs (#7)", {
  expect_identical(
    frame_data(~a, ~b, NA, "A", letters, LETTERS[-1L]),
    data_frame(a = list(NA, letters), b = list("A", LETTERS[-1L]))
  )

  expect_identical(
    frame_data(~a, ~b, NA, NULL, 1, 2),
    data_frame(a = c(NA, 1), b = list(NULL, 2))
  )
})

test_that("frame_data() errs appropriately on bad calls", {

  # invalid colname syntax
  expect_error(frame_data(a~b), "single argument")

  # invalid colname syntax
  expect_error(frame_data(~a + b), "symbol or string")

  # frame_data() must be passed colnames
  expect_error(frame_data(
    "a", "b",
    1, 2
  ))

  # frame_data() must produce rectangular structure (no filling)
  expect_error(frame_data(
    ~a, ~b, ~c,
    1, 2,
    3, 4, 5
  ))

})

test_that("frame_data can have list columns", {
  df <- frame_data(
    ~x, ~y,
    1,  list(a = 1),
    2,  list(b = 2)
  )
  expect_equal(df$x, c(1, 2))
  expect_equal(df$y, list(list(a = 1), list(b = 2)))
})
