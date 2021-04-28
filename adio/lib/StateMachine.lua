StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }

    self.states = states or {}
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)

    -- checking that stateName exists
    assert(self.states[stateName])

    -- first time exiting empty state
    self.current:exit()

    -- setting current to state passed and its methods
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
