!function(){"use strict";var r="undefined"==typeof window?global:window;if("function"!=typeof r.require){var e={},n={},t={},i={}.hasOwnProperty,o=/^\.\.?(\/|$)/,u=function(r,e){for(var n,t=[],i=(o.test(e)?r+"/"+e:e).split("/"),u=0,l=i.length;l>u;u++)n=i[u],".."===n?t.pop():"."!==n&&""!==n&&t.push(n);return t.join("/")},l=function(r){return r.split("/").slice(0,-1).join("/")},c=function(e){return function(n){var t=u(l(e),n);return r.require(t,e)}},a=function(r,e){var t=null;t=g&&g.createHot(r);var i={id:r,exports:{},hot:t};return n[r]=i,e(i.exports,c(r),i),i.exports},f=function(r){return t[r]?f(t[r]):r},s=function(r,e){return f(u(l(r),e))},p=function(r,t){null==t&&(t="/");var o=f(r);if(i.call(n,o))return n[o].exports;if(i.call(e,o))return a(o,e[o]);throw new Error("Cannot find module '"+r+"' from '"+t+"'")};p.alias=function(r,e){t[e]=r};var d=/\.[^.\/]+$/,v=/\/index(\.[^\/]+)?$/,_=function(r){if(d.test(r)){var e=r.replace(d,"");i.call(t,e)&&t[e].replace(d,"")!==e+"/index"||(t[e]=r)}if(v.test(r)){var n=r.replace(v,"");i.call(t,n)||(t[n]=r)}};p.register=p.define=function(r,t){if("object"==typeof r)for(var o in r)i.call(r,o)&&p.register(o,r[o]);else e[r]=t,delete n[r],_(r)},p.list=function(){var r=[];for(var n in e)i.call(e,n)&&r.push(n);return r};var g=r._hmr&&new r._hmr(s,p,e,n);p._cache=n,p.hmr=g&&g.wrap,p.brunch=!0,r.require=p}}(),function(){window;require.register("initialize.js",function(r,e,n){"use strict";document.addEventListener("DOMContentLoaded",function(){console.log("Initialized app")})}),require.register("logger.js",function(r,e,n){"use strict";console.log("Hello, world")}),require.register("___globals___",function(r,e,n){})}(),require("___globals___");