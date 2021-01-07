use std::env;
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::collections::HashMap;

fn split (line : &String) -> [String; 2] {
  let delim = line.find('=').unwrap();
  return [line.chars().take(delim - 1).collect(),
          line.chars().skip(delim + 2).collect()];
}

fn idx (s: &str) -> u64 {
  return s.chars()
          .skip(4)
          .take(s.len() - 5)
          .collect::<String>()
          .parse()
          .unwrap();
}

fn part1 (lines : &Vec<String>) -> u64 {
  let mut m0 = 0u64;
  let mut m1 = 0u64;
  let mut mem = HashMap::new();
  for [op, arg] in lines.iter().map(split) {
    if op == "mask" {
      m0 = u64::from_str_radix(&arg.replace("X", "1"), 2).unwrap();
      m1 = u64::from_str_radix(&arg.replace("X", "0"), 2).unwrap();
      continue;
    }
    mem.insert(idx(&op), arg.parse::<u64>().unwrap() & m0 | m1);
  }
  return mem.values().sum();
}

fn part2 (lines : &Vec<String>) -> u64 {
  let mut floating = Vec::new();
  let mut m0 = 0u64;
  let mut m1 = 0u64;
  let mut mem = HashMap::new();
  for [op, arg] in lines.iter().map(split) {
    if op == "mask" {
      floating = arg.chars()
                    .enumerate()
                    .filter(|(_, x)| x == &'X')
                    .map(|(i, _)| 35 - i)
                    .collect::<Vec<_>>();
      m0 = !floating.iter().fold(0, |n, x| n | 1 << x);
      m1 = u64::from_str_radix(&arg.replace("X", "0"), 2).unwrap();
      continue;
    }
    let adr = idx(&op) & m0 | m1;
    let val = arg.parse::<u64>().unwrap();
    for i in 0..1 << floating.len() {
      let mut mask = 0u64;
      for j in 0..floating.len() {
        if i & (1 << j) != 0 {
          mask |= 1 << floating[j];
        }
      }
      mem.insert(adr | mask, val);
    }
  }
  return mem.values().sum();
}

fn main () {
  let lines = BufReader::new(File::open(env::args().nth(1).unwrap()).unwrap())
                .lines()
                .map(|line| line.unwrap())
                .collect::<Vec<_>>();
  println!("{}", part1(&lines));
  println!("{}", part2(&lines));
}
