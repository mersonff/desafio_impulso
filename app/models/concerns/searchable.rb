# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    # Only include Elasticsearch if ELASTICSEARCH_URL is present
    if ENV["ELASTICSEARCH_URL"].present?
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks

      import(force: true) if Rails.env.development?
    end
  end
end
