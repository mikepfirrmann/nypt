class PseudoTime
  include Comparable

  HOURS_IN_DAY = 24

  attr_reader :hours, :minutes, :seconds

  def initialize(time_string)
    @hours, @minutes, @seconds = time_string.split(':').map(&:to_i)
  end

  def <=>(other)
    unless other.is_a?(self.class)
      raise "#{self.class.name} objects can only be compared to other #{self.class.name} objects"
    end

    return -1 if @hours < other.hours
    return 1 if @hours > other.hours

    return -1 if @minutes < other.minutes
    return 1 if @minutes > other.minutes

    return @seconds <=> other.seconds
  end

  def real_local_time
    CalendarDate.local_time [@hours % HOURS_IN_DAY, @minutes, @seconds].join(':')
  end

  def to_s
    real_local_time.to_s
  end

end
