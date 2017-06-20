# this generates a JSON array as the main element
json.array! @questions do |question|
  json.id question.id
end
