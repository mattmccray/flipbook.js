/* FlipBook v1.0.0-54 */
(function(/*! Stitched by Assembot !*/) {
  /* 
    The commonjs code below was based on @sstephenson's stitch.
    https://github.com/sstephenson/stitch
  */
  if (!this.flipbook) {
    var modules = {}, cache = {}, moduleList= function(startingWith) {
      var names= [], startingWith= startingWith || '';
      for( var name in modules ) {
        if(name.indexOf(startingWith) === 0) names.push(name);
      }
      return names;
    }, require = function(name, root) {
      var path = expand(root, name), module = cache[path], fn;
      if (module) {
        return module.exports;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {id: path, exports: {}};
        try {
          cache[path] = module;
          var localRequire= function(name) {
            return require(name, dirname(path));
          }
          localRequire.modules= moduleList;
          fn(module.exports, localRequire, module);
          return module.exports;
        } catch (err) {
          delete cache[path];
          throw err;
        }
      } else {
        throw 'module \'' + name + '\' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.flipbook = function(name) {
      return require(name, '');
    }
    this.flipbook.define = function(bundle) {
      for (var key in bundle)
        modules[key] = bundle[key];
    };
    this.flipbook.modules= moduleList;
  }
  return this.flipbook.define;
}).call(this)({
"cog/events": function(exports, require, module) {
var Events,
  __slice = [].slice;

Events = (function() {

  function Events() {}

  Events.mixin = function() {
    var fn, name, target, targets, _i, _len, _ref;
    targets = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    for (_i = 0, _len = targets.length; _i < _len; _i++) {
      target = targets[_i];
      _ref = this.prototype;
      for (name in _ref) {
        fn = _ref[name];
        target[name] = fn;
      }
    }
    return this;
  };

  Events.prototype.emit = function() {
    var args, event, listener, _i, _len, _ref, _ref1;
    event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    if (!((_ref = this._events) != null ? _ref[event] : void 0)) {
      return false;
    }
    _ref1 = this._events[event];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      listener = _ref1[_i];
      listener.apply(null, args);
    }
    return true;
  };

  Events.prototype.trigger = Events.prototype.emit;

  Events.prototype.fire = Events.prototype.emit;

  Events.prototype.addListener = function(event, listener) {
    var _base, _ref, _ref1;
    this.emit('newListener', event, listener);
    ((_ref = (_base = ((_ref1 = this._events) != null ? _ref1 : this._events = {}))[event]) != null ? _ref : _base[event] = []).push(listener);
    return this;
  };

  Events.prototype.on = Events.prototype.addListener;

  Events.prototype.once = function(event, listener) {
    var fn,
      _this = this;
    fn = function() {
      _this.removeListener(event, fn);
      return listener.apply(null, arguments);
    };
    this.on(event, fn);
    return this;
  };

  Events.prototype.removeListener = function(event, listener) {
    var l, _ref;
    if (!((_ref = this._events) != null ? _ref[event] : void 0)) {
      return this;
    }
    this._events[event] = (function() {
      var _i, _len, _ref1, _results;
      _ref1 = this._events[event];
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        l = _ref1[_i];
        if (l !== listener) {
          _results.push(l);
        }
      }
      return _results;
    }).call(this);
    return this;
  };

  Events.prototype.off = Events.prototype.removeListener;

  Events.prototype.removeAllListeners = function(event) {
    if (this._events != null) {
      delete this._events[event];
    }
    return this;
  };

  Events.prototype.listeners = function(event) {
    var _ref;
    if ((_ref = this._events) != null ? _ref[event] : void 0) {
      return this.events[event];
    } else {
      return [];
    }
  };

  Events.prototype.listenTo = function(emitter, event, callback) {
    var id, _base, _ref, _ref1, _ref2;
    if (!((emitter != null) && (event != null) && (callback != null))) {
      return this;
    }
    id = ((_ref = emitter._emitterId) != null ? _ref : emitter._emitterId = uid());
    if ((_ref1 = (_base = ((_ref2 = this._emitterBindings) != null ? _ref2 : this._emitterBindings = {}))[id]) == null) {
      _base[id] = [];
    }
    this._emitterBindings[id].push({
      target: emitter,
      message: event,
      action: callback
    });
    emitter.on(event, callback);
    return this;
  };

  Events.prototype.stopListening = function(emitter, event, callback) {
    var action, binding, bindings, id, message, removed, target, _i, _j, _len, _len1, _ref;
    if (this._emitterBindings == null) {
      return this;
    }
    if (emitter === null) {
      _ref = this._emitterBindings;
      for (id in _ref) {
        binding = _ref[id];
        target = binding.target, message = binding.message, action = binding.action;
        target.off(message, action);
      }
      this._emitterBindings = {};
    } else {
      bindings = this._emitterBindings[emitter._emitterId];
      if (binding == null) {
        return this;
      }
      removed = [];
      if (event === null) {
        while (binding = bindings.pop()) {
          target = binding.target, message = binding.message, action = binding.action;
          target.off(message, action);
        }
      } else if (callback === null) {
        for (_i = 0, _len = bindings.length; _i < _len; _i++) {
          binding = bindings[_i];
          if (!(binding.message === event)) {
            continue;
          }
          target = binding.target, message = binding.message, action = binding.action;
          target.off(message, action);
          removed.push(binding);
        }
      } else {
        for (_j = 0, _len1 = bindings.length; _j < _len1; _j++) {
          binding = bindings[_j];
          if (!(binding.message === event && binding.action === callback)) {
            continue;
          }
          target = binding.target, message = binding.message, action = binding.action;
          target.off(message, action);
          removed.push(binding);
        }
      }
      if (removed.length > 0) {
        this._emitterBindings[emitter._emitterId] = arrayWithout(bindings, removed);
      }
    }
    return this;
  };

  return Events;

})();

module.exports = Events;

},
"cog/view": function(exports, require, module) {
var View, events, uid;

events = require('./events');

uid = require('util/uid');

View = (function() {

  events.mixin(View, View.prototype);

  View.prototype.tagName = 'div';

  View.prototype.className = 'view';

  View.prototype.template = null;

  View.prototype.events = {};

  View.prototype.outlets = {};

  function View(options) {
    var _ref;
    this.options = options != null ? options : {};
    this.id = uid('view-');
    this.model = (_ref = this.options.model) != null ? _ref : {};
    this._createElem();
    this.assignEvents();
    if (typeof this.initialize === "function") {
      this.initialize();
    }
  }

  View.prototype._createElem = function() {
    if (this.options.elem != null) {
      return this.elem = $(this.options.elem);
    } else {
      return this.elem = $("<" + this.tagName + " class='" + this.className + "'></" + this.tagName + ">");
    }
  };

  View.prototype.assignEvents = function() {
    var callback, eparts, evt, sel, _ref;
    _ref = this.events;
    for (evt in _ref) {
      callback = _ref[evt];
      eparts = evt.split(' ');
      if (eparts.length > 1) {
        evt = eparts.shift();
        sel = eparts.join(' ');
        this.elem.on(evt, sel, this[callback]);
      } else {
        this.elem.on(evt, this[callback]);
      }
    }
    return this;
  };

  View.prototype.unassignEvents = function() {
    var callback, eparts, evt, sel, _ref;
    _ref = this.events;
    for (evt in _ref) {
      callback = _ref[evt];
      eparts = evt.split(' ');
      if (eparts.length > 1) {
        evt = eparts.shift();
        sel = eparts.join(' ');
        this.elem.off(evt, sel, this[callback]);
      } else {
        this.elem.off(evt, this[callback]);
      }
    }
    return this;
  };

  View.prototype.assignOutlets = function() {
    var outlet, sel, _ref;
    this.ui = {};
    _ref = this.outlets;
    for (outlet in _ref) {
      sel = _ref[outlet];
      this.ui[outlet] = this.elem.find(sel);
      this[outlet] = this.elem.find(sel);
    }
    return this;
  };

  View.prototype.unassignOutlets = function() {
    var elem, outlet, _ref;
    _ref = this.ui;
    for (outlet in _ref) {
      elem = _ref[outlet];
      delete this.ui[outlet];
      delete this[outlet];
    }
    return this;
  };

  View.prototype.dispose = function() {
    this.unassignEvents();
    this.unassignOutlets();
    return this;
  };

  View.prototype.close = function() {
    if (typeof this.beforeClose === "function") {
      this.beforeClose();
    }
    this.dispose();
    this.elem.remove();
    if (typeof this.onClose === "function") {
      this.onClose();
    }
    return this;
  };

  View.prototype.getData = function() {
    var _base, _ref;
    return (_ref = typeof (_base = this.model).toJSON === "function" ? _base.toJSON() : void 0) != null ? _ref : this.model;
  };

  View.prototype.appendTo = function(elem) {
    this.render();
    elem.append(this.elem);
    return typeof this.onDomActive === "function" ? this.onDomActive() : void 0;
  };

  View.prototype.addView = function(outlet, view) {};

  View.prototype.replaceView = View.prototype.addView;

  View.prototype.appendView = function(outlet, view) {};

  View.prototype.render = function() {
    var data, html;
    if (typeof this.beforeRender === "function") {
      this.beforeRender();
    }
    this.fire('before:render', this);
    data = this.getData();
    html = this.template(data);
    this.elem.html(html);
    this.assignOutlets();
    this.fire('render', this);
    if (typeof this.onRender === "function") {
      this.onRender();
    }
    return this;
  };

  return View;

})();

module.exports = View;

},
"env": function(exports, require, module) {

module.exports = {
  version: require('version'),
  debug: true,
  test: false,
  mobile: navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/) != null
};

},
"main": function(exports, require, module) {
var Viewer, ensure, env, hammertime, init, log, scanner, validate;

env = require('env');

log = require('util/log').prefix('main:');

ensure = require('util/ensure');

scanner = require('scanner');

validate = require('validator');

Viewer = require('viewer/controller');

require('theme').activate();

hammertime = function() {
  if (env.mobile) {
    log.info("It's hammer time.");
    return ensure.libs.hammer();
  } else {
    log.info("Please hammer, dont' hurt 'em.");
    return null;
  }
};

ensure('jquery', hammertime, function(err) {
  if (err != null) {
    throw err;
  }
  return $(init);
});

init = function() {
  var flipbooks, item, model, view, _i, _len, _ref, _ref1;
  if (env.debug) {
    log.level(2);
  }
  log.info("FlipBook v" + env.version);
  log.info("ENV", env);
  log.info("Ready.");
  flipbooks = scanner.run();
  for (_i = 0, _len = flipbooks.length; _i < _len; _i++) {
    _ref = flipbooks[_i], item = _ref.item, model = _ref.model;
    if (validate(model)) {
      view = new Viewer({
        model: model
      });
      view.appendTo($(item).empty());
    } else {
      log.info("! Invalid model:", validate.errors(), model);
    }
  }
  return (_ref1 = $('.flipbook').get(0)) != null ? _ref1.focus() : void 0;
};

if (env.debug && env.mobile) {
  ensure('firebug', function(err) {
    return window.onerror = function(err) {
      return log.info("ERROR!", err);
    };
  });
}

},
"scanner": function(exports, require, module) {
var api, log, scanners;

log = require('util/log').prefix('scanner:');

scanners = [];

module.exports = api = {
  define: function(handler) {
    scanners.push(handler);
    return this;
  },
  run: function() {
    var result, results, scanner, _i, _j, _len, _len1, _ref;
    results = [];
    for (_i = 0, _len = scanners.length; _i < _len; _i++) {
      scanner = scanners[_i];
      _ref = scanner();
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        result = _ref[_j];
        results.push(result);
      }
    }
    return results;
  }
};

