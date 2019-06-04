module BackHelper
  # helpers are really great because a lot of the time views get bulky with a  bunch of logic
  def am
    #helper method here are for taking logic out of the views
     @am = number_with_delimiter(@temperature[0][:ambientTemperature], :delimiter => '.')
     @pt = number_with_delimiter(@temperature[0][:probeTemperature], :delimiter => '.') 
     @humi = @humidity[0][:humidity]
  end

  def ambient?
    if @am.nil?
      nil
    else
      @am
    end
  end
end
