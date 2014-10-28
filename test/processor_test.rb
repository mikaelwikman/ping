require 'test_helper'
require 'pingdom/processor'

class ProcessorTest < TestCase
  context 'process' do

    setup do
      @it = Processor.new
      @data = []
    end

    should 'no input yields no output' do
      assert_equal [], @it.process(@data)
    end

    should 'ignore UNCONFIRMED_DOWN' do
      @data << %w{irrelevant irrelevant irrelevant UNCONFIRMED_DOWN}
      assert_equal [], @it.process(@data)
    end

    context 'a single UP record' do

      setup do
        @data << %w{4 16 irrelevant UP}
      end

      should 'yield a single UP record with no end-time' do
        assert_equal [
          %w{16 4 -1 UP}
        ], @it.process(@data)
      end

      should 'ignore UNCONFIRMED_DOWN' do
        @data << %w{irrelevant irrelevant irrelevant UNCONFIRMED_DOWN}
        assert_equal [
          %w{16 4 -1 UP}
        ], @it.process(@data)
      end

      context 'plus another up record' do

        setup do
          @data << %w{5 16 irrelevant UP}
        end

        should 'ignore' do
          assert_equal [
            %w{16 4 -1 UP}
          ], @it.process(@data)
        end

        context 'plus a down record' do
          setup do
            @data << %w{256 16 irrelevant DOWN}
          end

          should 'up-record include end-time and add down-state' do
            assert_equal [
              %w{16 4 256 UP},
              %w{16 256 -1 DOWN}
            ], @it.process(@data)
          end
        end
      end

      context 'plus a down record' do

        setup do
          @data << %w{256 16 irrelevant DOWN}
        end

        should 'up-record include end time, and add down-state' do
          assert_equal [
            %w{16 4 256 UP},
            %w{16 256 -1 DOWN}
          ], @it.process(@data)
        end

        should 'ignore UNCONFIRMED_DOWN' do
          @data << %w{irrelevant irrelevant irrelevant UNCONFIRMED_DOWN}
          assert_equal [
            %w{16 4 256 UP},
            %w{16 256 -1 DOWN}
          ], @it.process(@data)
        end


        context 'another down record' do
          setup do
            @data << %w{256 16 irrelevant DOWN}
          end

          should 'ignore' do
            assert_equal [
              %w{16 4 256 UP},
              %w{16 256 -1 DOWN}
            ], @it.process(@data)
          end

          context 'switch back up, after being down' do
            setup do
              @data << %w{512 16 irrelevant UP}
            end

            should 'add end-time to down-record, and add another up-record' do
              assert_equal [
                %w{16 4 256 UP},
                %w{16 256 512 DOWN},
                %w{16 512 -1 UP},
              ], @it.process(@data)
            end
          end

          context 'add another unit' do
            setup do
              @data << %w{1024 8 irrelevant UP}
            end

            should 'add last, no effect on other unit' do
              assert_equal [
                %w{16 4 256 UP},
                %w{16 256 -1 DOWN},
                %w{8 1024 -1 UP}
              ], @it.process(@data)
            end

            context 'first unit up' do

              setup do
                @data << %w{2048 16 irrelevant UP}
              end

              should 'update end-time for first unit only and add record' do
                assert_equal [
                  %w{16 4 256 UP},
                  %w{16 256 2048 DOWN},
                  %w{8 1024 -1 UP},
                  %w{16 2048 -1 UP}
                ], @it.process(@data)
              end

              context 'second unit down' do
                setup do
                  @data << %w{4096 8 irrelevant DOWN}
                end

                should 'update end-time for second unit only and add record' do
                  assert_equal [
                    %w{16 4 256 UP},
                    %w{16 256 2048 DOWN},
                    %w{8 1024 4096 UP},
                    %w{16 2048 -1 UP},
                    %w{8 4096 -1 DOWN}
                  ], @it.process(@data)
                end
              end
            end
          end
        end
      end
    end
  end
end
