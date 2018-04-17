class Listener
    def initialize(event_name : Symbol, &block)
        @event_name = event_name
        @block = block
    end

    def execute
        @block.call
    end

    def is?(event_name : Symbol)
        @event_name == event_name
    end
end