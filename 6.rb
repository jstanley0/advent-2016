puts ARGF.each_line.map(&:chars).transpose.map{|chars|chars.group_by(&:itself).to_a.min_by{|a|a.last.size}.first}.join
