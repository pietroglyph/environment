use std::time::{Duration, Instant};
use std::thread::sleep;

fn main() {
    let update_delay = Duration::from_millis(1);
    let start_instant = Instant::now();

    // Maybe use a ticker crate here instead of loop 'n sleep
    loop {
        let elapsed = start_instant.elapsed();
        let elapsed_secs = elapsed.as_secs();
        let millis = elapsed.subsec_millis();
        let secs = elapsed_secs % 60;
        let mins = elapsed_secs / 60;
        print!("{}[2J", 27 as char);
        println!("{}\t{}\t{}", mins, secs, millis);
        sleep(update_delay);
    }
}
