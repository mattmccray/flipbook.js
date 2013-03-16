/* FlipBook v1.0.0-48 */
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
var Viewer, ensure, env, hammertime, init, log;

env = require('env');

log = require('util/log').prefix('main:');

ensure = require('util/ensure');

require('theme').activate();

Viewer = require('viewer/controller');

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
  if (env.debug) {
    log.level(2);
  }
  log.info("FlipBook v" + env.version);
  log.info("ENV", env);
  log.info("Ready.");
  return $('[data-flipbook]').each(function(i, item) {
    var data, key, model, seg, v, value, _i, _len, _ref, _ref1;
    data = $(item).data('flipbook');
    model = {};
    _ref = data.split(',');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      seg = _ref[_i];
      _ref1 = seg.split(':'), key = _ref1[0], value = _ref1[1];
      model[$.trim(key)] = $.trim(value);
    }
    v = (new Viewer({
      model: model
    })).render();
    return $(item).empty().append(v.elem);
  });
};

},
"theme": function(exports, require, module) {
var node = null, css = ".flipbook {\n  font-family: \"Helvetica Neue\", Helvetica, Sans-Serif;\n  -webkit-user-select: none;\n  -moz-user-select: none;\n  -ms-user-select: none;\n  user-select: none;\n  width: 100%;\n}\n.flipbook div,\n.flipbook span,\n.flipbook object,\n.flipbook iframe,\n.flipbook h1,\n.flipbook h2,\n.flipbook h3,\n.flipbook h4,\n.flipbook h5,\n.flipbook h6,\n.flipbook p,\n.flipbook pre,\n.flipbook a,\n.flipbook abbr,\n.flipbook acronym,\n.flipbook address,\n.flipbook code,\n.flipbook del,\n.flipbook dfn,\n.flipbook em,\n.flipbook img,\n.flipbook dl,\n.flipbook dt,\n.flipbook dd,\n.flipbook ol,\n.flipbook ul,\n.flipbook li,\n.flipbook fieldset,\n.flipbook form,\n.flipbook label,\n.flipbook legend,\n.flipbook caption,\n.flipbook tbody,\n.flipbook tfoot,\n.flipbook thead,\n.flipbook tr {\n  margin: 0;\n  padding: 0;\n  border: 0;\n  outline: 0;\n  font-weight: inherit;\n  font-style: inherit;\n  font-family: inherit;\n  font-size: 100%;\n  vertical-align: baseline;\n}\n.flipbook table {\n  border-collapse: separate;\n  border-spacing: 0;\n  vertical-align: middle;\n}\n.flipbook caption,\n.flipbook th,\n.flipbook td {\n  text-align: left;\n  font-weight: normal;\n  vertical-align: middle;\n}\n.flipbook a img {\n  border: none;\n}\n.flipbook .screen-stack {\n  position: relative;\n  overflow: hidden;\n  width: 100%;\n}\n.flipbook .screen-stack .screen {\n  position: absolute;\n  top: 0;\n  left: 0;\n}\n.flipbook .screen-stack .screen img {\n  max-width: 100%;\n}\n.flipbook .progress .loading {\n  color: #f0f0f0;\n}\n.flipbook .progress .loaded {\n  color: #ddd;\n}\n.flipbook .progress .error {\n  color: #f00;\n}\n.flipbook .progress .current {\n  color: #000;\n}\n";
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
  hammer: function() {
    return typeof Hammer !== "undefined" && Hammer !== null ? Hammer : '//cdnjs.cloudflare.com/ajax/libs/hammer.js/0.6.4/hammer.js';
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
  script.src = "" + protocol + url;
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
"version": function(exports, require, module) {

module.exports = "1.0.0-48";

},
"viewer/controller": function(exports, require, module) {
var BaseView, CogView, Viewer, events, log, nextKeys, prevKeys, uid,
  _this = this,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

uid = require('util/uid');

log = require('util/log').prefix('controller:');

events = require('cog/events');

CogView = require('cog/view');

BaseView = (function() {

  function BaseView(options) {
    this.options = options != null ? options : {};
    this.id = uid('view-');
    this.elem = this.options.elem;
    if (typeof this.initialize === "function") {
      this.initialize();
    }
  }

  BaseView.prototype.assignEvents = function() {
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

  BaseView.prototype.unassignEvents = function() {
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

  BaseView.prototype.assignOutlets = function() {
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

  BaseView.prototype.unassignOutlets = function() {
    var elem, outlet, _ref;
    _ref = this.ui;
    for (outlet in _ref) {
      elem = _ref[outlet];
      delete this.ui[outlet];
    }
    return this;
  };

  return BaseView;

})();

nextKeys = [39, 32];

prevKeys = [37];

Viewer = (function(_super) {

  __extends(Viewer, _super);

  function Viewer() {
    var _this = this;
    this.imageDidError = function(e) {
      return Viewer.prototype.imageDidError.apply(_this, arguments);
    };
    this.imageDidLoad = function(e) {
      return Viewer.prototype.imageDidLoad.apply(_this, arguments);
    };
    this.prevPage = function(e) {
      return Viewer.prototype.prevPage.apply(_this, arguments);
    };
    this.nextPage = function(e) {
      return Viewer.prototype.nextPage.apply(_this, arguments);
    };
    this.onKeyInput = function(e) {
      return Viewer.prototype.onKeyInput.apply(_this, arguments);
    };
    return Viewer.__super__.constructor.apply(this, arguments);
  }

  Viewer.prototype.className = 'flipbook';

  Viewer.prototype.template = require('./template');

  Viewer.prototype.events = {
    'click .nextPage': 'nextPage',
    'click .prevPage': 'prevPage',
    'click .screen img': 'prevPage'
  };

  Viewer.prototype.outlets = {
    stack: '.screen-stack'
  };

  Viewer.prototype.initialize = function() {
    this.screenCount = parseInt(this.model.pages);
    this.current = 0;
    return this.ready = false;
  };

  Viewer.prototype.onKeyInput = function(e) {
    var _ref, _ref1;
    if (!this.ready) {
      return;
    }
    if (_ref = e.which, __indexOf.call(nextKeys, _ref) >= 0) {
      this.nextPage(e);
      return false;
    } else if (_ref1 = e.which, __indexOf.call(prevKeys, _ref1) >= 0) {
      this.prevPage(e);
      return false;
    }
  };

  Viewer.prototype.nextPage = function(e) {
    if (e != null) {
      if (typeof e.preventDefault === "function") {
        e.preventDefault();
      }
    }
    if (this.current === this.screenCount - 1) {
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
    if (this.current === 0) {
      return;
    }
    this.hideCurrent();
    this.current -= 1;
    return this.showCurrent();
  };

  Viewer.prototype.loadCheck = function() {
    var height;
    if (this.loadCount === this.screenCount) {
      this.showCurrent();
      height = this.stack.show().find('img').height();
      this.stack.find('.screen').hide();
      this.showCurrent();
      this.stack.css({
        opacity: 0
      }).animate({
        height: height,
        opacity: 1
      });
      return this.ready = true;
    }
  };

  Viewer.prototype.imageDidLoad = function(e) {
    var idx;
    this.loadCount += 1;
    idx = $(e.target).data('idx');
    this.elem.find("span[data-idx=" + idx + "]").removeClass('loading').addClass('loaded');
    return this.loadCheck();
  };

  Viewer.prototype.imageDidError = function(e) {
    log.info("ERROR");
    this.loadCount += 1;
    $(e.target).removeClass('loading').addClass('error');
    return this.loadCheck();
  };

  Viewer.prototype.showCurrent = function() {
    $(this.stack.find('.screen').get(this.current)).show();
    return this.elem.find("span[data-idx=" + this.current + "]").addClass('current');
  };

  Viewer.prototype.hideCurrent = function() {
    $(this.stack.find('.screen').get(this.current)).hide();
    return this.elem.find("span[data-idx=" + this.current + "]").removeClass('current');
  };

  Viewer.prototype.getData = function() {
    var data, i, screens, _i, _ref;
    screens = [];
    for (i = _i = 1, _ref = this.screenCount; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
      screens.push({
        src: "media/comics/" + i + ".jpg"
      });
    }
    data = this.model;
    data.screens = screens;
    data.id = this.id;
    return data;
  };

  Viewer.prototype.onRender = function() {
    this.loadCount = 0;
    this.elem.find('img').on('load', this.imageDidLoad).on('error', this.imageDidError);
    return $(document).on('keydown', this.onKeyInput);
  };

  return Viewer;

})(CogView);

module.exports = Viewer;

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
      var i, screen, _i, _j, _len, _len1, _ref, _ref1;
    
      __out.push('<header>\n  ');
    
      __out.push(__sanitize(this.title));
    
      __out.push('\n</header>\n<div class="screen-stack">\n');
    
      _ref = this.screens;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        screen = _ref[i];
        __out.push('\n  <div class="screen"><img data-idx="');
        __out.push(__sanitize(i));
        __out.push('" src="');
        __out.push(__sanitize(screen.src));
        __out.push('"/></div>\n');
      }
    
      __out.push('\n</div>\n<footer>\n  <div class="prevPage">&laquo;</div>\n  <div class="progress">\n');
    
      _ref1 = this.screens;
      for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
        screen = _ref1[i];
        __out.push('\n    <span data-idx="');
        __out.push(__sanitize(i));
        __out.push('" class="loading"> &middot; </span>\n');
      }
    
      __out.push('\n  </div>\n  <div class="nextPage">&raquo;</div>\n</footer>');
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
};
}});
flipbook('main');
