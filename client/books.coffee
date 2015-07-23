pagina = (v, instance) ->
  total = instance.total.get()
  limit = instance.limit.get()
  current = instance.page.get()
  pages = instance.pages.get()
  newPage = v
  if pages >= newPage > 0
    page = newPage
  else if newPage > pages
    page = pages
  else
    page = 1
  instance.page.set page
  return

Template.books.created = ->
  # Init
  instanceBook = instance = @
  instance.limit = new ReactiveVar 10
  instance.page = new ReactiveVar 1
  instance.pages = new ReactiveVar 0
  instance.total = new ReactiveVar 0

  # Autorun
  @autorun ->
    limit = instance.limit.get()
    page = instance.page.get()

    subscription = instance.subscribe 'paginacao', page, limit
    subscriptionCount = instance.subscribe 'books-count'

    if subscription.ready() && subscriptionCount.ready()
      total = BooksCount.findOne().count
      pages = Meteor.totalPages total, limit
      instance.total.set total
      instance.pages.set pages

  # Cursor
  instance.books = ->
    limit = instance.limit.get()
    page = instance.page.get()
    Books.paginacao page, limit

Template.books.helpers
  lista: ->
    Template.instance().books()

  paginacao: ->
    total: Template.instance().total.get()
    limit: Template.instance().limit.get()
    page: Template.instance().page.get()
    pages: Template.instance().pages.get()

  hasBooks: ->
    Template.instance().total.get() > 0

  isReady: (v) ->
    Template.instance().subscriptionsReady() == v

Template.books.events
  'click .prior': (event, instance) ->
    event.preventDefault()
    $pageRange = instance.$ '#pageRange'
    $pageRange.trigger 'change', [-1]
    return

  'click .next': (event, instance) ->
    event.preventDefault()
    $pageRange = instance.$ '#pageRange'
    $pageRange.trigger 'change', [1]
    return

  'change #pageRange': (event, instance, data) ->
    event.preventDefault()
    target = event.currentTarget
    next = target.nextElementSibling
    v = parseInt target.value, 10
    if data
      v += data
    next.textContent = v
    pagina v, instance

  'input #pageRange': (event, instance) ->
    event.preventDefault()
    target = event.currentTarget
    next = target.nextElementSibling
    next.textContent = target.value
    return

BooksCount = new Meteor.Collection 'books-count', options: fields: name: 1
