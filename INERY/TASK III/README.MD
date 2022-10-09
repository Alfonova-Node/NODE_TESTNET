# Inery create CRUD contract

## Official docs
- [Inery write contract](https://docs.inery.io/docs/category/contract-write)
- [Inery CRUD contract](https://docs.inery.io/docs/category/create-crud-contract)

## Install build-dep
```
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5
```

## Set inery accname env vars
```
IneryAccname=<FILL_YOUR_ACOOUNT_NAME> # view on testnet dashboard
```
##Get binary inery.cdt tools

#### Clone from official github

```
cd ~
git clone https://github.com/inery-blockchain/inery.cdt
```

#### Set as env vars

temporary vars:
```
export PATH=$PATH:$HOME/inery.cdt/bin/
```
or permanent vars;
```
export PATH=$PATH:$HOME/inery.cdt/bin/ >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Write and compile contract

#### Make directrory

```
mkdir -p inrcrud
```

#### Write code

```
tee inrcrud/inrcrud.cpp >/dev/null <<EOF
#include <inery/inery.hpp>
#include <inery/print.hpp>
#include <string>

using namespace inery;

using std::string;

class [[inery::contract]] inrcrud : public inery::contract {
  public:
    using inery::contract::contract;


        [[inery::action]] void create( uint64_t id, name user, string data ) {
            records recordstable( _self, id );
            auto existing = recordstable.find( id );
            check( existing == recordstable.end(), "record with that ID already exists" );
            check( data.size() <= 256, "data has more than 256 bytes" );

            recordstable.emplace( _self, [&]( auto& s ) {
               s.id         = id;
               s.owner      = user;
               s.data       = data;
            });

            print( "Hello, ", name{user} );
            print( "Created with data: ", data );
        }

         [[inery::action]] void read( uint64_t id ) {
            records recordstable( _self, id );
            auto existing = recordstable.find( id );
            check( existing != recordstable.end(), "record with that ID does not exist" );
            const auto& st = *existing;
            print("Data: ", st.data);
        }

        [[inery::action]] void update( uint64_t id, string data ) {
            records recordstable( _self, id );
            auto st = recordstable.find( id );
            check( st != recordstable.end(), "record with that ID does not exist" );


            recordstable.modify( st, get_self(), [&]( auto& s ) {
               s.data = data;
            });

            print("Data: ", data);
        }

            [[inery::action]] void destroy( uint64_t id ) {
            records recordstable( _self, id );
            auto existing = recordstable.find( id );
            check( existing != recordstable.end(), "record with that ID does not exist" );
            const auto& st = *existing;

            recordstable.erase( st );

            print("Record Destroyed: ", id);

        }

  private:
    struct [[inery::table]] record {
       uint64_t        id;
       name     owner;
       string          data;
       uint64_t primary_key()const { return id; }
    };

    typedef inery::multi_index<"records"_n, record> records;
 };
EOF

```

#### Compile code

```
inery-cpp inrcrud/inrcrud.cpp -o inrcrud/inrcrud.wasm
```
## Deploy contract

#### First unlock wallet

```
cline wallet unlock --password 
```

#### Set contract

```
cline set contract $IneryAccname ./inrcrud
```

## Make push contract transaction

- `create` action

```
cline push action $IneryAccname create "[1, $IneryAccname, My first Record]" -p $IneryAccname -j
```

- `read` action

```
cline push action $IneryAccname read [1] -p $IneryAccname -j
```

- `update` action

```
cline push action $IneryAccname update '[ 1,  "My first Record Modified"]' -p $IneryAccname -j
```

- `destroy` action
```bash
cline push action $IneryAccname destroy [1] -p $IneryAccname -j
```

