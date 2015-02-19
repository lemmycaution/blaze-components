class Form
  
  name: "form"
  
  # initializer
  # params
  # - options, Object
  #   - options.template, String, template name, default "form" 
  #   - options.before, Function, before callback  
  #   - options.success, Function, success callback
  #   - options.error, Function, error callback
  constructor: (@options = {})->
    
    if Template[@name]
      @initialize()
    else  
      $.holdReady(true)
      $.get "#{@name}.tmp", (templateSource) =>
        renderFuncCode = SpacebarsCompiler.compile(templateSource, isTemplate: true)
        Template.__define__ @name, eval(renderFuncCode)
        $(document).bind "spacebarsReady", () => @initialize()
        $.holdReady(false)

  initialize: =>
    @template = Template[@options.template]
    @template.helpers @helpers
    @template.events @events

  # blaze helpers
  helpers:
    status: ->
      status.get()

  # blaze events
  events:
    "submit": (e, t) =>
      e.preventDefault()

      $.ajax({
        type: t.$el.attr("method"),
        url: t.$el.attr("action"), 
        data: t.$el.toJSON(),
        beforeSend: handler(LOADING, @options.before)
        error: handler(ERROR, @options.error)
        success: handler(SUCCESS, @options.success)
      })

    "reset": (e, tmp) ->
      e.preventDefault()

  # private
  
  IDLE = "idle"  
  LOADING = "loading"
  SUCCESS = "success"  
  ERROR = "error"
  status = new Blaze.Var(IDLE)
  handler = (status, callback) ->
    () ->
      status.set status
      callback(args) if typeof callback is "function"
