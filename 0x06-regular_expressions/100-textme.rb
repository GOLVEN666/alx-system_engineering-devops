#!/usr/bin/env ruby
x = ARGV[0].scan(/(?<=from:)\+?\w+/).join
y = ARGV[0].scan(/(?<=to:)\+?\w+/).join
z = ARGV[0].scan(/(?<=flags:)[-:0-9]+/).join
printf("%s,%s,%s\n", x, y, z)
