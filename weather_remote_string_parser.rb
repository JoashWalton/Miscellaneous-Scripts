##
# This class parses a weather remote string and delivers a breakdown of string data and current settings being passed.

class WeatherRemoteString

  CONDITIONS_HASH = {
    0 => 'Unknown',
    1 => 'Sunny',
    2 => 'Partly Cloudy(day)',
    3 => 'Cloudy',
    4 => 'Rainy',
    5 => 'Snowy',
    6 => 'Thunderstorms',
    7 => 'Fog',
    8 => 'Clear',
    9 => 'Partly Cloudy(night)'
  }.freeze

  WEEKDAY_HASH = {
    0 => 'All',
    1 => 'Sunday',
    2 => 'Monday',
    3 => 'Tuesday',
    4 => 'Wednesday',
    5 => 'Thursday',
    6 => 'Friday',
    7 => 'Saturday',
  }.freeze

  weather_remote_string = ARGV[0].to_s # argument for script, weather remote string

  if weather_remote_string.length == 33 && weather_remote_string.match(/\A=W/)
    @current_temp_sign = weather_remote_string[2].to_i
    @current_temp = weather_remote_string[3..5]
    @current_condtion = weather_remote_string[6].to_i
    @tomorrow_high_temp_sign = weather_remote_string[7].to_i
    @tomorrow_high = weather_remote_string[8..10]
    @tomorrow_conditon = weather_remote_string[11].to_i
    @today_high_temp_sign = weather_remote_string[12].to_i
    @today_high = weather_remote_string[13..15]
    @today_condition = weather_remote_string[16].to_i
    @tomorrow_low_temp_sign = weather_remote_string[17].to_i
    @tomorrow_low = weather_remote_string[18..20]
    @today_low_temp_sign = weather_remote_string[21].to_i
    @today_low = weather_remote_string[22..24]
    @sunrise = weather_remote_string[25..28].to_s
    @sunset = weather_remote_string[29..32].to_s
  else
    puts "Weather remote string in invalid."
  end

  ##
  # Convert temperature string char to meaningful value.
  # @param [String] the temp sign values pruned from the weather remote string
  # @return [String] real world condition for the temperature sign, postive or negative temperatures
  def temp_sign_conversion(temp_sign)
    temp_sign == 0 ? sign ='Postive' : sign = 'Negative'
    sign
  end

  ##
  # Converts hex masked value to binary format and parses binary string as per spec
  # for weekday, time, and am/pm for sunrise and sunset values.
  # @param [String] the sunrise or sunset hex mask gleaned from the weather remote string
  # @return [String] statement with sunrise or sunset values for a weekday
  def suntime_conversion(sun_value)
    binary_sun_value = sun_value.hex.to_s(2).rjust(sun_value.size*4, '0')

    binary_sun_value[0].to_i == 0 ? daytime = 'am' : daytime = 'pm'

    weekday = (binary_sun_value[1] + binary_sun_value[2] + binary_sun_value[8]).to_i(2)

    hours_tens = binary_sun_value[3].to_i(2)
    hours_ones = (binary_sun_value[4] + binary_sun_value[5] + binary_sun_value[6] + binary_sun_value[7]).to_i(2)
    min_tens = (binary_sun_value[9] + binary_sun_value[10] + binary_sun_value[11]).to_i(2)
    min_ones = (binary_sun_value[12] + binary_sun_value[13] + binary_sun_value[14] + binary_sun_value[15]).to_i(2)


    "#{WEEKDAY_HASH[weekday]}, #{hours_tens}#{hours_ones}:#{min_tens}#{min_ones} #{daytime}"
  end

  p 'Weather Remote String Breakdown'
  p ''
  p "Current Temperature Sign - #{WeatherRemoteString.new.temp_sign_conversion(@current_temp_sign)}"
  p "Current Temperature - #{@current_temp.to_i}"
  p "Current Condition - #{CONDITIONS_HASH[@current_condtion]}"
  p ''
  p "Tomorrow's High Temperature Sign - #{WeatherRemoteString.new.temp_sign_conversion(@tomorrow_high_temp_sign)}"
  p "Tomorrow's High Temperature - #{@tomorrow_high.to_i}"
  p "Tomorrow's Condition - #{CONDITIONS_HASH[@tomorrow_condtion]}"
  p ''
  p "Today's High Temperature Sign - #{WeatherRemoteString.new.temp_sign_conversion(@today_high_temp_sign)}"
  p "Today's High Temperature - #{@today_high.to_i}"
  p "Today's Condition - #{CONDITIONS_HASH[@tomorrow_condtion]}"
  p ''
  p "Tomorrow's Low Temperature Sign - #{WeatherRemoteString.new.temp_sign_conversion(@tomorrow_low_temp_sign)}"
  p "Tomorrow's Low Temperature - #{@tomorrow_low.to_i}"
  p ''
  p "Today's Low Temperature Sign - #{WeatherRemoteString.new.temp_sign_conversion(@today_low_temp_sign)}"
  p "Today's Low Temperature - #{@today_low.to_i}"
  p ''
  p "Sunrise - #{WeatherRemoteString.new.suntime_conversion(@sunrise)}"
  p "Sunset - #{WeatherRemoteString.new.suntime_conversion(@sunset)}"

end
