#require component
#require helpers/serialization

class Form extends Component
  
  IDLE    = "idle"  
  LOADING = "loading"
  SUCCESS = "success"  
  ERROR   = "error"
  
  constructor: (path = ".") ->
    super("form", path)
    
  initialize: ->
    Template.form.created = () ->
      @status = new Blaze.Var( IDLE )
  
    Template.form.helpers
      status: () ->
        Template.instance().status.get()

    Template.form.events
      "submit": (e,t) ->
        e.preventDefault()
        parentClass = t.parentTemplate()?.view?.template
        $submitButton = t.$("[type=submit]")
        $.ajax({
          type: t.data.method,
          url: t.data.action, 
          data: Template.helpers.serializeJSON( t.$('form').serializeArray() ),
          beforeSend: ( jqXHR, settings ) -> 
            t.status.set( LOADING )
            $submitButton.attr("disabled", true)
            parentClass?.before?( jqXHR, settings )
          error: ( jqXHR, textStatus, errorThrown ) -> 
            t.status.set( ERROR )
            parentClass?.error?( jqXHR, textStatus, errorThrown )
          success: ( data, textStatus, jqXHR ) -> 
            t.status.set( SUCCESS )
            parentClass?.success?( data, textStatus, jqXHR )
          complete: (jqXHR, textStatus) -> 
            $submitButton.removeAttr("disabled")  
            parentClass?.complete?( jqXHR, textStatus )
        })
      "reset": (e,t) ->
        t.$("[type=submit]").removeAttr("disabled")
        t.status.set IDLE
window.Form = Form