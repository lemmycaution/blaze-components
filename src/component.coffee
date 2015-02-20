class Component
  
  constructor: (@name, @path = ".") ->    
    Blaze.loadTemplate @name, @path, @initialize

  initialize: ->
    throw "Not Implemented"
window.Component = Component    