// Generated by CoffeeScript 1.6.3
(function() {
  var Component;

  Component = (function() {
    function Component(name, path) {
      this.name = name;
      this.path = path != null ? path : ".";
      Blaze.loadTemplate(this.name, this.path, this.initialize);
    }

    Component.prototype.initialize = function() {
      throw "Not Implemented";
    };

    return Component;

  })();

  window.Component = Component;

}).call(this);
