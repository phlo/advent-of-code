use std::env;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() {
  let (mut l, mut r): (Vec<i32>, Vec<i32>) =
    BufReader::new(File::open(env::args().nth(1).unwrap()).unwrap())
    .lines()
    .map(|line| {
      let l = line.unwrap();
      let (x, y) = l.split_once("   ").unwrap();
      return (x.parse::<i32>().unwrap(), y.parse::<i32>().unwrap());
    })
    .unzip();
  l.sort();
  r.sort();

  // part 1
  let distance: i32 = l.iter().zip(r.iter())
    .map(|(x, y)| (x - y).abs())
    .sum();
  println!("{}", distance);

  // part 2
  let similarity: i32 = l.iter()
    .map(|x| r.iter().filter(|y| x == *y).count() as i32 * x)
    .sum();
  println!("{}", similarity);
}
