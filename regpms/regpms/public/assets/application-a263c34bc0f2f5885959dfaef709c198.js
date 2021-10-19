!function(s,d){var u;s.rails!==d&&s.error("jquery-ujs has already been loaded!");var e=s(document);s.rails=u={linkClickSelector:"a[data-confirm], a[data-method], a[data-remote], a[data-disable-with], a[data-disable]",buttonClickSelector:"button[data-remote]:not(form button), button[data-confirm]:not(form button)",inputChangeSelector:"select[data-remote], input[data-remote], textarea[data-remote]",formSubmitSelector:"form",formInputClickSelector:"form input[type=submit], form input[type=image], form button[type=submit], form button:not([type]), input[type=submit][form], input[type=image][form], button[type=submit][form], button[form]:not([type])",disableSelector:"input[data-disable-with]:enabled, button[data-disable-with]:enabled, textarea[data-disable-with]:enabled, input[data-disable]:enabled, button[data-disable]:enabled, textarea[data-disable]:enabled",enableSelector:"input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled, input[data-disable]:disabled, button[data-disable]:disabled, textarea[data-disable]:disabled",requiredInputSelector:"input[name][required]:not([disabled]),textarea[name][required]:not([disabled])",fileInputSelector:"input[type=file]",linkDisableSelector:"a[data-disable-with], a[data-disable]",buttonDisableSelector:"button[data-remote][data-disable-with], button[data-remote][data-disable]",CSRFProtection:function(e){var t=s('meta[name="csrf-token"]').attr("content");t&&e.setRequestHeader("X-CSRF-Token",t)},refreshCSRFTokens:function(){var e=s("meta[name=csrf-token]").attr("content"),t=s("meta[name=csrf-param]").attr("content");s('form input[name="'+t+'"]').val(e)},fire:function(e,t,a){var n=s.Event(t);return e.trigger(n,a),!1!==n.result},confirm:function(e){return confirm(e)},ajax:function(e){return s.ajax(e)},href:function(e){return e[0].href},handleRemote:function(n){var e,t,a,r,i,o;if(u.fire(n,"ajax:before")){if(r=n.data("with-credentials")||null,i=n.data("type")||s.ajaxSettings&&s.ajaxSettings.dataType,n.is("form")){e=n.attr("method"),t=n.attr("action"),a=n.serializeArray();var l=n.data("ujs:submit-button");l&&(a.push(l),n.data("ujs:submit-button",null))}else n.is(u.inputChangeSelector)?(e=n.data("method"),t=n.data("url"),a=n.serialize(),n.data("params")&&(a=a+"&"+n.data("params"))):n.is(u.buttonClickSelector)?(e=n.data("method")||"get",t=n.data("url"),a=n.serialize(),n.data("params")&&(a=a+"&"+n.data("params"))):(e=n.data("method"),t=u.href(n),a=n.data("params")||null);return o={type:e||"GET",data:a,dataType:i,beforeSend:function(e,t){if(t.dataType===d&&e.setRequestHeader("accept","*/*;q=0.5, "+t.accepts.script),!u.fire(n,"ajax:beforeSend",[e,t]))return!1;n.trigger("ajax:send",e)},success:function(e,t,a){n.trigger("ajax:success",[e,t,a])},complete:function(e,t){n.trigger("ajax:complete",[e,t])},error:function(e,t,a){n.trigger("ajax:error",[e,t,a])},crossDomain:u.isCrossDomain(t)},r&&(o.xhrFields={withCredentials:r}),t&&(o.url=t),u.ajax(o)}return!1},isCrossDomain:function(e){var t=document.createElement("a");t.href=location.href;var a=document.createElement("a");try{return a.href=e,a.href=a.href,!((!a.protocol||":"===a.protocol)&&!a.host||t.protocol+"//"+t.host==a.protocol+"//"+a.host)}catch(n){return!0}},handleMethod:function(e){var t=u.href(e),a=e.data("method"),n=e.attr("target"),r=s("meta[name=csrf-token]").attr("content"),i=s("meta[name=csrf-param]").attr("content"),o=s('<form method="post" action="'+t+'"></form>'),l='<input name="_method" value="'+a+'" type="hidden" />';i===d||r===d||u.isCrossDomain(t)||(l+='<input name="'+i+'" value="'+r+'" type="hidden" />'),n&&o.attr("target",n),o.hide().append(l).appendTo("body"),o.submit()},formElements:function(e,t){return e.is("form")?s(e[0].elements).filter(t):e.find(t)},disableFormElements:function(e){u.formElements(e,u.disableSelector).each(function(){u.disableFormElement(s(this))})},disableFormElement:function(e){var t,a;t=e.is("button")?"html":"val",a=e.data("disable-with"),e.data("ujs:enable-with",e[t]()),a!==d&&e[t](a),e.prop("disabled",!0)},enableFormElements:function(e){u.formElements(e,u.enableSelector).each(function(){u.enableFormElement(s(this))})},enableFormElement:function(e){var t=e.is("button")?"html":"val";e.data("ujs:enable-with")&&e[t](e.data("ujs:enable-with")),e.prop("disabled",!1)},allowAction:function(e){var t,a=e.data("confirm"),n=!1;return!a||(u.fire(e,"confirm")&&(n=u.confirm(a),t=u.fire(e,"confirm:complete",[n])),n&&t)},blankInputs:function(e,t,a){var n,r=s(),i=t||"input,textarea",o=e.find(i);return o.each(function(){if(n=s(this),!(n.is("input[type=checkbox],input[type=radio]")?n.is(":checked"):n.val())==!a){if(n.is("input[type=radio]")&&o.filter('input[type=radio]:checked[name="'+n.attr("name")+'"]').length)return!0;r=r.add(n)}}),!!r.length&&r},nonBlankInputs:function(e,t){return u.blankInputs(e,t,!0)},stopEverything:function(e){return s(e.target).trigger("ujs:everythingStopped"),e.stopImmediatePropagation(),!1},disableElement:function(e){var t=e.data("disable-with");e.data("ujs:enable-with",e.html()),t!==d&&e.html(t),e.bind("click.railsDisable",function(e){return u.stopEverything(e)})},enableElement:function(e){e.data("ujs:enable-with")!==d&&(e.html(e.data("ujs:enable-with")),e.removeData("ujs:enable-with")),e.unbind("click.railsDisable")}},u.fire(e,"rails:attachBindings")&&(s.ajaxPrefilter(function(e,t,a){e.crossDomain||u.CSRFProtection(a)}),e.delegate(u.linkDisableSelector,"ajax:complete",function(){u.enableElement(s(this))}),e.delegate(u.buttonDisableSelector,"ajax:complete",function(){u.enableFormElement(s(this))}),e.delegate(u.linkClickSelector,"click.rails",function(e){var t=s(this),a=t.data("method"),n=t.data("params"),r=e.metaKey||e.ctrlKey;if(!u.allowAction(t))return u.stopEverything(e);if(!r&&t.is(u.linkDisableSelector)&&u.disableElement(t),t.data("remote")===d)return t.data("method")?(u.handleMethod(t),!1):void 0;if(r&&(!a||"GET"===a)&&!n)return!0;var i=u.handleRemote(t);return!1===i?u.enableElement(t):i.error(function(){u.enableElement(t)}),!1}),e.delegate(u.buttonClickSelector,"click.rails",function(e){var t=s(this);if(!u.allowAction(t))return u.stopEverything(e);t.is(u.buttonDisableSelector)&&u.disableFormElement(t);var a=u.handleRemote(t);return!1===a?u.enableFormElement(t):a.error(function(){u.enableFormElement(t)}),!1}),e.delegate(u.inputChangeSelector,"change.rails",function(e){var t=s(this);return u.allowAction(t)?(u.handleRemote(t),!1):u.stopEverything(e)}),e.delegate(u.formSubmitSelector,"submit.rails",function(e){var t,a,n=s(this),r=n.data("remote")!==d;if(!u.allowAction(n))return u.stopEverything(e);if(n.attr("novalidate")==d&&(t=u.blankInputs(n,u.requiredInputSelector))&&u.fire(n,"ajax:aborted:required",[t]))return u.stopEverything(e);if(r){if(a=u.nonBlankInputs(n,u.fileInputSelector)){setTimeout(function(){u.disableFormElements(n)},13);var i=u.fire(n,"ajax:aborted:file",[a]);return i||setTimeout(function(){u.enableFormElements(n)},13),i}return u.handleRemote(n),!1}setTimeout(function(){u.disableFormElements(n)},13)}),e.delegate(u.formInputClickSelector,"click.rails",function(e){var t=s(this);if(!u.allowAction(t))return u.stopEverything(e);var a=t.attr("name"),n=a?{name:a,value:t.val()}:null;t.closest("form").data("ujs:submit-button",n)}),e.delegate(u.formSubmitSelector,"ajax:send.rails",function(e){this==e.target&&u.disableFormElements(s(this))}),e.delegate(u.formSubmitSelector,"ajax:complete.rails",function(e){this==e.target&&u.enableFormElements(s(this))}),s(function(){u.refreshCSRFTokens()}))}(jQuery),function(p){var e=0,b=function(){return(new Date).getTime()+e++},h=function(e){return"["+e+"]$1"},v=function(e){return"_"+e+"_$1"};p(document).on("click",".add_fields",function(e){e.preventDefault();var t=p(this),a=t.data("association"),n=t.data("associations"),r=t.data("association-insertion-template"),i=t.data("association-insertion-method")||t.data("association-insertion-position")||"before",o=t.data("association-insertion-node"),l=t.data("association-insertion-traversal"),s=parseInt(t.data("count"),10),d=new RegExp("\\[new_"+a+"\\](.*?\\s)","g"),u=new RegExp("_new_"+a+"_(\\w*)","g"),c=b(),m=r.replace(d,h(c)),f=[];for(m==r&&(d=new RegExp("\\[new_"+n+"\\](.*?\\s)","g"),u=new RegExp("_new_"+n+"_(\\w*)","g"),m=r.replace(d,h(c))),f=[m=m.replace(u,v(c))],s=isNaN(s)?1:Math.max(s,1),s-=1;s;)c=b(),m=(m=r.replace(d,h(c))).replace(u,v(c)),f.push(m),s-=1;o=o?l?t[l](o):"this"==o?t:p(o):t.parent(),p.each(f,function(e,t){var a=p(t);o.trigger("cocoon:before-insert",[a]);o[i](a);o.trigger("cocoon:after-insert",[a])})}),p(document).on("click",".remove_fields.dynamic, .remove_fields.existing",function(e){var t=p(this),a=t.data("wrapper-class")||"nested-fields",n=t.closest("."+a),r=n.parent();e.preventDefault(),r.trigger("cocoon:before-remove",[n]);var i=r.data("remove-timeout")||0;setTimeout(function(){t.hasClass("dynamic")?n.remove():(t.prev("input[type=hidden]").val("1"),n.hide()),r.trigger("cocoon:after-remove",[n])},i)}),p(".remove_fields.existing.destroyed").each(function(){var e=p(this),t=e.data("wrapper-class")||"nested-fields";e.closest("."+t).hide()})}(jQuery),function(u){"use strict";u.ajaxPrefilter(function(e){if(e.iframe)return"iframe"}),u.ajaxTransport("iframe",function(e,t,s){function d(){l.prop("disabled",!1),n.remove(),r.bind("load",function(){r.remove()}),r.attr("src","javascript:false;")}var a,n=null,r=null,i="iframe-"+u.now(),o=u(e.files).filter(":file:enabled"),l=null;if(e.dataTypes.shift(),o.length)return n=u("<form enctype='multipart/form-data' method='post'></form>").hide().attr({action:e.url,target:i}),"string"==typeof e.data&&0<e.data.length&&u.error("data must not be serialized"),u.each(e.data||{},function(e,t){u.isPlainObject(t)&&(e=t.name,t=t.value),u("<input type='hidden' />").attr({name:e,value:t}).appendTo(n)}),u("<input type='hidden' value='IFrame' name='X-Requested-With' />").appendTo(n),a=e.dataTypes[0]&&e.accepts[e.dataTypes[0]]?e.accepts[e.dataTypes[0]]+("*"!==e.dataTypes[0]?", */*; q=0.01":""):e.accepts["*"],u("<input type='hidden' name='X-Http-Accept'>").attr("value",a).appendTo(n),l=o.after(function(){return u(this).clone().prop("disabled",!0)}).next(),o.appendTo(n),{send:function(e,l){(r=u("<iframe src='javascript:false;' name='"+i+"' id='"+i+"' style='display:none'></iframe>")).bind("load",function(){r.unbind("load").bind("load",function(){var e=this.contentWindow?this.contentWindow.document:this.contentDocument?this.contentDocument:this.document,t=e.documentElement?e.documentElement:e.body,a=t.getElementsByTagName("textarea")[0],n=a&&a.getAttribute("data-type")||null,r=a&&a.getAttribute("data-status")||200,i=a&&a.getAttribute("data-statusText")||"OK",o={html:t.innerHTML,text:n?a.value:t?t.textContent||t.innerText:null};d(),s.responseText||(s.responseText=o.text),l(r,i,o,n?"Content-Type: "+n:null)}),n[0].submit()}),u("body").append(n,r)},abort:function(){null!==r&&(r.unbind("load").attr("src","javascript:false;"),d())}}})}(jQuery),function(i){var o;i.remotipart=o={setup:function(a){var r=a.data("ujs:submit-button");a.one("ajax:beforeSend.remotipart",function(e,t,n){return delete n.beforeSend,n.iframe=!0,n.files=i(i.rails.fileInputSelector,a),n.data=a.serializeArray(),r&&n.data.push(r),n.files.each(function(e,t){for(var a=n.data.length-1;0<=a;a--)n.data[a].name==t.name&&n.data.splice(a,1)}),n.processData=!1,n.dataType===undefined&&(n.dataType="script *"),n.data.push({name:"remotipart_submitted",value:!0}),i.rails.fire(a,"ajax:remotipartSubmit",[t,n])&&(i.rails.ajax(n),setTimeout(function(){i.rails.disableFormElements(a)},20)),o.teardown(a),!1}).data("remotipartSubmitted",!0)},teardown:function(e){e.unbind("ajax:beforeSend.remotipart").removeData("remotipartSubmitted")}},i(document).on("ajax:aborted:file","form",function(){var e=i(this);return o.setup(e),i.rails.handleRemote(e),!1})}(jQuery),function(){}.call(this),function(){jQuery(function(){var e;return e=$(".col-dropdown").length,console.log(e)})}.call(this),function(){jQuery(function(){return $("select").change(function(){return $(this).val()})})}.call(this);