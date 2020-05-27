# frozen_string_literal: true

require 'dry-schema'

BookFilterFormSchema = Dry::Schema.Params do
  optional(:format).maybe(:string)
end
