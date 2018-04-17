require "./listener.cr"

module SignalCrystal
    property listeners = [] of Listener

    def on(event_name : Symbol, &block)
        @listeners << Listener.new(event_name, &block)
        self
    end

    def emit(event_name)
        listeners.each do |listener| 
            listener.execute if listener.is?(event_name)
        end
    end
end