@Books = new Mongo.Collection 'books'

@Books.paginacao = (page = 1, limit) ->
  total = Books.find({}).count()
  pages = Meteor.totalPages total, limit

  if page > pages
    page = pages

  if total < limit
    limit = total
    offset = 0
  else
    offset = if page > 0 then (page - 1) * limit else 0

  Books.find {},
    skip: offset
    limit: limit
    fields:
      name: 1
