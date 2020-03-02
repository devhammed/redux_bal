# A record describing a state change.
#
# + id - A unique identifier representing the action.
# + payload - Extra data to pass to the reducer.
public type ReduxAction record {
    string id;
    any payload?;
};

# An anonymous function that returns new state when an action is dispatched.
#
# + state - The previous state.
# + action - The action that is been dispatched.
# + return - The new state.
public type ReduxReducer (function (any state, ReduxAction action) returns any);

# An anonymous function that listens to state changes.
#
# + state - The current state after reducing.
# + return - Nothing.
public type ReduxSubscriber (function (any state));

# An object that contains the state, subscribers and reducers.
#
# + currentState - The current state of this store instance.
# + currentReducer - The anonymous function that effects state changes.
# + subcribers - The list of anonymous functions that is listening to state changes.
public type ReduxStore object {
    private any currentState;
    private ReduxReducer currentReducer;
    private ReduxSubscriber[] subcribers = [];
    private ReduxAction initAction = {
        id: "DEVHAMMED/REDUX_BAL@@INIT"
    };

    # Constructs a new store instance.
    #
    # + reducer - The anonymous function that effects state changes.
    # + initialState - The initial state of the store instance.
    public function __init(ReduxReducer reducer, any initialState = ()) {
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
    public function subscribe(ReduxSubscriber subscriber) {
        self.subcribers.push(subscriber);
    }

    # Dispatch an action that changes the state.
    #
    # + action - record describing a state change.
    public function dispatch(ReduxAction action) {
        var reducer = self.getCurrentReducer();
        self.currentState = reducer(self.currentState, action);
        self.subcribers.forEach(function (ReduxSubscriber sub) {
            sub(self.currentState);
        });
    }

    # Replace the store instance reducer.
    #
    # + reducer - The new state reducer.
    public function replaceReducer(ReduxReducer reducer) {
        self.currentReducer = reducer;
        self.dispatch(self.initAction);
    }

    # Get the current store's reducer.
    #
    # + return - The anonymous function that effects state changes.
    private function getCurrentReducer() returns ReduxReducer {
        return self.currentReducer;
    }
};
