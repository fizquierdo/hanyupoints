json.array!(@connections) do |connection|
  json.extract! connection, :id, :from, :to, :color, :directional
  json.url connection_url(connection, format: :json)
end
