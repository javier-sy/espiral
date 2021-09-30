require 'musa-dsl'
require 'unimidi'
require 'forwardable'

require_relative '../lib/probe-3d'

using Musa::Extension::InspectNice

class CompositionBase
  include Musa::MIDIVoices
  include Musa::Clock
  include Musa::Sequencer

  def initialize(realtime: false, render3d: false, do_voices_log: true)
    # Sequencer setup
    #
    @sequencer, @clock = create_sequencer(realtime)

    # Logging setup
    #
    @logger = configure_logs(@sequencer)

    @do_voices_log = do_voices_log

    # 3D rendering setup and base drawing
    #
    @probe = Probe3D.new(100, z_scale: 0.1, logger: @logger) if render3d
  end

  private def create_sequencer(real_clock)
    sequencer = Sequencer.new 4, 24, keep_proc_context: true, do_error_log: true

    clock = ClockProxy.new(if real_clock
                             TimerClock.new ticks_per_beat: 24, bpm: 90, delayed_ticks_error: 1, logger: sequencer.logger, do_log: true
                           else
                             DummyClock.new { !sequencer.empty? }
                           end)

    [sequencer, clock]
  end

  private def configure_logs(sequencer)
    sequencer.logger.error!

    logger = sequencer.logger.clone
    logger.warn!

    logger
  end

  private def info(text, force: false)
    previous_level = @logger.level
    @logger.level = Logger::INFO if force
    @logger.info(text)
    @logger.level = previous_level if force
  end

  private def debug(text, force: false)
    previous_level = @logger.level
    @logger.level = Logger::DEBUG if force
    @logger.debug(text) if force
    @logger.level = previous_level if force
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

      Thread.new do
        @clock.run do
          @sequencer.tick
        end
      end

      sleep 0.1

      @clock.start
    end

    @probe&.run
    gets unless @probe

    @clock.stop
  end
end

class ClockProxy
  extend Forwardable

  def initialize(clock)
    @clock = clock
  end

  def_delegator :@clock, :run

  def start
    @clock.start if @clock.respond_to?(:start)
  end

  def stop
    @clock.stop if @clock.respond_to?(:stop)
  end

  def bpm=(value)
    if @clock.respond_to?(:bpm=)
      @clock.bpm = value
    else
      @bpm = value
    end
  end

  def bpm
    if @clock.respond_to?(:bpm)
      @clock.bpm
    else
      @bpm
    end
  end
end