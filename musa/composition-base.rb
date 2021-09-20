require 'musa-dsl'
require 'unimidi'

require_relative 'probe-3d'

using Musa::Extension::InspectNice

class CompositionBase
  include Musa::MIDIVoices
  include Musa::Clock
  include Musa::Sequencer

  def initialize(real_clock: false, do_voices_log: true)
    # Sequencer setup
    #
    @sequencer, @clock = create_sequencer(real_clock)

    # Logging setup
    #
    @logger = configure_logs(@sequencer)

    @do_voices_log = do_voices_log

    # 3D rendering setup and base drawing
    #
    @probe = Probe3D.new(100, z_scale: 0.1, logger: @logger)
  end

  private def create_sequencer(real_clock)
    sequencer = Sequencer.new 4, 4, keep_proc_context: true
    clock = if real_clock
              TimerClock.new ticks_per_beat: 4, bpm: 90
            else
              DummyClock.new { !sequencer.empty? }
            end

    [sequencer, clock]
  end

  private def configure_logs(sequencer)
    sequencer.logger.error!

    logger = sequencer.logger.clone
    logger.info!

    logger
  end

  private def info(text)
    @logger.info(text)
  end

  private def debug(text)
    @logger.debug(text)
  end

  private def warn(text)
    @logger.warn(text)
  end

  private def error(text)
    @logger.error(text)
  end

  def run(&block)
    Thread.new do
      block.call

      # Thread.new { @clock.run { @sequencer.tick } }
      @clock.run { @sequencer.tick }

      sleep 0.1
      begin
        @clock.start
      rescue NoMethodError => e
        puts "Ignoring #{e.message}"
      end
    end

    @probe.run

    begin
      @clock.stop
    rescue NoMethodError => e
      puts "Ignoring #{e.message}"
    end
  end
end

