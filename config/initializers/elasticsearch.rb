# frozen_string_literal: true

Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV["ELASTICSEARCH_URL"] || "http://localhost:9200")
