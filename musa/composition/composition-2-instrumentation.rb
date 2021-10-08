require_relative 'composition-1-base'

require_relative '../orchestra/orchestra'
require_relative '../lib/instruments-pool'

class CompositionWithInstrumentation < CompositionBase
  def initialize(realtime: false, render3d: nil, do_voices_log: true)
    super

    # Create instruments
    #
    @orchestra = Orchestra.new(@sequencer, logger: @logger, do_voices_log: do_voices_log)

    # Separate instruments regarding mostly harmonic content vs less-harmonic content
    # Making a pool of each category
    #
    @harmonic_instruments = InstrumentsPool.new('harmonic', *@orchestra.select(:harmonic))
    @percussive_instruments = InstrumentsPool.new('percussion', *@orchestra.select(:percussion))

    @instruments_pools = (1..15).collect do |i|
      kinds = [(:strings if (i & 1).positive?),
               (:woodwinds if (i & 2).positive?),
               (:brass if (i & 4).positive?),
               (:percussion if (i & 8).positive?)].compact

      InstrumentsPool.new(kinds.join('+'), *@orchestra.select(*kinds))
    end

    @all_instruments = InstrumentsPool.new('all', *@orchestra.complete)
  end
end
