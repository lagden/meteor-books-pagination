# Fixtures
if Books.find().count() is 0
  Meteor.startup ->
    total = 10 * 2000
    _(total).times (n) ->
      check n, Match.Integer
      Books.insert
        name: "Book #{n}"
        num: n
        date: new Date
      return
    return

# Publish - Paginação
Meteor.publish 'paginacao', (page = 1, limit) ->
  # Meteor._sleepForMs 2000
  Books.paginacao page, limit

# Publish - Total de livros
Meteor.publish 'books-count', (params = {}) ->
  Meteor.publishCounter
    handle: @
    name: 'books-count'
    collection: Books
    filter: params
