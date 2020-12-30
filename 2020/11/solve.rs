use std::env;
use std::fs::File;
use std::io::{BufRead, BufReader};

type Seats = Vec<Vec<char>>;

fn explore (seats: &Seats,
            x: usize,
            xs: usize,
            y: usize,
            ys: usize,
            empty: bool,
            adjacent: bool) -> bool {

  macro_rules! ite { ($cond:expr, $if:expr, $else:expr) => {
    if $cond { $if } else { $else }
  }}

  macro_rules! N {($x:expr) => { $x > 0 }}
  macro_rules! S {($x:expr, $xs:expr) => { $x < $xs - 1 }}
  macro_rules! W {($y:expr) => { N!($y) }}
  macro_rules! E {($y:expr, $ys:expr) => { S!($y, $ys) }}
  macro_rules! NW {($x:expr, $y:expr) => { N!($x) & W!($y) }}
  macro_rules! NE {($x:expr, $y:expr, $ys:expr) => { N!($x) & E!($y, $ys) }}
  macro_rules! SW {($x:expr, $xs:expr, $y:expr) => { S!($x, $xs) & W!($y) }}
  macro_rules! SE {($x:expr, $xs:expr, $y:expr, $ys:expr) => { S!($x, $xs) & E!($y, $ys) }}

  enum Dir { N, S, W, E, NW, NE, SW, SE }

  type Scout = Option<(Dir, usize, usize)>;

  fn advance (o: &mut Scout, xs: usize, ys: usize) -> &mut Scout {
    match o {
      Some(s) => match s.0 {
        Dir::N  => ite!(N! (s.1             ),  s.1 -= 1           , *o = None),
        Dir::S  => ite!(S! (s.1, xs         ),  s.1 += 1           , *o = None),
        Dir::W  => ite!(W! (         s.2    ),            s.2 -= 1 , *o = None),
        Dir::E  => ite!(E! (         s.2, ys),            s.2 += 1 , *o = None),
        Dir::NW => ite!(NW!(s.1,     s.2    ), {s.1 -= 1; s.2 -= 1}, *o = None),
        Dir::NE => ite!(NE!(s.1,     s.2, ys), {s.1 -= 1; s.2 += 1}, *o = None),
        Dir::SW => ite!(SW!(s.1, xs, s.2    ), {s.1 += 1; s.2 -= 1}, *o = None),
        Dir::SE => ite!(SE!(s.1, xs, s.2, ys), {s.1 += 1; s.2 += 1}, *o = None),
      },
      None => {}
    }
    return o;
  }

  let mut scouts = [
    ite!(N! (x           ), Some((Dir::N,  x - 1, y    )), None),
    ite!(S! (x, xs       ), Some((Dir::S,  x + 1, y    )), None),
    ite!(W! (       y    ), Some((Dir::W,  x,     y - 1)), None),
    ite!(E! (       y, ys), Some((Dir::E,  x,     y + 1)), None),
    ite!(NW!(x,     y    ), Some((Dir::NW, x - 1, y - 1)), None),
    ite!(NE!(x,     y, ys), Some((Dir::NE, x - 1, y + 1)), None),
    ite!(SW!(x, xs, y    ), Some((Dir::SW, x + 1, y - 1)), None),
    ite!(SE!(x, xs, y, ys), Some((Dir::SE, x + 1, y + 1)), None)
  ];

  let mut num = 0;
  let max = if empty { 0 } else { if adjacent { 3 } else { 4 } };

  loop {
    for o in scouts.iter_mut() {
      match o {
        Some(s) => match seats[s.1][s.2] {
          '#' => {
            *o = None;
            num += 1;
            if num > max { return false; }
          },
          'L' => *o = None,
          _ => {}
        },
        None => {}
      }
    }
    if adjacent { break; }
    let mut done = true;
    for o in scouts.iter_mut() {
      match advance(o, xs, ys) {
        Some(_) => done = false,
        None => {}
      }
    }
    if done { break; }
  }

  return true;
}

fn occupied (seats: &mut Seats, adjacent: bool) -> usize {
  let xs = seats.len();
  let ys = seats[0].len();
  let mut cur_ptr: *mut Seats = &mut seats.clone();
  let mut prev_ptr: *mut Seats = &mut *seats;

  loop {
    let mut num = 0;
    let mut done = true;
    let cur: &mut Seats = unsafe { &mut *cur_ptr };
    let prev: &mut Seats = unsafe { &mut *prev_ptr };

    for x in 0..xs {
      for y in 0..ys {
        match prev[x][y] {
          'L' => {
            if explore(prev, x, xs, y, ys, true, adjacent) {
              done = false;
              cur[x][y] = '#';
            } else {
              cur[x][y] = 'L';
            }
          },
          '#' => {
            num += 1;
            if !explore(prev, x, xs, y, ys, false, adjacent) {
              done = false;
              cur[x][y] = 'L';
            } else {
              cur[x][y] = '#';
            }
          },
          _ => continue,
        }
      }
    }

    let tmp = cur_ptr;
    cur_ptr = prev_ptr;
    prev_ptr = tmp;

    if done { return num; }
  }
}

fn main () {
  let seats = BufReader::new(File::open(env::args().nth(1).unwrap()).unwrap())
                .lines()
                .map(|line| line.unwrap().chars().collect::<Vec<char>>())
                .collect::<Vec<_>>();
  // part 1
  println!("{}", occupied(&mut seats.clone(), true));
  // part 2
  println!("{}", occupied(&mut seats.clone(), false));
}
