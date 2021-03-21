# frozen_string_literal: true

module RequestHelpers
  def body
    parse_json(response.body)
  end

  def data_count
    body['data'].count
  end

  def attributes
    body.dig('data', 'attributes').symbolize_keys
  end

  def errors
    body['errors'].map!(&:symbolize_keys)
  end

  def relationships_data(relation)
    body.dig('data', 'relationships', relation, 'data')
  end
end
