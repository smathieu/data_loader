## Data Loader

Data Loader is a tool to load CSV files into a MySQL database. It was designed
to import raw data into tables that could then be manipulated with SQL.

Features:

* Uses MySQL LOAD DATA to efficiently load very large files
* Fastercsv is used to inspect the first few rows and choose datatypes
* Converts header row in to nice ruby-esque column names
* Builds a schema using ActiveRecord 2.x
* If table names are unspecified, they will be derived from the file name
* Will prefix table names to avoid collisions (it overwrites existing tables)
* Can run under a different connection, as defined in your database.yml

### Usage

    # Configure (everything has defaults, see loader.rb)
    loader = DataLoader::Loader.new do |config|
      config.table_prefix = :import
      config.folder = 'path/to/csv/files/'
      config.inspect_rows = 10
      config.connection = :development
      config.separator = ','
      config.default_ext = 'csv'
    end

    # Load data
    loader.load 'my_csv_file', :my_table


### TODO

* Write the column structure for each table to a text file. This file can be stored in Git, so that if the CSV files change, the diff will make it obvious what changed.

* A task to clean up all these temporary tables when we're done.

* Post-data load step in Migrator to NULLify 0000-00-00 dates, which is how MySQL reads empty strings in (integers would remain 0).

* Broader support for Rubies, Databases, and ORM/tools for building the schema.

* Better tests!