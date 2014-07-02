module Import
  module XmlHelper

    YES_VALS = ["yes", "on", "true", "1"]
    # '' should't be here according to specification, but 2009 XML uses it
    FALSE_VALS = ["false", "no", "off", "false", "0", '']

    def parse_fee(node, wc)
      fnode = node.elements['extrafee']

      if fnode
        wc.extra_fee = to_integer(node, 'extrafee')
        wc.extra_fee_currency = to_text(node, 'extrafee_currency') if wc.extra_fee
      end
    end

    def parse_intentions(node, wc)
      wnode = node.elements['work']

      if wnode.nil? or wnode.text.nil?
        warning("WARNING: 'work' tag not present")
        return
      else
        import_intentions(wnode.text, wc)
      end
    end

    # DRY
    def to_integer(wc_node, subnode)
      found = wc_node.elements[subnode]
      found and (not found.text.blank?) ? found.text.to_i : nil
    end

    # DRY
    def to_decimal(wc_node, subnode)
      found = wc_node.elements[subnode]
      found and (not found.text.blank?) ? found.text.to_f : nil
    end


    def to_date(wc_node, subnode, format = '%Y-%m-%d')
      found = wc_node.elements[subnode]

      if found
        begin
          parsed = DateTime.strptime(found.text.strip, format)
        rescue ArgumentError => e
          parsed = nil
        end
        raise "Failed to parse date #{found.text}" unless parsed
        parsed.to_date
      else
        nil
      end
    end

    def to_text(node, subnode)
      found = node.elements[subnode]

      if found.blank?
        nil
      else
        result = XmlHelper::fix_quotes(found.text.try(:strip) || '')
        coder = HTMLEntities.new('expanded')
        # UN-NICE: sometimes there is &amp;Atilde; or similar garbage so we have to run decode twice
        coder.decode(coder.decode(result))
      end
    end

    def to_bool(node, subnode)
      found = node.elements[subnode]

      if found and found.text
        token = found.text.strip.downcase
        return YES_VALS.include?(token)
        # return false if FALSE_VALS.include?(token)
        # Rails.logger.warn("Invalid boolean value in XML: '#{token}'")
      end

      false
    end

    protected

    def self.fix_quotes(text)
      r1 = Regexp.new(WRONG_CHARS[0] + '|' + WRONG_CHARS[1])
      r2 = Regexp.new(WRONG_CHARS[2] + '|' + WRONG_CHARS[3])
      result = text.dup
      result.gsub!(r1, "'")
      result.gsub!(r2, '"')
      result
    end

    # 'wrong' UTF-8 characters that shall be replacesd by ' and " by fix_quotes
    WRONG_CHARS = [ ActiveSupport::Multibyte::Chars.new([0x0091].pack('U')),
                    ActiveSupport::Multibyte::Chars.new([0x0092].pack('U')),
                    ActiveSupport::Multibyte::Chars.new([0x0093].pack('U')),
                    ActiveSupport::Multibyte::Chars.new([0x0094].pack('U')) ]

  end
end
