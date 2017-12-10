isOpen = true
$ ->
  $(".header-main-button,.header-menu-list").hover(
    (e) ->
      $(".header-menu-list").css('display','flex')
    ,
    (e) ->
      $(".header-menu-list").css('display','none')
    )