api.define(function() {
  var results;
  results = [];
  $('[data-flipbook]').each(function(i, item) {
    var data, key, model, parts, seg, value, _i, _len, _ref;
    data = $(item).data('flipbook');
    model = {};
    _ref = data.split(',');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      seg = _ref[_i];
      parts = seg.split(':');
      key = parts.shift();
      value = parts.join(':');
      model[$.trim(key)] = $.trim(value);
    }
    return results.push({
      item: item,
      model: model
    });
  });
  return results;
});

api.define(function() {
  var results;
  results = [];
  $('[data-flipbook-pages]').each(function(i, item) {
    var att, model, name, _i, _len, _ref;
    i = $(item);
    model = {};
    _ref = item.attributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      att = _ref[_i];
      name = String(att.nodeName);
      if (name.indexOf('data-flipbook-') === 0) {
        name = name.replace('data-flipbook-', '');
        model[name] = att.nodeValue;
      }
    }
    return results.push({
      item: item,
      model: model
    });
  });
  return results;
});

},
"theme": function(exports, require, module) {
var node = null, css = ".flipbook div,\n.flipbook span,\n.flipbook object,\n.flipbook iframe,\n.flipbook h1,\n.flipbook h2,\n.flipbook h3,\n.flipbook h4,\n.flipbook h5,\n.flipbook h6,\n.flipbook p,\n.flipbook pre,\n.flipbook a,\n.flipbook abbr,\n.flipbook acronym,\n.flipbook address,\n.flipbook code,\n.flipbook del,\n.flipbook dfn,\n.flipbook em,\n.flipbook img,\n.flipbook dl,\n.flipbook dt,\n.flipbook dd,\n.flipbook ol,\n.flipbook ul,\n.flipbook li,\n.flipbook fieldset,\n.flipbook form,\n.flipbook label,\n.flipbook legend,\n.flipbook caption,\n.flipbook tbody,\n.flipbook tfoot,\n.flipbook thead,\n.flipbook tr {\n  margin: 0;\n  padding: 0;\n  border: 0;\n  outline: 0;\n  font-weight: inherit;\n  font-style: inherit;\n  font-family: inherit;\n  font-size: 100%;\n  vertical-align: baseline;\n}\n.flipbook table {\n  border-collapse: separate;\n  border-spacing: 0;\n  vertical-align: middle;\n}\n.flipbook caption,\n.flipbook th,\n.flipbook td {\n  text-align: left;\n  font-weight: normal;\n  vertical-align: middle;\n}\n.flipbook a img {\n  border: none;\n}\n.flipbook {\n  font-family: \"Helvetica Neue\", Helvetica, Sans-Serif;\n  -webkit-user-select: none;\n  -moz-user-select: none;\n  -ms-user-select: none;\n  user-select: none;\n  width: 100%;\n  max-width: 100%;\n  cursor: default;\n  color: #555;\n}\n.flipbook:focus {\n  outline: 0;\n  border: 0;\n  color: #000;\n/*  \n    &.inactive\n      header, footer\n        opacity: 0.5\n    */\n}\n.flipbook header {\n  background: #c0c0c0;\n  -webkit-border-top-left-radius: 4px;\n  border-top-left-radius: 4px;\n  -webkit-border-top-right-radius: 4px;\n  border-top-right-radius: 4px;\n  margin: 0 4px;\n  padding: 5px;\n  z-index: 5;\n  white-space: nowrap;\n  overflow: hidden;\n  -o-text-overflow: ellipsis;\n  text-overflow: ellipsis;\n}\n.flipbook .screen-stack {\n  position: relative;\n  overflow: hidden;\n  width: 100%;\n  max-width: 100%;\n  -webkit-box-shadow: 0px 2px 9px #777;\n  box-shadow: 0px 2px 9px #777;\n  z-index: 10;\n}\n.flipbook .screen-stack .errors {\n  padding: 25px;\n  text-align: center;\n}\n.flipbook .screen-stack .screen {\n  position: absolute;\n  top: 0;\n  left: 0;\n  max-width: 100%;\n}\n.flipbook .screen-stack .screen img {\n  max-width: 100%;\n}\n.flipbook .screen-stack .screen.the-end {\n  display: none;\n  height: 100%;\n  background: rgba(0,0,0,0.7);\n  color: #fff;\n  width: 100%;\n  position: relative;\n}\n.flipbook .screen-stack .screen.the-end .button {\n  position: absolute;\n  top: 10px;\n  right: 10px;\n  bottom: 10px;\n  width: 45%;\n  border: 3px dashed #fff;\n  -webkit-border-radius: 15px;\n  border-radius: 15px;\n}\n.flipbook footer {\n  background: #ccc;\n  margin: 0 4px;\n  text-align: center;\n  z-index: 5;\n/*height: 44px */\n}\n.flipbook footer.copyright {\n  background: #bbb;\n  border-bottom: 1px solid #ddd;\n  font-size: 75%;\n  padding: 2px;\n  white-space: nowrap;\n  overflow: hidden;\n  -o-text-overflow: ellipsis;\n  text-overflow: ellipsis;\n}\n.flipbook footer.pager {\n  position: relative;\n  -webkit-border-bottom-left-radius: 4px;\n  border-bottom-left-radius: 4px;\n  -webkit-border-bottom-right-radius: 4px;\n  border-bottom-right-radius: 4px;\n  padding: 3px;\n  height: 28px;\n  line-height: 28px;\n}\n.flipbook footer.pager .progress {\n  display: block;\n  height: 28px;\n  margin: 0 33px;\n  position: relative;\n}\n.flipbook footer.pager .progress.errors .bar.background {\n  visibility: hidden;\n}\n.flipbook footer.pager .progress .bar {\n  -webkit-border-top-left-radius: 6px;\n  border-top-left-radius: 6px;\n  -webkit-border-bottom-left-radius: 6px;\n  border-bottom-left-radius: 6px;\n  position: absolute;\n  height: 14px;\n  top: 7px;\n  overflow: hidden;\n}\n.flipbook footer.pager .progress .bar.done {\n  -webkit-border-radius: 6px;\n  border-radius: 6px;\n  width: 100%;\n}\n.flipbook footer.pager .progress .bar.background {\n  -webkit-border-radius: 6px;\n  border-radius: 6px;\n  background: #aaa;\n  width: 100%;\n}\n.flipbook footer.pager .progress .bar.loading {\n  background-color: #bbb;\n  width: 1%;\n  height: 10px;\n  top: 9px;\n}\n.flipbook footer.pager .progress .bar.location {\n  background-color: #ddd;\n  background-color: #ccc;\n  width: 0%;\n  height: 12px;\n  top: 8px;\n}\n.flipbook footer.pager .button {\n  width: 30px;\n  height: 28px;\n  overflow: hidden;\n  cursor: pointer;\n  font-size: 135%;\n  -webkit-border-radius: 4px;\n  border-radius: 4px;\n}\n.flipbook footer.pager .button.nextPage {\n  position: absolute;\n  top: 3px;\n  right: 3px;\n}\n.flipbook footer.pager .button.prevPage {\n  position: absolute;\n  top: 3px;\n  left: 3px;\n}\n.flipbook footer.pager .button.disabled {\n  opacity: 0.3;\n  filter: alpha(opacity=30);\n  -ms-filter: \"progid:DXImageTransform.Microsoft.Alpha(Opacity=30)\";\n  cursor: default;\n}\n.flipbook.isDesktop .button:hover {\n  background: #fff;\n}\n.flipbook.isDesktop .button.disabled:hover {\n  background: none;\n}\n";
module.exports= {
  content: css,
  isActive: function(){ return node != null; },
  activate: function(to){
    if(node != null) return; // Already added to DOM!
    to= to || document.getElementsByTagName('HEAD')[0] || document.body || document; // In the HEAD or BODY tags
    node= document.createElement('style');
    node.innerHTML= css;
    to.appendChild(node);
    return this;
  },
  deactivate: function() {
    if(node != null) {
      node.parentNode.removeChild(node);
      node = null;
    }
    return this;
  }
};
},
"util/ensure": function(exports, require, module) {
var libs, load_script, loader, protocol,
  __slice = [].slice;

libs = {
  angular: function() {
    return typeof angular !== "undefined" && angular !== null ? angular : '//ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js';
  },
  backbone: function() {
    return typeof Backbone !== "undefined" && Backbone !== null ? Backbone : '//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.10/backbone-min.js';
  },
  fastclick: function() {
    return typeof FastClick !== "undefined" && FastClick !== null ? FastClick : '//cdnjs.cloudflare.com/ajax/libs/fastclick/0.6.0/fastclick.min.js';
  },
  firebug: function() {
    return typeof FBL !== "undefined" && FBL !== null ? FBL : 'https://getfirebug.com/releases/lite/1.4/firebug-lite.js';
  },
  hammer: function() {
    return typeof Hammer !== "undefined" && Hammer !== null ? Hammer : 'https://raw.github.com/EightMedia/hammer.js/v1.0.3/dist/hammer.min.js';
  },
  jquery: function() {
    return typeof jQuery !== "undefined" && jQuery !== null ? jQuery : '//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js';
  },
  jqueryui: function() {
    var _ref;
    return (_ref = typeof jQuery !== "undefined" && jQuery !== null ? jQuery.Widget : void 0) != null ? _ref : '//ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js';
  },
  underscore: function() {
    return typeof _ !== "undefined" && _ !== null ? _ : '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js';
  },
  webfont: function() {
    return typeof WebFont !== "undefined" && WebFont !== null ? WebFont : '//ajax.googleapis.com/ajax/libs/webfont/1.1.2/webfont.js';
  },
  zepto: function() {
    return typeof Zepto !== "undefined" && Zepto !== null ? Zepto : '//cdnjs.cloudflare.com/ajax/libs/zepto/1.0/zepto.min.js';
  }
};

protocol = location.protocol === 'file:' ? "http:" : '';

load_script = function(name, callback) {
  var script, url, _ref, _ref1;
  url = (_ref = (_ref1 = typeof name === "function" ? name() : void 0) != null ? _ref1 : typeof libs[name] === "function" ? libs[name]() : void 0) != null ? _ref : null;
  if (typeof url !== 'string') {
    return callback(null);
  }
  script = document.createElement('script');
  script.type = "text/javascript";
  if (loader.defer) {
    script.defer = true;
  }
  if (loader.async) {
    script.async = true;
  }
  script.onload = function(e) {
    return callback(null);
  };
  script.onerror = function(e) {
    return callback(new Error("Could not load external resource: " + name + " from " + url));
  };
  script.src = url[0] === '/' ? "" + protocol + url : url;
  script.onreadystatechange = function() {
    if (script.readyState === 'loaded' || script.readyState === 'complete') {
      script.onreadystatechange = null;
      return callback(null);
    }
  };
  document.getElementsByTagName('HTML')[0].appendChild(script);
  return script;
};

loader = function() {
  var callback, libs, load_handler, nextLib;
  libs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  callback = typeof libs.slice(-1)[0] === 'function' ? libs.pop() : function(err) {
    if (err != null) {
      throw err;
    }
    return typeof console !== "undefined" && console !== null ? typeof console.log === "function" ? console.log("Library loading complete.") : void 0 : void 0;
  };
  nextLib = libs.shift();
  load_handler = function(err) {
    if (err != null) {
      return callback(err);
    }
    if (libs.length === 0) {
      return callback(null);
    } else {
      nextLib = libs.shift();
      return load_script(nextLib, load_handler);
    }
  };
  load_script(nextLib, load_handler);
  return null;
};

loader.async = true;

loader.defer = false;

loader.libs = libs;

if (typeof module !== "undefined" && module !== null) {
  module.exports = loader;
} else {
  this.ensure = loader;
}

},
"util/log": function(exports, require, module) {
var clog, debug, error, info, level, log_level, prefix, say, toArray;

log_level = 1;

clog = (function() {
  if (typeof console !== "undefined" && console !== null) {
    return function(args) {
      return console.log.apply(console, args);
    };
  } else {
    return function() {};
  }
})();

level = function(lvl) {
  if (lvl != null) {
    log_level = (function() {
      switch (lvl) {
        case -1:
        case 'none':
        case 'n':
          return -1;
        case 0:
        case 'quiet':
        case '1':
          return 0;
        case 1:
        case 'info':
        case 'i':
          return 1;
        case 2:
        case 'debug':
        case 'd':
          return 2;
        default:
          return log_level;
      }
    })();
  }
  return log_level;
};

say = function() {
  if (log_level < 0) {
    return;
  }
  return clog(arguments);
};

info = function() {
  if (log_level < 1) {
    return;
  }
  return clog(arguments);
};

debug = function() {
  if (log_level < 2) {
    return;
  }
  return clog(arguments);
};

error = function() {
  var lines, newError;
  newError = new Error;
  if (newError.stack != null) {
    lines = newError.stack.split("\n");
    if (typeof console !== "undefined" && console !== null) {
      if (typeof console.error === "function") {
        console.error("Error", lines[2].trim());
      }
    }
  }
  return clog(arguments);
};

toArray = Array.prototype.slice;

prefix = function(msg) {
  return {
    level: level,
    say: function() {
      var a;
      if (log_level < 0) {
        return;
      }
      (a = toArray.call(arguments)).unshift(msg);
      return say.apply(say, a);
    },
    info: function() {
      var a;
      if (log_level < 1) {
        return;
      }
      (a = toArray.call(arguments)).unshift(msg);
      return info.apply(info, a);
    },
    debug: function() {
      var a;
      if (log_level < 2) {
        return;
      }
      (a = toArray.call(arguments)).unshift(msg);
      return debug.apply(debug, a);
    },
    error: function() {
      var a;
      (a = toArray.call(arguments)).unshift(msg);
      return error.apply(error, a);
    }
  };
};

module.exports = {
  level: level,
  info: info,
  debug: debug,
  error: error,
  say: say,
  prefix: prefix
};


// IE Hack, source:
// http://stackoverflow.com/questions/5538972/console-log-apply-not-working-in-ie9
if (Function.prototype.bind && console && typeof console.log == "object") {
  [
    "log","info","warn","error","assert","dir","clear","profile","profileEnd"
  ].forEach(function (method) {
      console[method] = this.bind(console[method], console);
  }, Function.prototype.call);
}
;

},
"util/number/pad": function(exports, require, module) {
var pad;

module.exports = pad = function(num, len) {
  var str;
  str = "" + num;
  while (str.length < len) {
    str = "0" + str;
  }
  return str;
};

},
"util/uid": function(exports, require, module) {
var counter;

counter = 1;

module.exports = function(prefix) {
  if (prefix == null) {
    prefix = '';
  }
  return prefix + (++counter);
};

},
"validator": function(exports, require, module) {
var errors, fixupTypes, log, validator;

log = require('util/log').prefix('validator:');

errors = [];

fixupTypes = function(o) {
  if (typeof o.pages === 'string') {
    o.pages = parseInt(o.pages, 10);
  }
  return o.start = o.start != null ? typeof o.start === 'string' ? parseInt(o.start, 10) : void 0 : 1;
};

module.exports = validator = function(options) {
  errors = [];
  if (options.path == null) {
    errors.push("path is missing");
  }
  if (options.pages == null) {
    errors.push("pages is missing");
  }
  if (errors.length === 0) {
    fixupTypes(options);
    return true;
  } else {
    return false;
  }
};

validator.errors = function() {
  return errors.join(', ');
};

},
"version": function(exports, require, module) {

module.exports = "1.0.0-54";

},
"viewer/controller": function(exports, require, module) {
var CogView, Viewer, build_url, env, events, keyListener, log, nextKeys, pad, preloader, prevKeys, uid,
  _this = this,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

env = require('env');

uid = require('util/uid');

pad = require('util/number/pad');

log = require('util/log').prefix('controller:');

events = require('cog/events');

preloader = require('./preloader');

CogView = require('cog/view');

keyListener = {
  ready: false,
  init: function() {
    if (this.ready || env.mobile) {
      return;
    }
    $(document).on('keydown', this.onKeyInput);
    return this.ready = true;
  },
  onKeyInput: function(e) {
    if (Viewer.active != null) {
      return Viewer.active.onKeyInput(e);
    }
  }
};

build_url = function(pattern, idx) {
  pattern = pattern.replace('####', pad(idx, 4));
  pattern = pattern.replace('###', pad(idx, 3));
  pattern = pattern.replace('##', pad(idx, 2));
  return pattern = pattern.replace('#', idx);
};

nextKeys = [39, 32];

prevKeys = [37];

Viewer = (function(_super) {

  __extends(Viewer, _super);

  function Viewer() {
    var _this = this;
    this.onLoadError = function(e) {
      return Viewer.prototype.onLoadError.apply(_this, arguments);
    };
    this.onLoad = function() {
      return Viewer.prototype.onLoad.apply(_this, arguments);
    };
    this.prevPage = function(e) {
      return Viewer.prototype.prevPage.apply(_this, arguments);
    };
    this.nextPage = function(e) {
      return Viewer.prototype.nextPage.apply(_this, arguments);
    };
    this.didBlur = function(e) {
      return Viewer.prototype.didBlur.apply(_this, arguments);
    };
    this.didFocus = function(e) {
      return Viewer.prototype.didFocus.apply(_this, arguments);
    };
    this.didTap = function(e) {
      return Viewer.prototype.didTap.apply(_this, arguments);
    };
    this.onKeyInput = function(e) {
      return Viewer.prototype.onKeyInput.apply(_this, arguments);
    };
    return Viewer.__super__.constructor.apply(this, arguments);
  }

  Viewer.active = null;

  Viewer.prototype.className = 'flipbook';

  Viewer.prototype.template = require('./template');

  Viewer.prototype.outlets = {
    stack: '.screen-stack',
    nextBtn: '.nextPage',
    prevBtn: '.prevPage',
    progressBar: '.progress',
    locationBar: '.progress .location',
    loadingBar: '.progress .loading'
  };

  Viewer.prototype.initialize = function() {
    this.screenCount = this.model.pages;
    this.current = 0;
    this.ready = false;
    this.active = false;
    this.atEnd = false;
    this.elem.attr('tabindex', -1);
    this.elem.addClass('inactive');
    if (env.mobile) {
      this.elem.addClass('isMobile');
    } else {
      this.elem.addClass('isDesktop');
    }
    return keyListener.init();
  };

  Viewer.prototype.onKeyInput = function(e) {
    var _ref, _ref1;
    if (!(this.ready && this.active)) {
      return;
    }
    if (_ref = e.which, __indexOf.call(nextKeys, _ref) >= 0) {
      if (!this.atEnd) {
        this.nextPage(e);
      }
      return false;
    } else if (_ref1 = e.which, __indexOf.call(prevKeys, _ref1) >= 0) {
      this.prevPage(e);
      return false;
    }
  };

  Viewer.prototype.didTap = function(e) {
    var x, _ref, _ref1, _ref2;
    if (this.atEnd) {
      return;
    }
    e.preventDefault();
    x = (_ref = (_ref1 = e.offsetX) != null ? _ref1 : e.clientX) != null ? _ref : (_ref2 = e.gesture) != null ? _ref2.center.pageX : void 0;
    if (x < (this.imageW / 2)) {
      this.prevPage();
    } else {
      this.nextPage();
    }
    return false;
  };

  Viewer.prototype.didFocus = function(e) {
    this.active = true;
    this.elem.removeClass('inactive').addClass('active');
    return Viewer.active = this;
  };

  Viewer.prototype.didBlur = function(e) {
    this.active = false;
    this.elem.removeClass('active').addClass('inactive');
    if (Viewer.active === this) {
      return Viewer.active = null;
    }
  };

  Viewer.prototype.nextPage = function(e) {
    if (e != null) {
      if (typeof e.preventDefault === "function") {
        e.preventDefault();
      }
    }
    if (!this.ready) {
      return;
    }
    if (this.current === this.screenCount - 1) {
      if (this.atEnd) {
        this.hideCurrent();
        this.current = 0;
        this.atEnd = false;
        this.stack.find('.the-end').hide();
        this.showCurrent();
      } else {
        this.stack.find('.the-end').show();
        this.atEnd = true;
        this.nextBtn.toggleClass('disabled', this.atEnd);
      }
      return;
    }
    this.hideCurrent();
    this.current += 1;
    return this.showCurrent();
  };

  Viewer.prototype.prevPage = function(e) {
    if (e != null) {
      if (typeof e.preventDefault === "function") {
        e.preventDefault();
      }
    }
    if (!this.ready) {
      return;
    }
    if (this.atEnd) {
      this.stack.find('.the-end').hide();
      this.atEnd = false;
      this.nextBtn.toggleClass('disabled', this.atEnd);
      return;
    }
    if (this.current === 0) {
      return;
    }
    this.hideCurrent();
    this.current -= 1;
    return this.showCurrent();
  };

  Viewer.prototype.onLoad = function() {
    var height;
    this.nextBtn.removeClass('disabled');
    this.loadingBar.addClass('done');
    this.locationBar.show();
    this.showCurrent();
    this.imageH = height = this.stack.show().find('img').height();
    this.imageW = this.stack.find('img').width();
    this.stack.find('.screen').hide();
    this.showCurrent();
    this.elem.css({
      width: this.imageW
    });
    this.stack.css({
      opacity: 0
    }).animate({
      height: height,
      opacity: 1
    });
    return this.ready = true;
  };

  Viewer.prototype.onLoadError = function(e) {
    var err;
    log.info("ERROR Loading image", e.target);
    this.progressBar.addClass('errors');
    this.loadingBar.hide();
    this.stack.find('img').remove();
    err = $("<div class='errors'>There were errors loading the images, please refresh your browser!</div>").hide();
    this.stack.append(err).show();
    return err.slideDown();
  };

  Viewer.prototype.showCurrent = function() {
    var percent;
    $(this.stack.find('.screen').get(this.current)).show();
    percent = Math.ceil((this.current + 1) / this.screenCount * 100);
    this.locationBar.width("" + percent + "%");
    this.locationBar.toggleClass('done', percent >= 100);
    this.prevBtn.toggleClass('disabled', this.current === 0);
    return this.nextBtn.toggleClass('disabled', this.atEnd);
  };

  Viewer.prototype.hideCurrent = function() {
    return $(this.stack.find('.screen').get(this.current)).hide();
  };

  Viewer.prototype.getData = function() {
    var data, from, i, mdl, screens, to, _i;
    screens = [];
    from = this.model.start;
    to = this.model.start + (this.screenCount - 1);
    for (i = _i = from; from <= to ? _i <= to : _i >= to; i = from <= to ? ++_i : --_i) {
      mdl = {
        src: build_url(this.model.path, i)
      };
      screens.push(mdl);
    }
    data = this.model;
    data.screens = screens;
    data.id = this.id;
    return data;
  };

  Viewer.prototype.onRender = function() {
    var _this = this;
    preloader(this.elem).onError(this.onLoadError).onLoad(this.onLoad).onProgress(function(percent) {
      _this.loadingBar.width("" + percent + "%");
      if (percent >= 100) {
        return _this.loadingBar.addClass('done');
      }
    }).start();
    this.nextBtn.addClass('disabled');
    this.prevBtn.addClass('disabled');
    this.locationBar.hide();
    this.elem.on('focus', this.didFocus).on('blur', this.didBlur);
    if (env.mobile) {
      Hammer(this.stack.get(0), {
        prevent_default: true
      }).on('swipeleft', this.nextPage).on('swiperight', this.prevPage).on('tap', this.didTap);
      Hammer(this.nextBtn.get(0), {
        prevent_default: true
      }).on('tap', this.nextPage);
      return Hammer(this.prevBtn.get(0), {
        prevent_default: true
      }).on('tap', this.prevPage);
    } else {
      return this.elem.on('click', '.nextPage', this.nextPage).on('click', '.prevPage', this.prevPage).on('click', '.screen', this.didTap);
    }
  };

  Viewer.prototype.onDomActive = function() {
    if (this.options.autofocus) {
      return this.elem.focus();
    }
  };

  return Viewer;

})(CogView);

module.exports = Viewer;

},
"viewer/preloader": function(exports, require, module) {
var Preloader, log,
  _this = this;

log = require('util/log').prefix('preloader:');

Preloader = (function() {

  function Preloader(root) {
    var _this = this;
    this.didError = function(e) {
      return Preloader.prototype.didError.apply(_this, arguments);
    };
    this.didLoad = function(e) {
      return Preloader.prototype.didLoad.apply(_this, arguments);
    };
    this.elem = $(root);
  }

  Preloader.prototype.onError = function(errorCallback) {
    this.errorCallback = errorCallback;
    return this;
  };

  Preloader.prototype.onProgress = function(progressCallback) {
    this.progressCallback = progressCallback;
    return this;
  };

  Preloader.prototype.onLoad = function(loadCallback) {
    this.loadCallback = loadCallback;
    return this;
  };

  Preloader.prototype.start = function() {
    var images;
    images = this.elem.find('img');
    this.total = images.length;
    this.count = 0;
    images.on('error', this.didError).on('load', this.didLoad);
    return this;
  };

  Preloader.prototype.didLoad = function(e) {
    var percent;
    this.count += 1;
    percent = Math.floor((this.count / this.total) * 100);
    if (typeof this.progressCallback === "function") {
      this.progressCallback(percent);
    }
    if (this.count === this.total) {
      if (typeof this.progressCallback === "function") {
        this.progressCallback(100);
      }
      this.elem.find('img').off();
      delete this.elem;
      return typeof this.loadCallback === "function" ? this.loadCallback(e) : void 0;
    }
  };

  Preloader.prototype.didError = function(e) {
    if (typeof this.progressCallback === "function") {
      this.progressCallback(100);
    }
    this.elem.find('img').off();
    delete this.elem;
    return typeof this.errorCallback === "function" ? this.errorCallback(e) : void 0;
  };

  return Preloader;

})();

module.exports = function(root) {
  return new Preloader(root);
};

},
"viewer/template": function(exports, require, module) {
module.exports= function(__obj) {
  if (!__obj) __obj = {};
  var __out = [], __capture = function(callback) {
    var out = __out, result;
    __out = [];
    callback.call(this);
    result = __out.join('');
    __out = out;
    return __safe(result);
  }, __sanitize = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else if (typeof value !== 'undefined' && value != null) {
      return __escape(value);
    } else {
      return '';
    }
  }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
  __safe = __obj.safe = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else {
      if (!(typeof value !== 'undefined' && value != null)) value = '';
      var result = new String(value);
      result.ecoSafe = true;
      return result;
    }
  };
  if (!__escape) {
    __escape = __obj.escape = function(value) {
      return ('' + value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
    };
  }
  (function() {
    (function() {
      var i, screen, _i, _len, _ref;
    
      __out.push('<header>');
    
      __out.push(__sanitize(this.title));
    
      __out.push('</header> \n<div class="screen-stack">');
    
      _ref = this.screens;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        screen = _ref[i];
        __out.push(' \n<div class="screen"><img src="');
        __out.push(__sanitize(screen.src));
        __out.push('"/></div> \n');
      }
    
      __out.push(' \n<div class="screen the-end">\n    <div class="button">Restart from beginning.</div>\n  </div>\n</div> \n');
    
      if (this.copyright != null) {
        __out.push(' \n<footer class="copyright">\n  ');
        __out.push(__sanitize(this.copyright));
        __out.push('\n</footer> \n');
      }
    
      __out.push(' \n<footer class="pager"> \n<div class="prevPage button">&lsaquo;</div> \n<div class="progress">\n  <div class="bar background">&nbsp;</div>\n  <div class="bar loading done">&nbsp;</div>\n  <div class="bar location">&nbsp;</div>\n</div> \n<div class="nextPage button">&rsaquo;</div> \n</footer>');
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
};
}});
flipbook('main');
