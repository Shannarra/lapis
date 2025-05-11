module Kernel
  # https://stackoverflow.com/a/11455651/11542917
  def enum(values)
    Module.new do |mod|
      values.each_with_index { |v, _i| mod.const_set(v, v.to_s) }

      def mod.inspect
        "#{name} {#{constants.join(', ')}}"
      end
    end
  end

  def todo!
    call = caller(1, 1).first

    eputs "Not implemented yet #{call}"
  end

  def wputs(text, position = [])
    print_with_position('WARN', text, position)
  end

  def eputs(text, position = [])
    print_with_position('ERROR', text, position)
    exit(1)
  end

  private

  def print_with_position(type, text, position = [])
    at = " at #{position.first}:#{position.last}"
    msg = "[#{type}]: #{text}"

    msg += at unless position.empty?

    puts msg
  end
end
