puts ARGF.each_line.map { |line| line.split.map(&:to_i) }.count { |tri| tri[0] + tri[1] > tri[2] && tri[0] + tri[2] > tri[1] && tri[1] + tri[2] > tri[0] }
