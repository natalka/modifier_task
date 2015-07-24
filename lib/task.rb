require 'csv'
require 'date'
require 'byebug'

require 'task/combiner'
require 'task/modifier'
require 'task/sorter'
require 'core_ext/string'
require 'core_ext/float'

module Task
  DEFAULT_CSV_OPTIONS = { :col_sep => "\t", :headers => :first_row }
  WRITE_CSV_OPTIONS = DEFAULT_CSV_OPTIONS.merge({ :row_sep => "\r\n" })
end
