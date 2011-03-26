# DataLoader::Loader
#
# Loads CSV files into MySQL
#
# Config:
#
#   folder
#     base folder for calls to load()
#   table_prefix
#     prefix for derived table names
#     very important because an existing table will be overwritten!!!
#   inspect_rows
#     how many rows to scan the CSV file to determine the data types
#   connection
#     a connection name from database.yml to run it under (e.g. :production)
#   default_ext
#     extension to append if no file extension is specified
#   separator
#     a comma (,)

module DataLoader

  class Loader
    attr_accessor :folder, :table_prefix, :default_ext, :inspect_rows, :connection, :separator

    def initialize(folder = '', separator = ',', table_prefix = 'load', connection = :root)
      @folder, @separator = folder, separator
      @table_prefix, @connection = table_prefix, connection
      @default_ext = 'csv'
      @inspect_rows = 10
      yield(self) if block_given?
    end

    def load(filename, table = nil)
      filename = [filename, default_ext].join('.') if File.extname(filename).empty?
      full_file = File.expand_path(File.join(@folder, filename))
      table = Migrator.derive_table_name(filename) if table.nil?
      table = [@table_prefix, table].join('_') unless @table_prefix.blank?
      columns = Inspector.inspect_file(full_file, @separator, @inspect_rows)
      Migrator.migrate(full_file, columns, table, @separator, @connection)
      table
    end
  end
  
end
