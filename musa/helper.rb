def quantized_timed_series_of_p_array(p_array, quantization_step: 0.1)
  p_array.collect do |curve|
    curve.to_timed_serie(time_start_component: 2, base_duration: 1)
         .flatten_timed
         .split.instance
         .to_a
         .tap { |_| _.delete_at(2) } # we don't want time dimension itself to be quantized
         .collect do |_|
      # _.quantize(step: quantization_step, predictive: true, stops: false)
      _.quantize(step: quantization_step, predictive: true, stops: false)
       .anticipate do |_, c, n|
        if n
          c.clone.tap { |_| _[:next_value] = (c[:value].nil? || c[:value] == n[:value]) ? nil : n[:value] }
        else
          c
        end
      end
    end.then { |_| TIMED_UNION(*_) }
  end
end
