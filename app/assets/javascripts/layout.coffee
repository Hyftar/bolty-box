$ ->
  $(".header-dropdown").hover(
    (e) ->
      $(e.currentTarget).children(".header-menu-list").css('display','flex')
    ,
    (e) ->
      $(e.currentTarget).children(".header-menu-list").css('display','none')
    )
