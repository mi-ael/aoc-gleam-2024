import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let file_path = "inputs/day02"
  let assert Ok(file) = simplifile.read(file_path)
  let lines = file |> string.split("\n") |> list.filter(fn(l) { l != "" })

  let safe_reports =
    lines
    |> list.map(fn(line) {
      // Parse each line into a list of integers
      let levels =
        line
        |> string.split(" ")
        |> list.filter_map(int.parse)
      
      is_safe_report(levels)
    })
    |> list.filter(fn(is_safe) { is_safe })
    |> list.length

  io.println("answer part 1: " <> int.to_string(safe_reports))
}

fn is_safe_report(levels: List(Int)) -> Bool {
  // Check if there are at least two levels
  case levels {
    [] | [_] -> False
    _ -> {
      // Check if all differences are between 1 and 3 (inclusive)
      let differences =
        list.window_by_2(levels)
        |> list.map(fn(pair) { pair.1 - pair.0 })
      
      // All differences must have the same sign (all increasing or all decreasing)
      let all_same_direction =
        differences
        |> list.all(fn(diff) {
          case differences {
            [first, ..] -> 
              // Check if all differences have the same sign as the first one
              case first > 0 {
                True -> diff > 0  // All should be positive
                False -> diff < 0  // All should be negative
              }
            _ -> True  // Only one difference, so direction is consistent
          }
        })
      
      // All differences must be between 1 and 3 in absolute value
      let all_valid_differences =
        differences
        |> list.all(fn(diff) {
          let abs_diff = int.absolute_value(diff)
          abs_diff >= 1 && abs_diff <= 3
        })
      
      all_same_direction && all_valid_differences
    }
  }
}
