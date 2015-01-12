# -*- coding: utf-8 -*-
module CzechUtils
  private
  # ... by Frantisek Havluj
  def strip_cs_chars(src)
    accented_chars  = 'éěřťýúůíóášďžčňÉĚŘŤÝÚŮÍÓÁŠĎŽČŇ'
    ascii_chars     = 'eertyuuioasdzcnEERTYUUIOASDZCN'
    dest = src.dup

    (0...accented_chars.mb_chars.length).each do |i|
      dest.gsub!(accented_chars.mb_chars[i..i], ascii_chars[i..i])
    end

    dest
  end

end
