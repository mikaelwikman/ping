
class Processor

  CHECK_ID = 0
  START_TIME = 1
  END_TIME = 2


  def initialize sort=false
    @sort = sort
  end

  def process input
    out = []
    states = {}
    input.sort!{|a,b| a[0].to_i <=> b[0].to_i}

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

    if @sort
      out.sort! {|a,b| 
        s = a[CHECK_ID] <=> b[CHECK_ID]
        s = a[START_TIME].to_i <=> b[START_TIME].to_i if s == 0
        s
      }
    end

    out
  end
end
