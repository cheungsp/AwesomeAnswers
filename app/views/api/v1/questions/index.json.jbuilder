# this generates a JSON array as the main element
json.array! @questions do |question|
  json.id question.id

  json.title question.title
  json.created_at question.created_at.strftime('%Y-%B-%d')
end
