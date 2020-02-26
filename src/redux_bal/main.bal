# A record describing a state change.
#
# + id - A unique identifier representing the action.
# + payload - Extra data to pass to the reducer.
public type Action record {
    string id;
    any payload?;
};

# An anonymous function that returns new state when an action is dispatched.
#
# + state - The previous state.
# + action - The action that is been dispatched.
# + return - The new state.
public type Reducer (function (any state, Action action) returns any);

# An anonymous function that listens to state changes.
#
# + state - The current state after reducing.
# + return - Nothing.
public type Subscriber (function (any state));

# An object that contains the state, subscribers and reducers.
#
# + currentState - The current state of this store instance.
# + currentReducer - The anonymous function that effects state changes.
# + subcribers - The list of anonymous functions that is listening to state changes.
public type Store object {
    private any currentState;
    private Reducer currentReducer;
    private Subscriber[] subcribers = [];
    private Action initAction = {
        id: "DEVHAMMED/REDUX_BAL@@INIT"
    };

    # Constructs a new store instance.
    #
    # + reducer - The anonymous function that effects state changes.
    # + initialState - The initial state of the store instance.
    public function __init(Reducer reducer, any initialState = ()) {
        self.currentReducer = reducer;
        self.currentState = initialState;
        self.dispatch(self.initAction);
    }

    # Get the current state of the store.
    #
    # + return - current state.
    public function getState() returns any {
        return self.currentState;
    }

    # Subscribe to state changes.
    #
    # + subscriber - An anonymous function that listens to state changes.
    public function subscribe(Subscriber subscriber) {
        self.subcribers.push(subscriber);
    }

    # Dispatch an action that changes the state.
    #
    # + action - record describing a state change.
    public function dispatch(Action action) {
        var reducer = self.getCurrentReducer();
        self.currentState = reducer(self.currentState, action);
        self.subcribers.forEach(function (Subscriber sub) {
            sub(self.currentState);
        });
    }

    # Replace the store instance reducer.
    #
    # + reducer - The new state reducer.
    public function replaceReducer(Reducer reducer) {
        self.currentReducer = reducer;
        self.dispatch(self.initAction);
    }

    # Get the current store's reducer.
    #
    # + return - The anonymous function that effects state changes.
    private function getCurrentReducer() returns Reducer {
        return self.currentReducer;
    }
};
