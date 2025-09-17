# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include I18n::Alchemy

  primary_abstract_class
end
