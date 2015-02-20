Template.helpers = {} if typeof Template.helpers is "undefined" or not Template.helpers?

SerializationHelpers =
  serializeJSON: (dataArray) ->
    _.reduce dataArray, ((o, a) ->
      o[a.name] = a.value
      o
    ), {}
    
_.extend Template.helpers, SerializationHelpers