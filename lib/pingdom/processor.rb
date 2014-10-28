
class Processor

  END_TIME = 2

  def initialize sort=false
    @sort = sort
  end

  def process input
    out = []
    states = {}

    input.each do |timestamp, checkid, responsetime, status|
      previous_status, previous_record = states[checkid]
      unless status == previous_status || status == 'UNCONFIRMED_DOWN'

        case status
        when 'UP'
          out << [checkid, timestamp, '-1', 'UP']
          previous_record[END_TIME] = timestamp if previous_record
        when 'DOWN'
          out << [checkid, timestamp, '-1', 'DOWN']
          previous_record[END_TIME] = timestamp if previous_record
        else
          # bad data, skip
          next
        end

        states[checkid] = [status, out.last]
      end
    end

    out.sort!{|a,b| a[0] <=> b[0]} if @sort

    out
  end
end
