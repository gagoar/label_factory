module LabelFactory
  module Layout
    class Length

    	attr_accessor :value, :unit, :number

    	def initialize(value)
    		@value = value
    		@number = value.match(/[\d\.]*/)[0].to_f
    		@unit = value.delete("#{number}").strip
    	end

    	#Return the numeric portion as a Points
    	def as_pts
    		if @unit =~ /pt/
    			return @number
    		elsif @unit =~ /in/
    			return @number * 72 #72.270
    		elsif @unit =~ /mm/
    			return @number * 2.83464566929134
    		elsif @unit =~ /cm/
    			return @number * 28.3464566929134
    		elsif @unit =~ /pc/
    			return 1.0 * @number / 12
    		elsif @unit == ''
    			return @number
    		else
    			raise "Unit #{unit} unknown"
    		end
    	end
    end
  end
end
