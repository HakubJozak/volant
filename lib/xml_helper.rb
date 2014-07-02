module XmlHelper

  YES_VALS = ["yes", "on", "true", "1" ]
  # '' should't be here according to specification, but 2009 XML uses it
  FALSE_VALS = ["false","no", "off", "false", "0", '' ]

  COMPATIBILITY_TABLE = {"CONC"=>"CONS",
                         "REFU"=>"REFUGEE",
                         "ENV"=>"ENVI",
                         "DIS"=>"DISA",
                         "DISABLED" => "DISA",
                         "ART"=>"ARTS",
                         "STUD"=>"STUDY", "REN"=>"RENO", "KID"=>"KIDS",
                         "EDUC"=>"EDU",
                         "MANUAL"=>"MANU",
                         "YOUTH"=>"TEEN"}

  # 'wrong' UTF-8 characters that shall be replacesd by ' and " by fix_quotes
  WRONG_CHARS = [ ActiveSupport::Multibyte::Chars.compose([0x0091]),
                  ActiveSupport::Multibyte::Chars.compose([0x0092]),
                  ActiveSupport::Multibyte::Chars.compose([0x0093]),
                  ActiveSupport::Multibyte::Chars.compose([0x0094]) ]


  def parse_fee( node, wc)
    fnode = node.elements['extrafee']

    if fnode
      wc.extra_fee = to_integer(node, 'extrafee')
      wc.extra_fee_currency = fnode.attributes['currency'] if wc.extra_fee
    end
  end

  def parse_intentions(node, warnings, wc)
    wnode = node.elements['work']

    if wnode == nil or wnode.text == nil
      warnings << "WARNING: 'work' tag not present"
      puts warnings.last
      return
    else
      # '/' should be enough as pattern
      # but once again - 2009 XML contains 'work' tags delimited by '-' and ','
      wnode.text.upcase.split(/\/|-|,/).each do |c|
        c = COMPATIBILITY_TABLE[c] || c
        intention = WorkcampIntention.find_by_code(c)

        if intention
          wc.intentions << intention
        else
          warnings << "WARNING: unknown work code '#{c}' in '#{wc.code}'"
          puts warnings.last
        end
      end
    end
  end

  def to_integer(wc_node, subnode )
    found = wc_node.elements[subnode]
    found and (not found.text.blank?) ? found.text.to_i : nil
  end

  def to_date(wc_node, subnode, format = '%Y-%m-%d')
    found = wc_node.elements[subnode]

    if found
      parsed = DateTime.strptime(found.text.strip, format)
      raise "Failed to parse date #{found.text}" unless parsed
      parsed.to_date
    else
      nil
    end
  end

  def to_text(node, subnode)
    found = node.elements[subnode]
    found.blank? ? nil : XmlHelper::fix_quotes(found.text.strip)
  end

  def to_bool(node, subnode)
    found = node.elements[subnode]

    if found and found.text
      token = found.text.strip.downcase
      return true if YES_VALS.include?(token)
      return false if FALSE_VALS.include?(token)
      raise "Invalid boolean value in XML: '#{token}'"
    else
      false
    end
  end

  protected

  def self.fix_quotes(text)
    r1 = Regexp.new(WRONG_CHARS[0] + '|' + WRONG_CHARS[1])
    r2 = Regexp.new(WRONG_CHARS[2] + '|' + WRONG_CHARS[3])
    result = text.dup
    result.gsub!(r1,"'")
    result.gsub!(r2,'"')
    result
  end


end
