
# Ping\* test

This project is designed to be run with Ruby 2.1 (tested only with 2.1.1), using bundler to install dependencies. Using a Ruby Version manager such as RVM, chruby or rbenv, this version will be automatically prompted upon execution.

# Assumptions

* State changes at given timstamp, not after the response time
* The last state has no end-time, in which case -1 is used
* There are some faulty lines in test-file. Faulty lines will be ignored.
