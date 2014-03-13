context("YAML Metadata")

test_that("metadata location is NULL when not present", {
  missing1 <- "abc"
  missing2 <- "\n---\nabc\n---"
  missing3 <- "---\n"

  expect_null(locate_metadata(missing1))
  expect_null(locate_metadata(missing2))
  expect_null(locate_metadata(missing3))

})
