(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["dashboard"],{"097b":function(t,a,s){},"0cc7":function(t,a,s){},"13d5":function(t,a,s){"use strict";var e=s("23e7"),r=s("d58f").left,n=s("b301");e({target:"Array",proto:!0,forced:n("reduce")},{reduce:function(t){return r(this,t,arguments.length,arguments.length>1?arguments[1]:void 0)}})},"2ac7":function(t,a,s){"use strict";var e=s("097b"),r=s.n(e);r.a},7277:function(t,a,s){"use strict";s.r(a);var e=function(){var t=this,a=t.$createElement,s=t._self._c||a;return s("div",{staticClass:"page page--dashboard"},[t.showLoadingState||t.showEmptyState?t._e():s("div",{staticClass:"page--dashboard__cards"},t._l(t.standards,(function(t){return s("Standard",{key:t.id,attrs:{standard:t,label:"Standard"}})})),1),t.showLoadingState?s("div",{staticClass:"page--dashboard__state--loading"},[s("Loading")],1):t._e(),t.showEmptyState?s("div",{staticClass:"page--dashboard__state--empty"},[s("div",{staticClass:"page--dashboard__state--empty__description"},[s("span",[t._v("No standards found ")]),t.selectedOccupation?s("span",[t._v("for occupation "+t._s(t.selectedOccupation.title))]):t._e()]),s("div",{staticClass:"page--dashboard__state--empty__action"},[t._v(" Please try searching for a different occupation ")]),s("div",{staticClass:"page--dashboard__state--empty__button button button--link",on:{click:t.clearSelectedOccupation}},[t._v(" Clear selected occupation ")])]):t._e()])},r=[],n=(s("a4d3"),s("4de4"),s("4160"),s("e439"),s("dbb4"),s("b64b"),s("159b"),s("2fa7")),o=s("2f62"),d=function(){var t=this,a=t.$createElement,s=t._self._c||a;return s("router-link",{staticClass:"standard",attrs:{to:t.routerLink}},[s("div",{staticClass:"standard__label"},[t._v(t._s(t.label))]),s("div",{staticClass:"standard__logo"},[s("img",{staticClass:"standard__logo__logo",attrs:{src:t.standard.organization.logo,alt:t.standard.organizationTitle}})]),s("div",{staticClass:"standard__occupation-name"},[t._v(t._s(t.standard.title))]),s("div",{staticClass:"standard__occupation-metadata"},[s("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__type"},[t._v(t._s(t.standard.occupation.type))]),s("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__onet"},[t._v(t._s(t.standard.occupation.onet))]),s("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__cb"},[t._v(t._s(t.standard.occupation.cb))])]),s("div",{staticClass:"standard__divider--stats"}),s("div",{staticClass:"standard__work-process-data"},[s("div",{staticClass:"standard__work-process-data__stat"},[s("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.standard.workProcesses.length))]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Work")]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Processes")])]),s("div",{staticClass:"standard__work-process-data__stat"},[s("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.totalNumberOfCompetencies))]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Total")]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Competencies")])]),s("div",{staticClass:"standard__work-process-data__stat"},[s("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.totalNumberOfHours))]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Total")]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Hours")])])])])},c=[],i=(s("13d5"),s("e589")),_=s.n(i),u={props:{standard:Object,label:String},data:function(){return{ICON_LEFT_NAV_HEART:_.a}},computed:{totalNumberOfCompetencies:function(){return this.standard.workProcesses.reduce((function(t,a){return t+(a.skills||[]).length}),0)},totalNumberOfHours:function(){return this.standard.workProcesses.reduce((function(t,a){return t+a.hoursTotal||0}),0)},routerLink:function(){return{name:"standard",params:{id:this.standard.id}}}}},l=u,p=(s("2ac7"),s("2877")),b=Object(p["a"])(l,d,c,!1,null,"b00ebdfc",null),f=b.exports,v=s("3a5e"),m=s("a1cc"),h=s.n(m);function g(t,a){var s=Object.keys(t);if(Object.getOwnPropertySymbols){var e=Object.getOwnPropertySymbols(t);a&&(e=e.filter((function(a){return Object.getOwnPropertyDescriptor(t,a).enumerable}))),s.push.apply(s,e)}return s}function w(t){for(var a=1;a<arguments.length;a++){var s=null!=arguments[a]?arguments[a]:{};a%2?g(s,!0).forEach((function(a){Object(n["a"])(t,a,s[a])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(s)):g(s).forEach((function(a){Object.defineProperty(t,a,Object.getOwnPropertyDescriptor(s,a))}))}return t}var C={name:"dashboard",components:{Standard:f,Loading:v["a"]},methods:{clearSelectedOccupation:function(){this.$store.dispatch("occupations/setSelectedOccupation")}},computed:w({},Object(o["b"])({showEmptyState:"standards/standardsListEmptyAndNotLoading"}),{},Object(o["c"])({selectedOccupation:function(t){return t.occupations.selectedOccupation},showLoadingState:function(t){return t.standards.loading}}),{standards:function(){return this.$store.state.standards.list.forEach((function(t){Object.assign(t,{organization:{logo:h.a,name:"WIN"},occupation:{name:"Mechatronics Technician",type:"Hybrid",onet:"51-4012.00",cb:"1100CB"}})})),this.$store.state.standards.list}})},O=C,y=(s("8524"),Object(p["a"])(O,e,r,!1,null,"c99d4644",null));a["default"]=y.exports},8524:function(t,a,s){"use strict";var e=s("0cc7"),r=s.n(e);r.a},a1cc:function(t,a,s){t.exports=s.p+"img/win.a1c57495.png"},d58f:function(t,a,s){var e=s("1c0b"),r=s("7b0b"),n=s("44ad"),o=s("50c4"),d=function(t){return function(a,s,d,c){e(s);var i=r(a),_=n(i),u=o(i.length),l=t?u-1:0,p=t?-1:1;if(d<2)while(1){if(l in _){c=_[l],l+=p;break}if(l+=p,t?l<0:u<=l)throw TypeError("Reduce of empty array with no initial value")}for(;t?l>=0:u>l;l+=p)l in _&&(c=s(c,_[l],l,i));return c}};t.exports={left:d(!1),right:d(!0)}}}]);
//# sourceMappingURL=dashboard.a8203ce6.js.map