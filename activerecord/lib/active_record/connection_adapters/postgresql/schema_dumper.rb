# frozen_string_literal: true
module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module ColumnDumper
        def column_spec_for_primary_key(column)
          spec = {}
          if column.serial?
            return unless column.bigint?
            spec[:id] = ':bigserial'.freeze
          elsif column.type == :uuid
            spec[:id] = ':uuid'.freeze
            spec[:default] = column.default_function.inspect
          else
            spec[:id] = column.type.inspect
            spec.merge!(prepare_column_options(column).delete_if { |key, _| [:name, :type, :null].include?(key) })
          end
          spec
        end

        # Adds +:array+ option to the default set
        def prepare_column_options(column)
          spec = super
          spec[:array] = 'true'.freeze if column.array?
          spec
        end

        # Adds +:array+ as a valid migration key
        def migration_keys
          super + [:array]
        end

        private

        def schema_type(column)
          return super unless column.serial?

          if column.bigint?
            'bigserial'.freeze
          else
            'serial'.freeze
          end
        end

        def schema_default(column)
          if column.default_function
            column.default_function.inspect unless column.serial?
          else
            super
          end
        end
      end
    end
  end
end
