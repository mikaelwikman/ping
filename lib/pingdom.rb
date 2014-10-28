require 'pingdom/processor'

sort = eval(ARGV.shift.to_s)
p = Processor.new(sort)

raw_data = STDIN.readlines.map{|r| r.split(',').map{|e| e.strip}}
raw_data.shift

aggregated_data = p.process(raw_data)

aggregated_data.each do |checkid, start_time, end_time, status|
  printf "%-3s %-10s %-10s %17s\n", checkid, start_time, end_time, status
end
