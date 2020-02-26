Implementation of Redux in Ballerina.
[//]: # (above is the module summary)

## Module Overview

```ballerina
type State record {
    int counter;
};

function counterReducer(any state, Action action) returns State {
    var s = <State>state;

    match action.id {
        "INC" => {
            s["counter"] = s.counter + 1;
        }

        "DEC" => {
            s["counter"] = s.counter - 1;
        }

        "SET" => {
            s["counter"] = <int>action?.payload;
        }
    }

    return s;
}

public function main() {
  State initialState = {counter: 0};

    var store = new Store(counterReducer, initialState);

    store.subscribe(function (any state) {
        io:print("Current State: ");
        io:println(state);
        io:println("");
    });

    io:println("Dispacting INC...");
    store.dispatch({
        id: "INC"
    });

    io:println("Dispacting INC...");
    store.dispatch({
        id: "INC"
    });

    io:println("Dispacting SET to 5...");
    store.dispatch({
        id: "SET",
        payload: 5
    });

    io:println("Dispacting DEC...");
    store.dispatch({
        id: "DEC"
    });
}
```
