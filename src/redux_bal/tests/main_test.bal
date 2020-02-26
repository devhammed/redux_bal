import ballerina/io;
import ballerina/test;

type State record {
    int counter;
    string name;
};

function counterReducer(any state, Action action) returns State {
    var s = <State>state;

    if (action.id === "INC") {
        s["counter"] = s.counter + 1;
    }

    if (action.id === "DEC") {
        s["counter"] = s.counter - 1;
    }

    if (action.id === "SET") {
        s["counter"] = <int>action?.payload;
    }

    return s;
}

@test:Config {}
function testReducer() {
    State initialState = {counter: 0, name: "Reduxy"};

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
