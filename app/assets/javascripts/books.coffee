# Browse books page specific JS

$(document).on 'ready', () ->

  booksData = (() ->
    $el = $('.well')
    bookIDs = []

    _render = (id, info) ->
      $(".#{id}__image").text(info.imageLinks.thumbnail)
      $(".#{id}__link").text(info.previewLink)
      $(".#{id}__description").text(info.description)
      $(".#{id}__authors").text(if info.authors then info.authors.join(','))
      $(".#{id}__publishedDate").text(info.publishedDate)
      $(".#{id}__publisher").text(info.publisher)
      $(".#{id}__avgRating").text("#{info.averageRating}/5")
      $(".#{id}__totalRatings").text(info.ratingsCount)
      return

    _getGBdata = (item, index) ->
      bookID = item.id
      gbURL = item.url
      $.get(gbURL, { key: "AIzaSyBnj2IuHkR0a5wFBDb7qVxjMa8Ly8zL_Oc" }, (result) =>
        if result then _render(bookID, result.volumeInfo)
    );

    init = () ->

      $el.each () ->
        bookIDs.push id: $(this).attr('id'), url: $(this).attr('data-googlelink')
      bookIDs.forEach(_getGBdata)

    return {
      init: init
    }
    )()

  booksList = (() ->
    $el = $('.add-book-to-list-dropdown')
    $elBtn = $('.add-book-to-list-btn')

    _render = (target, success) ->
      if success
        $(target).parent('li').addClass('bg-success')
        $el.children('li').addClass('disabled')
        $elBtn.append($("<h3></h3>").text("Success."))
      else
        $elBtn.append($("<h3></h3>").text("Failed."))

    _getBookID = (selector) ->
      $(selector).closest('.dropdown-menu').attr('data-bookid')

    init = () ->
      $el.on 'click', 'li', (event) ->
        event.preventDefault()
        classNames = $(event.target).parent('li').attr("class")
        if !(/disabled/.test(classNames))
          targetUrl = event.target.href
          bookid = _getBookID(event.target)
          $.post( targetUrl, {bookid: bookid}, (result) =>
              _render(event.target, result.success, )
          );
        false


    return {
      init: init
    }
    )()

  booksData.init();
  booksList.init();
