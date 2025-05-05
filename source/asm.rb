module ASM
  class << self
    attr_accessor :items

    def generate(items)
      @items = items
      <<~ASM
        #{headers}
        #{from_parsed_items}
        #{exit(0)}
      ASM
    end

    private

    def headers
      <<~HEADERS
        format ELF64

        section '.text' executable
        public _start

        extrn putchar
        extrn exit

        _start:
      HEADERS
    end

    def exit(code)
      <<EXIT
        mov rdi, #{code}
        call exit
EXIT
    end

    def from_parsed_items
      items.map do |it|
        <<RETURN
        mov rdi, #{it}
        call putchar
RETURN
      end.join
    end
  end
end
