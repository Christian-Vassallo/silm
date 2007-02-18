#!/usr/bin/ruby -w
require 'faerunian_calendar'

p FaerunianDate.strftime("%y (The year of %Y), %d of %M, %h:%m:%s", 1368, 1, 29, 5, 8, 0)
