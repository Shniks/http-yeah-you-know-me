require './lib/sequence'

class DateAndTime

  def date_time(path)
    date_time_response if path == "/datetime"
  end

  def date_time_response
    Time.now.strftime('%H:%M%p on %A, %B %d, %Y')
  end

end
