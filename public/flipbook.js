/* FlipBook v1.0.0-12 */
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
"cog/controller": function(exports, require, module) {



},
"cog/events": function(exports, require, module) {



},
"cog/model": function(exports, require, module) {



},
"main": function(exports, require, module) {
var ensure, init, log;

log = require('util/log').prefix('main:');

ensure = require('util/ensure');

require('theme').activate();

ensure('jquery', function(err) {
  if (err != null) {
    throw err;
  }
  log.info("jQuery is ready!");
  return $(init);
});

init = function() {
  log.info("Log level is", log.level());
  log.info("Ready.");
  return document.body.innerHTML = "Ready.";
};

},
"theme": function(exports, require, module) {
var node = null, css = "html,\nbody,\ndiv,\nspan,\napplet,\nobject,\niframe,\nh1,\nh2,\nh3,\nh4,\nh5,\nh6,\np,\nblockquote,\npre,\na,\nabbr,\nacronym,\naddress,\nbig,\ncite,\ncode,\ndel,\ndfn,\nem,\nimg,\nins,\nkbd,\nq,\ns,\nsamp,\nsmall,\nstrike,\nstrong,\nsub,\nsup,\ntt,\nvar,\ndl,\ndt,\ndd,\nol,\nul,\nli,\nfieldset,\nform,\nlabel,\nlegend,\ntable,\ncaption,\ntbody,\ntfoot,\nthead,\ntr,\nth,\ntd {\n  margin: 0;\n  padding: 0;\n  border: 0;\n  outline: 0;\n  font-weight: inherit;\n  font-style: inherit;\n  font-family: inherit;\n  font-size: 100%;\n  vertical-align: baseline;\n}\nbody {\n  line-height: 1;\n  color: #000;\n  background: #fff;\n}\nol,\nul {\n  list-style: none;\n}\ntable {\n  border-collapse: separate;\n  border-spacing: 0;\n  vertical-align: middle;\n}\ncaption,\nth,\ntd {\n  text-align: left;\n  font-weight: normal;\n  vertical-align: middle;\n}\na img {\n  border: none;\n}\nbody {\n  font-family: \"Helvetica Neue\", Helvetica, Sans-Serif;\n}\n";
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
"util/defaults": function(exports, require, module) {
var defaults;

module.exports = defaults = function(obj) {
  var key, source, value, _i, _len, _ref;
  _ref = Array.prototype.slice.call(arguments, 1);
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    source = _ref[_i];
    if (source) {
      for (key in source) {
        value = source[key];
        if (obj[key] == null) {
          obj[key] = value;
        } else if (type(obj[key]) === 'object') {
          obj[key] = defaults({}, obj[key], value);
        }
      }
    }
  }
  return obj;
};

},
"util/ensure": function(exports, require, module) {
var libs, load_script, loader, log,
  __slice = [].slice;

log = require('./log');

libs = {
  jquery: {
    url: '//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js',
    test: function() {
      return window.jQuery != null;
    }
  },
  jqueryui: {
    url: '//ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js',
    test: function() {
      return window.jQuery.Widget != null;
    }
  },
  webfont: {
    url: '//ajax.googleapis.com/ajax/libs/webfont/1.1.2/webfont.js',
    test: function() {
      return window.WebFont != null;
    }
  },
  angular: {
    url: '//ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js',
    test: function() {
      return window.angular != null;
    }
  },
  backbone: {
    url: '//cdnjs.cloudflare.com/ajax/libs/backbone.js/0.9.10/backbone-min.js',
    test: function() {
      return window.Backbone != null;
    }
  },
  underscore: {
    url: '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js',
    test: function() {
      return window._ != null;
    }
  },
  marionette: {
    url: '//cdnjs.cloudflare.com/ajax/libs/backbone.marionette/1.0.0-rc4-bundled/backbone.marionette.min.js',
    test: function() {
      return window.Backbone.Marionette != null;
    }
  },
  zepto: {
    url: '//cdnjs.cloudflare.com/ajax/libs/zepto/1.0/zepto.min.js',
    test: function() {
      return window.Zepto != null;
    }
  }
};

load_script = function(name, callback) {
  var def, protocol, script, url;
  protocol = location.protocol === 'file:' ? "http:" : '';
  def = libs[name];
  if (def == null) {
    return callback(new Error("Library not found. (" + name + ")"));
  }
  if (def.test()) {
    return callback(null);
  }
  url = def.url;
  script = document.createElement('script');
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
  document.getElementsByTagName('HTML')[0].appendChild(script);
  return script;
};

loader = function() {
  var callback, libs, load_handler, nextLib;
  libs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  log.debug("loading", libs);
  log.debug(libs.slice(-1));
  callback = typeof libs.slice(-1)[0] === 'function' ? libs.pop() : function(err) {
    if (err != null) {
      throw err;
    } else {
      return typeof console !== "undefined" && console !== null ? typeof console.log === "function" ? console.log("Library loading complete.") : void 0 : void 0;
    }
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

module.exports = loader;

},
"util/extend": function(exports, require, module) {

module.exports = function(obj) {
  var key, source, value, _i, _len, _ref;
  _ref = Array.prototype.slice.call(arguments, 1);
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    source = _ref[_i];
    if (source) {
      for (key in source) {
        value = source[key];
        obj[key] = value;
      }
    }
  }
  return obj;
};

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
"util/type": function(exports, require, module) {

module.exports = (function() {
  var classToType, elemParser, name, toStr, _i, _len, _ref;
  toStr = Object.prototype.toString;
  elemParser = /\[object HTML(.*)\]/;
  classToType = {};
  _ref = "Boolean Number String Function Array Date RegExp Undefined Null NodeList".split(" ");
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    name = _ref[_i];
    classToType["[object " + name + "]"] = name.toLowerCase();
  }
  return function(obj) {
    var found, strType;
    strType = toStr.call(obj);
    if (found = classToType[strType]) {
      return found;
    } else if (found = strType.match(elemParser)) {
      return found[1].toLowerCase();
    } else {
      return "object";
    }
  };
})();

},
"version": function(exports, require, module) {

module.exports = "1.0.0-12";

}});
flipbook('main');
