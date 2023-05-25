contract;

use libraries::Counter;

storage {
    counter: u64 = 0,
}

struct Incr {
    value: u64,
}

impl Counter for Contract {
    #[storage(write)]
    fn init(value: u64) -> u64 {
        storage.counter.write(value);
        value
    }

    #[storage(read, write)]
    fn incr(amount: u64) -> u64 {
        let incremented = storage.counter.read() + amount;
        storage.counter.write(incremented);
        log(Incr{ value: incremented });
        incremented
    }
    #[storage(read)]
    fn value() -> u64 {
        storage.counter.read()
    }
}

#[test]
fn test_incr() {
    let counter = abi(Counter, CONTRACT_ID);
    let counter_2 = abi(Counter, CONTRACT_ID);

    assert(counter.value() == 0);
    assert(counter_2.value() == 0);

    // counter, counter_2: same thing!
    counter.incr(1);

    assert(counter.value() == 1);
    assert(counter_2.value() == 1);

    // counter, counter_2: same thing!
    counter_2.incr(1);

    assert(counter.value() == 2);
    assert(counter_2.value() == 2);
}
