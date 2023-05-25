script;

use libraries::Counter;

configurable {
    CONTRACT_ID: b256 = 0x4665c9137566b2d906573c4074965e1357c91999759af1def3f08eb7d9f5d7bc,
}

fn main() {
    let counter = abi(Counter, CONTRACT_ID);
    counter.incr(123);
}
