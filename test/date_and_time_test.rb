require './lib/date_and_time'
require_relative 'test_helper'

class DateTimeTest < Minitest::Test

  def setup
    @dateandtime = DateAndTime.new
  end

  def test_if_it_exists
    assert_instance_of DateAndTime, @dateandtime
  end

  def test_if_it_can_send_response_for_date_and_time_path
    path = "/datetime"

    assert_instance_of String, @dateandtime.date_time(path)
  end

  def test_its_response_to_incorrect_date_and_time_path
    path = "/hello"

    assert_nil nil, @dateandtime.date_time(path)
  end

end
