"use strict"
define ["./navBar", "./sideBar"], (navBar, sideBar, initialize) ->
  initialize = ->
    navBar.attachTo "#navBar"
    return
  initialize: initialize
