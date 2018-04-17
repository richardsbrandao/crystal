require "./signal_crystal"

class Wheather
	getter :date, :max, :min, :time, :wind

	def initialize(date : (Time | Nil), max : (Int32 | Nil), min : (Int32 | Nil), time : (String | Nil), wind : (Int32 | Nil))
		@date = date
		@max = max
		@min = min
		@time = time 
		@wind = wind
	end

    def nil_object?
        @date.nil? && @max.nil? && @min.nil? && @time.nil? && @wind.nil?
    end
	def to_s
		"date: #{date}-max: #{max}-min: #{min}-time: #{time}-wind: #{wind}"
	end
end

class Forecast < Hash(String, Wheather)
    def get(date : Time)
		self.fetch("#{date.year},#{date.month},#{date.day}", Wheather.new(nil, nil, nil, nil, nil))
	end
end

class Timer 
	include SignalCrystal
	getter :today

	def initialize(@forecast : Forecast)
		@today = Time.new(2016,11,1)
		on(:no_prevision) { notice_no_prevision! }
		on(:umbrella) { notice_umbrella! }
	end

	def next!
		@today = @today + 1.day
		check!
	end

	def notice_no_prevision!
		puts "#{@today} - Não tem previsão para hoje"
	end

	def notice_umbrella!
		puts "#{@today} - Traga um guardachuva pq hj vai chover"
	end

	private def check!
		emit(:no_prevision) unless prevision?
		emit(:umbrella) if umbrella?
	end

    private def prevision?
		! @forecast.get(@today).nil_object?
	end

    private def umbrella?
		prevision? && @forecast.get(@today).time == "CHUVA"
	end
end

a = Wheather.new(Time.new(2016,11,2), 30, 22, "SOL", 		10)
b = Wheather.new(Time.new(2016,11,3), 32, 24, "SOL", 		12)
c = Wheather.new(Time.new(2016,11,4), 22, 17, "NUBLADO", 	20)
d = Wheather.new(Time.new(2016,11,5), 17, 14, "CHUVA", 		9)

f = Forecast.new
f["2016,11,2"] = a
f["2016,11,3"] = b
f["2016,11,4"] = c
f["2016,11,5"] = d

timer = Timer.new(f)
timer.next!
timer.next!
timer.next!
timer.next!
timer.next!