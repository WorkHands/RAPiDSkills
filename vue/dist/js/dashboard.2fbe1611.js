(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["dashboard"],{"00fd":function(t,a,n){var r=n("9e69"),s=Object.prototype,e=s.hasOwnProperty,o=s.toString,c=r?r.toStringTag:void 0;function i(t){var a=e.call(t,c),n=t[c];try{t[c]=void 0;var r=!0}catch(i){}var s=o.call(t);return r&&(a?t[c]=n:delete t[c]),s}t.exports=i},1304:function(t,a,n){var r=n("cd9d");function s(t){return"function"==typeof t?t:r}t.exports=s},1310:function(t,a){function n(t){return null!=t&&"object"==typeof t}t.exports=n},"13d5":function(t,a,n){"use strict";var r=n("23e7"),s=n("d58f").left,e=n("b301");r({target:"Array",proto:!0,forced:e("reduce")},{reduce:function(t){return s(this,t,arguments.length,arguments.length>1?arguments[1]:void 0)}})},"1a8c":function(t,a){function n(t){var a=typeof t;return null!=t&&("object"==a||"function"==a)}t.exports=n},"29f3":function(t,a){var n=Object.prototype,r=n.toString;function s(t){return r.call(t)}t.exports=s},"2b3e":function(t,a,n){var r=n("585a"),s="object"==typeof self&&self&&self.Object===Object&&self,e=r||s||Function("return this")();t.exports=e},3729:function(t,a,n){var r=n("9e69"),s=n("00fd"),e=n("29f3"),o="[object Null]",c="[object Undefined]",i=r?r.toStringTag:void 0;function d(t){return null==t?void 0===t?c:o:i&&i in Object(t)?s(t):e(t)}t.exports=d},4790:function(t,a,n){"use strict";var r=n("5700"),s=n.n(r);s.a},"4b17":function(t,a,n){var r=n("6428");function s(t){var a=r(t),n=a%1;return a===a?n?a-n:a:0}t.exports=s},"50d8":function(t,a){function n(t,a){var n=-1,r=Array(t);while(++n<t)r[n]=a(n);return r}t.exports=n},5700:function(t,a,n){},"585a":function(t,a,n){(function(a){var n="object"==typeof a&&a&&a.Object===Object&&a;t.exports=n}).call(this,n("c8ba"))},6428:function(t,a,n){var r=n("b4b0"),s=1/0,e=17976931348623157e292;function o(t){if(!t)return 0===t?t:0;if(t=r(t),t===s||t===-s){var a=t<0?-1:1;return a*e}return t===t?t:0}t.exports=o},7277:function(t,a,n){"use strict";n.r(a);var r=function(){var t=this,a=t.$createElement,n=t._self._c||a;return n("div",{staticClass:"page page--dashboard"},[n("div",{staticClass:"page--dashboard__cards"},t._l(t.standards,(function(t){return n("Standard",{key:t.id,attrs:{standard:t,label:"Standard"}})})),1)])},s=[],e=n("db1a"),o=n.n(e),c=function(){var t=this,a=t.$createElement,n=t._self._c||a;return n("div",{staticClass:"standard"},[n("div",{staticClass:"standard__label"},[t._v(t._s(t.label))]),n("div",{staticClass:"standard__logo"},[n("img",{staticClass:"standard__logo__logo",attrs:{src:t.standard.organization.logo,alt:t.standard.organization.name}})]),n("div",{staticClass:"standard__occupation-name"},[t._v(t._s(t.standard.occupation.name))]),n("div",{staticClass:"standard__occupation-metadata"},[n("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__type"},[t._v(t._s(t.standard.occupation.type))]),n("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__onet"},[t._v(t._s(t.standard.occupation.onet))]),n("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__cb"},[t._v(t._s(t.standard.occupation.cb))])]),n("div",{staticClass:"standard__divider--stats"}),n("div",{staticClass:"standard__work-process-data"},[n("div",{staticClass:"standard__work-process-data__stat"},[n("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.standard.workProcesses.length))]),n("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Work")]),n("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Processes")])]),n("div",{staticClass:"standard__work-process-data__stat"},[n("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.totalNumberOfCompetencies))]),n("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Total")]),n("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Competencies")])]),n("div",{staticClass:"standard__work-process-data__stat"},[n("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.totalNumberOfHours))]),n("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Total")]),n("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Hours")])])])])},i=[],d=(n("13d5"),n("e589")),u=n.n(d),_={props:{standard:Object,label:String},data:function(){return{ICON_LEFT_NAV_HEART:u.a}},computed:{totalNumberOfCompetencies:function(){return this.standard.workProcesses.reduce((function(t,a){return t+a.skills.length}),0)},totalNumberOfHours:function(){return this.standard.workProcesses.reduce((function(t,a){return t+a.hoursTotal}),0)}}},f=_,l=(n("4790"),n("2877")),p=Object(l["a"])(f,c,i,!1,null,"640fa896",null),v=p.exports,b=n("a1cc"),m=n.n(b),h={name:"dashboard",components:{Standard:v},data:function(){return{standards:o()(16,(function(t){return{key:t,organization:{logo:m.a,name:"WIN"},occupation:{name:"Mechatronics Technician",type:"Hybrid",onet:"51-4012.00",cb:"1100CB"},workProcesses:o()(18,(function(){return{skills:o()(8,(function(){return{}})),hoursTotal:334}}))}}))}}},w=h,g=(n("8259"),Object(l["a"])(w,r,s,!1,null,"1f251ce4",null));a["default"]=g.exports},8259:function(t,a,n){"use strict";var r=n("fd5d"),s=n.n(r);s.a},"9e69":function(t,a,n){var r=n("2b3e"),s=r.Symbol;t.exports=s},a1cc:function(t,a,n){t.exports=n.p+"img/win.a1c57495.png"},b301:function(t,a,n){"use strict";var r=n("d039");t.exports=function(t,a){var n=[][t];return!n||!r((function(){n.call(null,a||function(){throw 1},1)}))}},b4b0:function(t,a,n){var r=n("1a8c"),s=n("ffd6"),e=NaN,o=/^\s+|\s+$/g,c=/^[-+]0x[0-9a-f]+$/i,i=/^0b[01]+$/i,d=/^0o[0-7]+$/i,u=parseInt;function _(t){if("number"==typeof t)return t;if(s(t))return e;if(r(t)){var a="function"==typeof t.valueOf?t.valueOf():t;t=r(a)?a+"":a}if("string"!=typeof t)return 0===t?t:+t;t=t.replace(o,"");var n=i.test(t);return n||d.test(t)?u(t.slice(2),n?2:8):c.test(t)?e:+t}t.exports=_},cd9d:function(t,a){function n(t){return t}t.exports=n},d58f:function(t,a,n){var r=n("1c0b"),s=n("7b0b"),e=n("44ad"),o=n("50c4"),c=function(t){return function(a,n,c,i){r(n);var d=s(a),u=e(d),_=o(d.length),f=t?_-1:0,l=t?-1:1;if(c<2)while(1){if(f in u){i=u[f],f+=l;break}if(f+=l,t?f<0:_<=f)throw TypeError("Reduce of empty array with no initial value")}for(;t?f>=0:_>f;f+=l)f in u&&(i=n(i,u[f],f,d));return i}};t.exports={left:c(!1),right:c(!0)}},db1a:function(t,a,n){var r=n("50d8"),s=n("1304"),e=n("4b17"),o=9007199254740991,c=4294967295,i=Math.min;function d(t,a){if(t=e(t),t<1||t>o)return[];var n=c,d=i(t,c);a=s(a),t-=c;var u=r(d,a);while(++n<t)a(n);return u}t.exports=d},fd5d:function(t,a,n){},ffd6:function(t,a,n){var r=n("3729"),s=n("1310"),e="[object Symbol]";function o(t){return"symbol"==typeof t||s(t)&&r(t)==e}t.exports=o}}]);
//# sourceMappingURL=dashboard.2fbe1611.js.map