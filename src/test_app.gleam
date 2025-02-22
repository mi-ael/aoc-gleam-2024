import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  // let file_path = "inputs/day01"
  let file_path = "inputs/day01"
  let assert Ok(file) = simplifile.read(file_path)
  let lines = file |> string.split("\n") |> list.filter(fn(l) { l != "" })

  let #(left, right) =
    lines
    |> list.map(fn(l) {
      let assert Ok(#(first, rest)) = l |> string.split_once(" ")
      let second = rest |> string.trim()
      let assert Ok(first) = first |> int.parse()
      let assert Ok(second) = second |> int.parse()
      #(first, second)
    })
    |> list.unzip
  let left = left |> list.sort(int.compare)
  let right = right |> list.sort(int.compare)

  let answer_1 =
    list.zip(left, right)
    |> list.map(fn(t) { t.0 - t.1 |> int.absolute_value })
    |> int.sum
  io.println("answer part 1: " <> int.to_string(answer_1))

  let answer_2 =
    cartesian_product(left, right)
    |> list.fold(0, fn(acc, t) {
      case t {
        #(a, b) if a == b -> acc + a
        _ -> acc
      }
    })
  io.println("answer part 2: " <> int.to_string(answer_2))
}

fn cartesian_product(left: List(a), right: List(b)) -> List(#(a, b)) {
  left
  |> list.map(fn(l) {
    right
    |> list.map(fn(r) { #(l, r) })
  })
  |> list.flatten
}
