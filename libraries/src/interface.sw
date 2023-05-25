library;

abi Counter {
    #[storage(write)]
    fn init(value: u64) -> u64;

    #[storage(read, write)]
    fn incr(amount: u64) -> u64;

    #[storage(read)]
    fn value() -> u64;
}
