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

  def wputs(text)
    puts "[WARN]: #{text}"
  end

  def eputs(text)
    puts "[ERROR]: #{text}"
    exit(1)
  end
end
