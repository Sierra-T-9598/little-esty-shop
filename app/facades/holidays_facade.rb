class HolidaysFacade
  class << self
    def get_holidays
      data = HolidayService.upcoming_us_holidays

      data.map do |holiday|
        Holiday.new(holiday)
      end
    end
  end
end
