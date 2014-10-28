
# Ping\* test

This project is designed to be run with Ruby 2.1 (tested only with 2.1.1), using bundler to install dependencies. Using a Ruby Version manager such as RVM (recommended), chruby or rbenv, this version will be automatically detected upon execution.

After installing Ruby, make sure to install bunlder:
`gem install bundler`

... and install the dependencies by running (from root dir):
`bundle install`

# Assumptions

* State changes at given timstamp, response time is ignored
* The last state has no end-time, in which case -1 is used
* There are some faulty lines in test-file. Faulty lines will be ignored.
* The data in the test-file is out-of-order. Assuming, for the scope of this exercise, that ordering may be done as a separate step before processing, rather than modifying historical data based on late arrival of the same. In reality the other approach would be undoubtedly be the better one. 

# Tests

You may find the tests located in the `test/` folder. These can be run by executing (from root dir):
`ruby -Itest test/*_test.rb`

# Execution

The application must be run from the root dir. CSV file is read from standard input:

`ruby -Ilib lib/pingdom.rb < results201306.csv` (csv file not included in repo)

There is also an option to sort by unit (checkid), add the word 'true':

`ruby -Ilib lib/pingdom.rb true < results201306.csv`
