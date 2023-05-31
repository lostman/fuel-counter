# Contract

COUNTER_SOURCES := $(wildcard contracts/counter/src/*.sw libraries/src/*.sw)

COUNTER_ABI := contracts/counter/out/release/counter-abi.json

CONTRACT_ID := $(shell cd contracts/counter/ && forc contract-id 2>/dev/null | grep 'Contract id' | sed 's/\ *Contract id: //')

$(COUNTER_ABI): $(COUNTER_SOURCES)
	cd contracts/counter/ && forc build --release

# Indexer

INDEXER_SOURCES := indexers/counter_indexer/counter_indexer.manifest.yaml indexers/counter_indexer/Cargo.toml indexers/counter_indexer/schema/counter_indexer.schema.graphql $(wildcard indexers/counter_indexer/src/*.rs)

INDEXER := target/wasm32-unknown-unknown/release/counter_indexer.wasm

$(INDEXER): $(INDEXER_SOURCES) $(COUNTER_ABI)
	cd indexers/counter_indexer/ && forc index build

# Tasks

contract-id:
	@echo "$(CONTRACT_ID)"

deploy-contract: $(COUNTER_ABI)
	cd contracts/counter/ && forc deploy --unsigned

deploy-indexer: $(INDEXER)
	cd indexers/counter_indexer/ && forc index deploy

run-script:
	cd scripts/incr_script/ && forc run --release --unsigned --contract $(CONTRACT_ID)

all: deploy-contract deploy-indexer run-script

.DEFAULT_GOAL := all

clean:
	rm -rf contracts/counter/out libraries/out scripts/incr_script/out/ indexers/counter_indexer/target
