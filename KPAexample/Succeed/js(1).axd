
var T = true;
var F = false;

function ExecuteRefreshMethod() {
	location.reload(true);
}

$(document).ready(function () {
    //Misc.CallLoaded();
    //Misc.StartRefreshMessage();
    //Misc.SetTitle();
});

var Box =
{
	Destroy: function (boxname) {
		var x = $(boxname);

		x.find('iframe').attr('src', '');
		x.hide();
	}
};

function $Get(ctl) {
	if (typeof (ctl) == "string") {
		return document.getElementById(ctl);
	}
	else {
		return ctl;
	}
}
var Show =
{
	FadeIn: 0,
	SlideIn: 1,
	Show: 2,
	FadeOut: 3,
	SlideOut: 4,
	Hide: 5,

	Action: function (tag, type, focus) {
		switch (type) {
			case Show.FadeIn:
				Display.Show('#' + tag, focus);
				break;
			case Show.SlideIn:
				Display.SlideDown('#' + tag, focus);
				break;
			case Show.Show:
				if (focus == null || focus == "" || focus == undefined) {
					$('#' + tag).show();
				}
				else {
					$('#' + tag).show(function () { Element.Focus(focus); });
				}
				break;
			case Show.FadeOut:
				Display.Hide('#' + tag);
				break;
			case Show.SlideOut:
				Display.SlideUp('#' + tag);
				break;
			case Show.Hide:
				$('#' + tag).hide();
				break;
		}
	}
};
var Display = {
	zIndex: function (ctl, zi) {
		if (zi == null) {
			$(ctl).css("zIndex", "10000");
		}
		else {
			$(ctl).css("zIndex", zi);
		}
	},

	Status: function (ctl, setTo) {
		if (setTo == null) {
			return $(ctl).css("display");
		}
		else {
			$(ctl).css("display", setTo);
		}
	},

	Show: function (ctl, fcs) {
		if (fcs == null) {
			$(ctl).show();
		} else {
			$(ctl).show();
			Element.Focus(fcs);
		}
	},

	Hide: function (ctl) {
		$(ctl).hide();
	},

	HideShow: function (hide, show) {
		//$(hide).fadeOut('slow', function() { $(show).fadeIn('slow'); });
		$(hide).hide();
		$(show).show();
	},

	SlideUp: function (ctl) {
		$(ctl).slideUp('slow');
		//$(ctl).hide();
	},

	SlideDown: function (ctl, fcs) {
		if (fcs == null) {
			$(ctl).slideDown('slow');
		}
		else {
			$(ctl).slideDown('slow', function () { Element.Select(fcs); });
		}
	},

	Visible: function (ctl, status) {
		if (status == true) {
			$(ctl).css("visibility", "visible");
		}
		else {
			$(ctl).css("visibility", "hidden");
		}
	},
	IsHidden: function (ctl) {
		return (Display.Status(ctl) == 'none');
	},
	Toggle: function (ctl, type) {
		$(val).toggle();
	},
	Dialog: function (ctl) {
		//$(ctl).fadeIn('slow', function() { GroupBox.Adjust(ctl, true, false, true, false); });
		Display.Show(ctl);
		GroupBox.Adjust(ctl, true, false, true, false);
	},
	HighlightOne: function (ctl) {
		var jq = $('#' + ctl);

		if (jq.attr('type') == 'button' || jq.attr('type') == 'submit') {
			jq.hover(function () {
				$(this).addClass('ButtonHover');
			}, function () {
				$(this).removeClass('ButtonHover');
			}).addClass('Button');
		}
		else {
			jq.focus(function () {
				$(this).addClass('TextFocus');
			}).blur(function () {
				$(this).removeClass('TextFocus');
			}).addClass('Text');
		}
	},
	Swap: function (hide, show, event) {
		$(hide).slideUp('slow', function () {
			$(show).slideDown('slow', function () {
				if (event != null) {
					eval(event);
				}
			}); 
		});
	},

	// Hide all of whatever a selector returns
	HideAll: function (stor) {
		var sel = $(stor);
		sel.css('display', 'none');
	},

	ShowAll: function (stor) {
		var sel = $(stor);
		sel.css('display', '');
	},

	ProcessErrors: function () {
		$('.ev').focus(
			function () {
				var t = $(this);

				if (t.attr('ev') != undefined) {
					t.val(t.attr('ev'));
					t.removeAttr('ev');
				}
				t.removeClass('ev');
			}
		);
	}

};
var Element = {
	Empty: function (ctl) {
		return $(ctl).isEmpty();
	},
	Set: function (ctl, txt) {
		if (txt == null)
			$(ctl).attr("value", "");
		else
			$(ctl).attr("value", txt);
	},
	Text: function (ctl) {
		return $(ctl).attr("value");
	},
	Clear: function (ctl) {
		Element.Set(ctl);
	},
	IsSelected: function (ctl) {
		return ($Get(ctl).selectedIndex > 0);
	},
	Selected: function (ctl, val) {
		if (val == null) {
			return $Get(ctl).selectedIndex;
		}
		else {
			$Get(ctl).selectedIndex = val;
		}
	},
	Focus: function (ctl) {
		//prevent error thrown from focusing a invisible control
		if ($('#' + ctl + ':visible').length == 0) {
			return;
		}
		var obj = $Get(ctl);
		if (obj != null) {
			obj.focus();
		}
	},
	Select: function (ctl) {
		$Get(ctl).select();
		$Get(ctl).focus();
	}
};
var MessageType = {
	Info: 'info',
	Help: 'help',
	Warning: 'warning',
	Ok: 'ok'
};
var Message_System = {
	IsSticky: false,                       // Should the message fade-away?
	FadeTime: 3000,                        // How long should before the fading occur?
	Type: MessageType.Info,                // The default type of message
	Message: '',                            // The default message
	Speed: 'slow'                           // How fast does the message fade?
};
var Message = {
	Initialized: false,

	Container: 'JgMessage',                // The Container of the messages,

	Initialize: function () {
		$("form").append("<div class='bottom-right' style='position:fixed;bottom:0%;' id='" + Message.Container + "'></div>");

		Message.Initialized = true;
	},

	Show: function (settings) {
		settings = $.extend({}, Message_System, settings);

		if (!Message.Initialized) {
			Message.Initialize();
		}
		if (frameElement != null && Misc.UseParent()) {
			parent.Message.Show(settings);
		}
		else {
		    $(".jGrowl-notification:nth-child(2)").remove(); //This is a hack to keep multiple messages from appearing at the same time (IE mostly) - JP

			$('#' + Message.Container).jGrowl(settings.Message, { sticky: settings.IsSticky, life: settings.FadeTime, speed: settings.Speed, type: settings.Type });
		}
	},

    ShowWarning : function(msg)
    {
        Message.Show({ Message: msg, Type: MessageType.Warning });
    },

	Warning: function (ctl, msg, alwaysshow) {
		var c = $(ctl);

		if (alwaysshow == "no" && c.hasClass('alreadyshown')) {
			return;
		}
		c.addClass('alreadyshown');

		Message.Show({ Type: MessageType.Warning, Message: msg });
	}
};
var Msg = {
	Show: function (settings) {
		settings = $.extend({}, { Text: '' }, settings);
		Message.Show({ Type: MessageType.Warning, Message: settings.Text });
	}
};

function lbSelected(obj) {
	$('#lbAll, #lbNum, #lbABC, #lbDEF, #lbGHI, #lbJKL, #lbMNO, #lbPQR, #lbSTU, #lbVWX, #lbYZ').removeClass('lbselected');
	$('#' + obj.id).addClass('lbselected').blur();
}
var Select =
{
	Link: function (obj) {
		Select.Remove();
		$(obj).addClass('lbselected').blur();
	},
	Remove: function () {
		$('div.top a').removeClass('lbselected');
	}
}
jQuery.preloadImages = function () {
	for (var i = 0; i < arguments.length; i++) {
		jQuery("<img>").attr("src", arguments[i]);
	}
};

//jQuery.IsIE = function () {
//	return jQuery.browser.msie;
//};

//jQuery.IsIE6 = function () {
//	return jQuery.browser.msie && parseInt(jQuery.browser.version) == 6;
//};

//jQuery.IsIE7 = function () {
//	return jQuery.browser.msie && parseInt(jQuery.browser.version) == 7;
//};

//jQuery.IsIE8 = function () {
//	return jQuery.browser.msie && parseInt(jQuery.browser.version) == 8;
//};

jQuery.fn.encHTML = function () {
	return this.each(function () {
		var me = jQuery(this);
		var html = me.html();
		me.html(html.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&apos;').replace(/"/g, '&quot;'));
	});
};

jQuery.fn.decHTML = function () {
	return this.each(function () {
		var me = jQuery(this);
		var html = me.html();
		me.html(html.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&apos;/g, '\'').replace(/&quot;/g, '"'));
	});
};

jQuery.fn.isEncHTML = function (str) {
	if (str.search(/&amp;/g) != -1 || str.search(/&lt;/g) != -1 || str.search(/&gt;/g) != -1 || str.search(/&apos;/g) != -1 || str.search(/&quot;/g) != -1) {
		return true;
	}
	else {
		return false;
	}
};

jQuery.fn.decHTMLifEnc = function () {
	return this.each(function () {
		var me = jQuery(this);
		var html = me.html();
		if (jQuery.fn.isEncHTML(html))
			me.decHTML();
	});
};
$.fn.isEmpty = function () {
	var isempty = true;

	this.each(
		function () {
			if (typeof (this.value) != 'undefined' && this.value.length != 0) {
				isempty = false;
			}
		}
	);
	return isempty;
};
jQuery.fn.bgiframe = function () {
	// This is only for IE6
	return this;
};
var SWeb = {
	IsFloat: function (v) {
		var RE = /^-{0,1}\d*\.{0,1}\d+$/;
		return (RE.test(v));
	},
	IsNumber: function (v) {
		var RE = /^-{0,1}\d+$/;
		return (RE.test(v));
	},
	ServiceFailure: function (error, userContext, methodName) {
		alert(error._exceptionType + ' in ' + methodName + ' : ' + error._message);
	},
	AjaxError: function (XMLHttprequest, textSTatus, errorThrown) {
		alert(XMLHttprequest.responseText);
	},
	ScriptError: function (err, url, line) {
		SWeb.__HandleError(err, url, line, printStackTrace());
	},
	__HandleError: function (err, url, line, stacktrace) {
		if (url.indexOf('WebResource.axd') != -1) {
			return;
		}
		if (url.indexOf('fckeditorcode') != -1) {
			return;
		}
		if (url.indexOf('ScriptResource.axd') != -1) {
			return;
		}
		$.ajax({
			type: "POST",
			dataType: "json",
			contentType: "application/json; charset=utf-8",
			url: "ScriptError.ashx?error=" + err + '&url=' + url + '&line=' + line + '&stacktrace=' + stacktrace
		});
	}
};
//window.onerror = SWeb.ScriptError;

function iFrameResize(frameName, ht) {
    $("#" + frameName).css('height', ht + 'px');
};

//Script to run advanced searches when the [Enter] key is pressed.
$(document).keydown(function (e) {
    if (e.which === 13) {
        if ($('.AdvancedSearchGroupBox').css("display") === "block") {
            $(".AdvancedSearchClick").click();
        }
    }
});
// Prevent the backspace key from navigating back.  To work in FireFox, IE and Chrome, it requires binding on both keydown and keypress as shown below.
$(document).bind('keydown', function (event) {
    var doPrevent = false;
    if (event.keyCode === 8) {
        var d = event.srcElement || event.target;
        if ((d.tagName.toUpperCase() === 'INPUT' &&
             (
                 d.type.toUpperCase() === 'TEXT' ||
                 d.type.toUpperCase() === 'PASSWORD' ||
                 d.type.toUpperCase() === 'FILE' ||
                 d.type.toUpperCase() === 'EMAIL' ||
                 d.type.toUpperCase() === 'SEARCH' ||
                 d.type.toUpperCase() === 'DATE')
             ) ||
             d.tagName.toUpperCase() === 'TEXTAREA') {
            doPrevent = d.readOnly || d.disabled;
        }
        else {
            doPrevent = true;
        }
    }

    if (doPrevent) {
        event.preventDefault();
    }
});

$(document).bind('keypress', function (event) {
    var doPrevent = false;
    if (event.keyCode === 8) {
        var d = event.srcElement || event.target;
        if ((d.tagName.toUpperCase() === 'INPUT' &&
             (
                 d.type.toUpperCase() === 'TEXT' ||
                 d.type.toUpperCase() === 'PASSWORD' ||
                 d.type.toUpperCase() === 'FILE' ||
                 d.type.toUpperCase() === 'EMAIL' ||
                 d.type.toUpperCase() === 'SEARCH' ||
                 d.type.toUpperCase() === 'DATE')
             ) ||
             d.tagName.toUpperCase() === 'TEXTAREA') {
            doPrevent = d.readOnly || d.disabled;
        }
        else {
            doPrevent = true;
        }
    }

    if (doPrevent) {
        event.preventDefault();
    }
});
(function($) {
	
	/** jGrowl Wrapper - Establish a base jGrowl Container for compatibility with older releases. **/
	$.jGrowl = function(m, o) {
		// To maintain compatibility with older version that only supported one instance we'll create the base container.
		if ($('#jGrowl').size() == 0) $('<div id="jGrowl"></div>').addClass($.jGrowl.defaults.position).appendTo('body');
		// Create a notification on the container.
		$('#jGrowl').jGrowl(m, o);
	};


	/** Raise jGrowl Notification on a jGrowl Container **/
	$.fn.jGrowl = function(m, o) {
		if ($.isFunction(this.each)) {
			var args = arguments;

			return this.each(function() {
				var self = this;

				/** Create a jGrowl Instance on the Container if it does not exist **/
				if ($(this).data('jGrowl.instance') == undefined) {
					$(this).data('jGrowl.instance', new $.fn.jGrowl());
					$(this).data('jGrowl.instance').startup(this);
				}

				/** Optionally call jGrowl instance methods, or just raise a normal notification **/
				if ($.isFunction($(this).data('jGrowl.instance')[m])) {
					$(this).data('jGrowl.instance')[m].apply($(this).data('jGrowl.instance'), $.makeArray(args).slice(1));
				} else {
					$(this).data('jGrowl.instance').notification(m, o);
				}
			});
		};
	};

	$.extend($.fn.jGrowl.prototype, {

		/** Default JGrowl Settings **/
		defaults: {
			sticky: false,
			position: 'bottom-left', // Is this still needed?
			glue: 'after',
			theme: 'default',
			corners: '10px',
			check: 500,
			life: 3000,
			speed: 'normal',
			easing: 'swing',
			log: function(e, m, o) { },
			beforeOpen: function(e, m, o) { },
			open: function(e, m, o) { },
			beforeClose: function(e, m, o) { },
			close: function(e, m, o) { },
			type: 'info',
			animateOpen: {
				opacity: 'show'
			},
			animateClose: {
				opacity: 'hide'
			}
		},

		/** jGrowl Container Node **/
		element: null,

		/** Interval Function **/
		interval: null,

		/** Create a Notification **/
		notification: function(message, o) {
			var self = this;
			var o = $.extend({}, this.defaults, o);

			o.log.apply(this.element, [this.element, message, o]);

			var alertType = "info";
		    var glyph = "info";

			if (o.type == "warning")
			{
			    glyph = "exclamation";
			    alertType = "danger";
			}
			else if (o.type == "ok")
			{
			    glyph = "ok";
			    alertType = "success";
			}

			var notification = $('<div class="jGrowl-notification alert alert-' + alertType + '"><div class="close">&times;</div><div class="jgrowl-' + o.type + '"><span class="glyphicon glyphicon-' + glyph + '-sign"></span><div class="innerJGrowlMessage">' + message + '</div></div></div>')
				.data("jGrowl", o).addClass(o.theme).children('div.close').bind("click.jGrowl", function() {
					$(this).unbind('click.jGrowl').parent().trigger('jGrowl.beforeClose').animate(o.animateClose, o.speed, o.easing, function() {
						$(this).trigger('jGrowl.close').remove();
					});
				}).parent();
			/*
			if (o.type == 'info') { notification.attr('title', "Information: " + message); }
			else if (o.type == 'warning') { notification.attr('title', "Warning: " + message); }
			else if (o.type == 'help') { notification.attr('title', "Help: " + message); }
			else if (o.type == 'ok') { notification.attr('title', "Ok: " + message); }
			*/
			//if (o.sticky) {
			//	notification.css("background", "#797979").attr('title', notification.attr('title') + ' - Click the x to close');
			//}


			(o.glue == 'after') ? $('div.jGrowl-notification:last', this.element).after(notification) : $('div.jGrowl-notification:first', this.element).before(notification);

			/** Notification Actions **/
			$(notification).bind("mouseover.jGrowl", function() {
				$(this).data("jGrowl").pause = true; 
			}).bind("mouseout.jGrowl", function() {
				$(this).data("jGrowl").pause = false;
			}).bind('jGrowl.beforeOpen', function() {
				o.beforeOpen.apply(self.element, [self.element, message, o]);
			}).bind('jGrowl.open', function() {
				o.open.apply(self.element, [self.element, message, o]);
			}).bind('jGrowl.beforeClose', function() {
				o.beforeClose.apply(self.element, [self.element, message, o]);
			}).bind('jGrowl.close', function() {
				o.close.apply(self.element, [self.element, message, o]);
			}).trigger('jGrowl.beforeOpen').animate(o.animateOpen, o.speed, o.easing, function() {
				$(this).data("jGrowl").created = new Date();
			}).trigger('jGrowl.open');
		},

		/** Update the jGrowl Container, removing old jGrowl notifications **/
		update: function() {
			$(this.element).find('div.jGrowl-notification:parent').each(function() {
				if ($(this).data("jGrowl") != undefined && $(this).data("jGrowl").created != undefined && ($(this).data("jGrowl").created.getTime() + $(this).data("jGrowl").life) < (new Date()).getTime() && $(this).data("jGrowl").sticky != true &&
					 ($(this).data("jGrowl").pause == undefined || $(this).data("jGrowl").pause != true)) {
					$(this).children('div.close').trigger('click.jGrowl');
				}
			});
		},

		/** Setup the jGrowl Notification Container **/
		startup: function(e) {
			this.element = $(e).addClass('jGrowl').append('<div class="jGrowl-notification"></div>');
			this.interval = setInterval(function() { jQuery(e).data('jGrowl.instance').update(); }, this.defaults.check);
		},

		/** Shutdown jGrowl, removing it and clearing the interval **/
		shutdown: function() {
			$(this.element).removeClass('jGrowl').find('div.jGrowl-notification').remove();
			clearInterval(this.interval);
		}
	});

	/** Reference the Defaults Object for compatibility with older versions of jGrowl **/
	$.jGrowl.defaults = $.fn.jGrowl.prototype.defaults;

})(jQuery);
//	Author:
//	Ben Nadel / Kinky Solutions
//	http://www.bennadel.com/index.cfm?dax=blog:1591.view
jQuery.fn.print = function () {
	if (this.size() > 1) {
		this.eq(0).print();
		return;
	} else if (!this.size()) {
		return;
	}
	var strFrameName = ("printer-" + (new Date()).getTime());
	var jFrame = $("<iframe name='" + strFrameName + "'>");
	jFrame
		.css("width", "1px")
		.css("height", "1px")
		.css("position", "absolute")
		.css("left", "-9999px")
		.appendTo($("body:first"))
	;
	var objFrame = window.frames[strFrameName];
	var objDoc = objFrame.document;
	var jStyleDiv = $("<div>").append(
		$("style").clone()
		);
	objDoc.open();
	objDoc.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">");
	objDoc.write("<html>");
	objDoc.write("<body>");
	objDoc.write("<head>");
	objDoc.write("<title>");
	objDoc.write(document.title);
	objDoc.write("</title>");
	objDoc.write(jStyleDiv.html());
	objDoc.write("</head>");
	objDoc.write(this.html());
	objDoc.write("</body>");
	objDoc.write("</html>");
	objDoc.close();
	objFrame.focus();
	objFrame.print();
	jFrame.remove();
};
(function ($)
{
    $.fn.checked = function (checked)
    {
        this.each(function ()
        {
            if (this.nodeName.toLowerCase() == 'input' && this.getAttribute('type') == 'checkbox')
            {
                this.checked = checked;
            }
        });
    }

    $.fn.isChecked = function ()
    {
        var checked = false;
        this.each(function ()
        {
            if (this.nodeName.toLowerCase() == 'input' && this.getAttribute('type') == 'checkbox' && this.checked)
            {
                checked = true;
                return;
            }
        });
        return checked;
    }
})(jQuery);
var SConfirm = {
    SurroundingDiv: "<div id='SConfirm_Surrounding' class='GroupBoxContainer'></div>",
    OverlayDiv: "<div id=\"SConfirm_Overlay\" class='GroupBoxOverlay' style='z-index: 900000000'></div>",
    BoxDiv: "<div id='SConfirm_Box' class='GroupBoxBox' style='margin-left: -250px; width: 500px; z-index: 900000001'></div>",

    HeaderDiv: "<div class='GroupBoxHeader bg-warning'>Are you sure?</div>",

    MessageDiv: "<div id='SConfirm_Message' class='GroupBoxData'></div>",
    MessageSpan: "<span id='SConfirm_Msg' style='font-size: 12pt'></span>",
    ButtonDiv: "<div id='SConfirm_Buttons' style='margin-top: 12px'></div>",
    ButtonYesDiv: "<button type='button' id='SConfirm_OkButton' class='btn btn-success' onclick='SConfirm.SetConfirm()'><span class='glyphicon glyphicon-ok'></span>&nbsp;Yes</button>",
    ButtonNoDiv: "<button type='button' id='SConfirm_NoButton' class='btn btn-danger btnEscape' onclick='SConfirm.Cancel()'><span class='glyphicon glyphicon-remove'></span>&nbsp;No</button>",
    Done: false,
    Confirmed: false,
    ConfirmInterval: 0,
    CheckIntervalLength: 100,
    PostBackTarget: '',
    SecondPass: false,
    Postback: null,

    Confirm: function (target, msg, noAdjustForScroll) {

        var check = 0;

        var grid = null;
        var current = $(target);

        //  This recursively works up the parent chain and finds grid tables below the current element.
        do {
            grid = current.nextAll().find('table.s-gridview');
            current = current.parent();
        } while (grid.length === 0 && current.length > 0);

        if (grid.length > 0) {
            check = $(grid[0]).find('input:checked').length;    //  Only check the first grid right after the search bar because there could be other grids.
        } else {
            check = 1; // Don't want to postback if this failed to find a grid otherwise it skips the confirmation message.
        }

        if (check === 0) {
            return true;
        } else {


            if (SConfirm.SecondPass) {
                return SConfirm.Confirmed;
            }
            $("body").prepend(SConfirm.SurroundingDiv);
            $('#SConfirm_Surrounding').append(SConfirm.OverlayDiv);
            $('#SConfirm_Surrounding').append(SConfirm.BoxDiv);
            if (noAdjustForScroll != null && noAdjustForScroll == true) {
                var boxData = $('#SConfirm_Box');
                boxData.css('top', parseInt(boxData.css('top'), 10) + $(document).scrollTop());
            }
            $('#SConfirm_Box').append(SConfirm.HeaderDiv).append(SConfirm.MessageDiv);

            $('#SConfirm_Message').append(SConfirm.MessageSpan);
            $('#SConfirm_Message').append(SConfirm.ButtonDiv);
            $('#SConfirm_Buttons').append(SConfirm.ButtonYesDiv);
            $('#SConfirm_Buttons').append("&nbsp;&nbsp;");
            $('#SConfirm_Buttons').append(SConfirm.ButtonNoDiv);
            $('#SConfirm_Msg').html(msg);
            SConfirm.ConfirmInterval = setInterval(function() {
                SConfirm.CheckIfDone();
            }, SConfirm.CheckIntervalLength);
            SConfirm.PostBackTarget = target;
            $("#SConfirm_OkButton").focus();
            SConfirm.Position();
            return false;
        }
    },
    Position:function()
    {
        var box = $('#SConfirm_Box');
        box.css('top', parseInt(box.css('top'), 10) + $(document).scrollTop());

    },
    ConfirmDoPostback: function (target, msg, postback)
    {
        SConfirm.Postback = postback;
        SConfirm.Confirm(target, msg);
    },
    SetConfirm: function()
    {
        SConfirm.Done = true;
        SConfirm.Confirmed = true;
    },
    Cancel: function()
    {
        SConfirm.Done = true;
        SConfirm.Confirmed = false;
    },
    CheckIfDone: function()
    {
        if (SConfirm.Done)
        {
            clearInterval(SConfirm.ConfirmInterval);
            SConfirm.Unload();
        }
    },
    Unload: function()
    {
        if (SConfirm.Confirmed)
        {
            SConfirm.SecondPass = true;
            if (SConfirm.Postback !== null)
            {
                SConfirm.Postback();
            }
            else
            {
                $(SConfirm.PostBackTarget).click();
            }
            SConfirm.SecondPass = false;
        }
        SConfirm.Done = false;
        SConfirm.Confirmed = false;
        SConfirm.SecondPass = false;
        $('#SConfirm_Surrounding').remove();
        return false;
    }
};
var Wait = {
	TimeBeforeShow: 200, //minimum time in ms that must elapse before the wait is shown
	BodyWidth: 400,
	BodyHeight: 90,
	ShowTimeout: null,
	Show: function (now) {
		if (now == null) {
			now = false;
		}
		var $body = $('div.wait div.body');
		var $wait = $('div.wait');
		var $overlay = $('div.wait div.overlay');
		var winWidth = $(window).width();
		var winHeight = $(window).height();
		var docWidth = $(document).width();
		var docHeight = $(document).height();
		var bodyTop = ((winHeight / 2) - (Wait.BodyHeight / 2) + $(document).scrollTop()) + 'px';
		var bodyLeft = ((winWidth / 2) - (Wait.BodyWidth / 2) + $(document).scrollLeft()) + 'px';

		$overlay.css('height', docHeight).css('width', winWidth);
		$body.css('left', bodyLeft).css('top', bodyTop);
		if (now) {
			Wait.__ShowNow();
			Wait.ShowTimeout = null;
		}
		else {
			Wait.ShowTimeout = setTimeout(function () { Wait.__ShowNow(); }, Wait.TimeBeforeShow);
		}
	},
	__ShowNow: function () {
		$('div.wait').show();
	},
	Hide: function () {
		if (Wait.ShowTimeout != null) {
			clearTimeout(Wait.ShowTimeout);
		}
		$('.wait').hide();
	},
	AddToGrid: function (gridview) {
		$("#" + gridview + " a").each(function () { $(this).attr("href", $(this).attr("href").replace("javascript:", "javascript:Wait.Show();")); });
	}
};
//Usage:
//1. add a tip on the element with the tooltip content:
//   simple tooltip format: tip="Hello World"
//   ajax tooltip format:  tip="Tip?t=<ToolTipTypes item as int>&<args specified in ToolTip.axd>"
//   e.g.:      tip="Tip?t=0&taskid=42"
var SToolTip = {
	Cache: {},
	CacheAjaxRequests: true,
	CurrentTip: '',
	ContentId: '#SToolTip',
	DefaultContent: '<img src="img.axd?img=loading" width="50px" height="50px"/>',
	Initialize: function () {
		if ($('#SToolTip').length === 0) {
			$('body').append('<div id="SToolTip" class="SToolTipContent">' + SToolTip.DefaultContent + '</div>');
		} else {
			SToolTip.SetTip(SToolTip.DefaultContent);
		}
	},
	SetTip: function (content) {
		$(SToolTip.ContentId).html(content);
	},
	GetTip: function (element, tip) {
		if (tip === undefined || tip == '') {
			return;
		}
		//first check if ajax tip
		if (tip.indexOf('Tip?') == -1 && tip.indexOf('tip?') == -1) {
			//not an ajax tooltip
			SToolTip.SetTip(tip);
			return;
		}
		//check if cached
		if (SToolTip.Cache[tip] !== undefined) {
			//Cached
			SToolTip.SetTip(SToolTip.Cache[tip]);
			return;
		}
		//get the ajax tooltip
		var splitResult = tip.split('?');
		if (splitResult.length > 1) {
			SToolTip.CurrentTip = tip;
			$.get('ToolTip.ashx?' + splitResult[1], null, function (data) { SToolTip.ProccessTip(data); });
			return;
		}
	},
	ProccessTip: function (data) {
		if (SToolTip.CacheAjaxRequests) {
			SToolTip.Cache[SToolTip.CurrentTip] = data;
		}
		SToolTip.SetTip(data);
	},
	SetZIndex: function (element) {
		var z = $(element).css('z-index');
		if (z == 'auto') {
			z = 999999999;
		}
		$(SToolTip.ContentId).css('z-index', z + 1);
	},
	TriggerTip: function (event) {
		//construct tip
		SToolTip.Initialize();
		//tip content
		var tip = $(this).attr('tip');
		if (tip === undefined) {
			return;
		}
		//tip content resides in already created div
		var tipContentId = $(this).attr('tipContentId');
		if (tipContentId === undefined) {
			tipContentId = SToolTip.ContentId;
		}

		var customPos = $(this).attr('tipPosition');
		//valid positions:
		//top center
		//top right
		//center right
		//bottom right
		//bottom center
		//bottom left
		//center left
		//top left
		//mouse
		if (customPos === undefined) {
			customPos = 'center right';
		} else if (customPos == 'mouse') {
			customPos = 'mouse mouse';
		}
		var beforeShowCallback = eval($(this).attr('onBeforeShow'));
		var onShowCallback = eval($(this).attr('onShow'));
		SToolTip.GetTip(this, tip);
		SToolTip.SetZIndex(this);
		var api = $(this).tooltip({
			position: customPos,
			opacity: 1,
			tip: tipContentId,
			effect: 'toggle',
			api: true,
			delay: 0
		});
		if (typeof (beforeShowCallback) !== 'undefined') {
			beforeShowCallback(api, event);
		}
		api.show(event);
		if (typeof (onShowCallback) !== 'undefined') {
			onShowCallback(api, event);
		}
		$(this).mouseout(function () {
			$('#SToolTip').hide();
		});
	}
};

//setup event delegation
$(document).ready(function () {
    $(document).on('mouseover', '[tip]', SToolTip.TriggerTip);
});
// ZUMIIIPAAAAAGE!!! *fist shake* 
// This is required because IE9 does not define a document clear function. This keeps ZumiPage from blowing up.
if (typeof window.document.clear === "undefined") {
    window.document.clear = function () { };
}

var Misc =
{
    CKEditor_TextEncode: function(text) {
        return text.replace(/</g,'&lt;').replace(/>/g,'&gt;');
    },

    ShowRefresh: true,
	RefreshMessageInterval: 1200000,    //20mins
	// Allows text to be inserted where the cursor is or where something is highlighted
	InsertText: function (ctl, myValue) {
		var c = $Get(ctl);
        if (c.selectionStart || c.selectionStart === 0) {
			var startPos = c.selectionStart;
			var endPos = c.selectionEnd;
			c.value = c.value.substring(0, startPos) + myValue + c.value.substring(endPos, c.value.length);
			c.focus();
		} else {
			c.value += myValue;
			c.focus();
		}
	},
	WrapIFrame: function (div, iframeClass) {
		
	},
	SetEnterScript: function (box, script) {
	    alert(box);
		Misc.KeyToScript(box, 13, script);
	},
	SetEnterButton: function (box, btn) {
		Misc.KeyToBtn(box, 13, btn);
	},
	AllowNewline: function (box) {
	    $('#' + box).focus(function () {
	        NewlineState.EnableEnter();
	    }).blur(function () {
	        NewlineState.DisableEnter();
	    });
	},
	KeyToBtn: function (box, key, btn) {
	    var b = $('#' + box);

	    if (b.is(':visible')) {
	        b.on('keypress', function(e) {
	            if (e.keyCode === key) {
	                $('#' + btn).click();
	            }
	        });
	    }
	},
	KeyToScript: function (box, key, script) {
	    $('#' + box).on('keypress', function (e) {
	        if (e.keyCode === key) {
	            eval(script);
	        }
	    });
	},
	UseParent: function () {
	    var useParent = false;

	    try {

	        if ((parent.document.URL).indexOf("TrainingCenter") != -1) {
	            return false;
	        }

			useParent = parent !== null && parent.document.domain === document.domain && frameElement !== null;
		}
		catch (e) {
			useParent = false;
		}
		return useParent;
	},
	StartRefreshMessage: function () {
		// Create a timer that displays every 20 minutes only inside the topmost window
		try {
			if (ShowRefresh && frameElement === null) {
				setInterval(function () { Misc.SendRefreshMethod(); }, Misc.RefreshMessageInterval);
			}
		} catch (e) {

		}
	},
	SendRefreshMethod: function () {
		if (location.href.indexOf('EmployeePortal') === -1) {
			Message.Show({ Type: MessageType.Info, Message: Constants.SLOWING_DOWN });
		}
	},
	Logout: function (url) {
		if (Misc.UseParent()) {
			parent.Misc.Logout(url);
			return;
		}
		location.href = url ? url : GetRoot() + '/Logout.aspx';
	},
	//url is an absolute url e.g. /Platform/Home.aspx
	GoTo: function (url) {
		if (Misc.UseParent()) {
			parent.Misc.GoTo(url);
			return;
		}
		location.href = url;
	},
	GetRoot: function () {
		var subFolder = '';
		if (location.href.indexOf('/Dev/') > -1) {
			subFolder = '/Dev/';
		}
		else if (location.href.indexOf('/Live/') > -1) {
		    subFolder = '/Live/';
		}
		return location.protocol + '//' + location.host + subFolder;
	},
	GetQueryParameters: function () {
		var qsParm = [];
		var query = window.location.search.substring(1);
		var parms = query.split('&');
		for (var i = 0; i < parms.length; i++) {
			var pos = parms[i].indexOf('=');
			if (pos > 0) {
				var key = parms[i].substring(0, pos);
				var val = parms[i].substring(pos + 1);
				qsParm[key] = val;
			}
		}
		return qsParm;
	},
    //  Will disable the enter key unless permitted by NewlineState
	DisableEnterKey: function () {
	    $('html').bind('keypress', function (e)
	    {
	        if (e.keyCode === 13) {

                if (e.target.type === "textarea" || e.target.className.indexOf("cke_source") >= 0)//Needed this here because of ckeditor textarea's dynamic nature
                {
                    return true;
                }

	            if (typeof NewlineState == 'undefined') {
	                return false;
	            }
	            return NewlineState.AllowEnter;
	        }
	    });
	},
    //  Will disable the tab key 
	DisableTabKey: function () {
	    $('html').bind('keypress', function (e){

	        if (e.keyCode == 9) {
	            return false;
	        }
	    });
	},

    //  Will disable the ESC key
	ModifyEscKey: function () {
	    $(document).unbind('keydown').keydown( function(e) {
// ReSharper disable once CoercedEqualsUsing
	        if (e.keyCode == 27) {
	            return false;
	        }
	    });
    },
	InitializePage: function () {
//		$(document).keydown(function (event) {
//			//disable backspace
//			var t = $(document.activeElement).attr('type');
//			var name = $(document.activeElement)[0].tagName;
//			if (event.keyCode == 8 && t != 'text' && t != 'password' && name != 'TEXTAREA') {
//				return false;
//			}
//		});
	}
};

//  For tracking whether newlines should be allowed
var NewlineState = {
    AllowEnter: false,
    EnableEnter: function () { this.AllowEnter = true; },
    DisableEnter: function () { this.AllowEnter = false; },
    Toggle: function () { this.AllowEnter = !this.AllowEnter; }
};

$(document).ready(function () {
	Misc.InitializePage();
});
var Constants = {
	SLOWING_DOWN: 'Are things slowing down? <a href="javascript:ExecuteRefreshMethod()">Click here to Refresh</a> after you have saved any changes.'
};
// Domain Public by Eric Wendelin http://eriwen.com/ (2008)
//                  Luke Smith http://lucassmith.name/ (2008)
//                  Loic Dachary <loic@dachary.org> (2008)
//                  Johan Euphrosine <proppy@aminche.com> (2008)
//                  Øyvind Sean Kinsey http://kinsey.no/blog (2010)
//                  Victor Homyakov (2010)
//
// Information and discussions
// http://jspoker.pokersource.info/skin/test-printstacktrace.html
// http://eriwen.com/javascript/js-stack-trace/
// http://eriwen.com/javascript/stacktrace-update/
// http://pastie.org/253058
//
// guessFunctionNameFromLines comes from firebug
//
// Software License Agreement (BSD License)
//
// Copyright (c) 2007, Parakey Inc.
// All rights reserved.
//
// Redistribution and use of this software in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above
//   copyright notice, this list of conditions and the
//   following disclaimer.
//
// * Redistributions in binary form must reproduce the above
//   copyright notice, this list of conditions and the
//   following disclaimer in the documentation and/or other
//   materials provided with the distribution.
//
// * Neither the name of Parakey Inc. nor the names of its
//   contributors may be used to endorse or promote products
//   derived from this software without specific prior
//   written permission of Parakey Inc.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
// IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/**
* Main function giving a function stack trace with a forced or passed in Error 
*
* @cfg {Error} e The error to create a stacktrace from (optional)
* @cfg {Boolean} guess If we should try to resolve the names of anonymous functions
* @return {Array} of Strings with functions, lines, files, and arguments where possible 
*/
function printStackTrace(options) {
	var ex = (options && options.e) ? options.e : null;
	var guess = options ? !!options.guess : true;

	var p = new printStackTrace.implementation();
	var result = p.run(ex);
	return (guess) ? p.guessFunctions(result) : result;
}

printStackTrace.implementation = function () { };

printStackTrace.implementation.prototype = {
	run: function (ex) {
		ex = ex ||
            (function () {
            	try {
            		var _err = __undef__ << 1;
            	} catch (e) {
            		return e;
            	}
            })();
		// Use either the stored mode, or resolve it
		var mode = this._mode || this.mode(ex);
		if (mode === 'other') {
			return this.other(arguments.callee);
		} else {
			return this[mode](ex);
		}
	},

	/**
	* @return {String} mode of operation for the environment in question.
	*/
	mode: function (e) {
		if (e['arguments']) {
			return (this._mode = 'chrome');
		} else if (window.opera && e.stacktrace) {
			return (this._mode = 'opera10');
		} else if (e.stack) {
			return (this._mode = 'firefox');
		} else if (window.opera && !('stacktrace' in e)) { //Opera 9-
			return (this._mode = 'opera');
		}
		return (this._mode = 'other');
	},

	/**
	* Given a context, function name, and callback function, overwrite it so that it calls
	* printStackTrace() first with a callback and then runs the rest of the body.
	* 
	* @param {Object} context of execution (e.g. window)
	* @param {String} functionName to instrument
	* @param {Function} function to call with a stack trace on invocation
	*/
	instrumentFunction: function (context, functionName, callback) {
		context = context || window;
		context['_old' + functionName] = context[functionName];
		context[functionName] = function () {
			callback.call(this, printStackTrace());
			return context['_old' + functionName].apply(this, arguments);
		};
		context[functionName]._instrumented = true;
	},

	/**
	* Given a context and function name of a function that has been
	* instrumented, revert the function to it's original (non-instrumented)
	* state.
	*
	* @param {Object} context of execution (e.g. window)
	* @param {String} functionName to de-instrument
	*/
	deinstrumentFunction: function (context, functionName) {
		if (context[functionName].constructor === Function &&
                context[functionName]._instrumented &&
                context['_old' + functionName].constructor === Function) {
			context[functionName] = context['_old' + functionName];
		}
	},

	/**
	* Given an Error object, return a formatted Array based on Chrome's stack string.
	* 
	* @param e - Error object to inspect
	* @return Array<String> of function calls, files and line numbers
	*/
	chrome: function (e) {
		return e.stack.replace(/^[^\(]+?[\n$]/gm, '').replace(/^\s+at\s+/gm, '').replace(/^Object.<anonymous>\s*\(/gm, '{anonymous}()@').split('\n');
	},

	/**
	* Given an Error object, return a formatted Array based on Firefox's stack string.
	* 
	* @param e - Error object to inspect
	* @return Array<String> of function calls, files and line numbers
	*/
	firefox: function (e) {
		return e.stack.replace(/(?:\n@:0)?\s+$/m, '').replace(/^\(/gm, '{anonymous}(').split('\n');
	},

	/**
	* Given an Error object, return a formatted Array based on Opera 10's stacktrace string.
	* 
	* @param e - Error object to inspect
	* @return Array<String> of function calls, files and line numbers
	*/
	opera10: function (e) {
		var stack = e.stacktrace;
		var lines = stack.split('\n'), ANON = '{anonymous}',
            lineRE = /.*line (\d+), column (\d+) in ((<anonymous function\:?\s*(\S+))|([^\(]+)\([^\)]*\))(?: in )?(.*)\s*$/i, i, j, len;
		for (i = 2, j = 0, len = lines.length; i < len - 2; i++) {
			if (lineRE.test(lines[i])) {
				var location = RegExp.$6 + ':' + RegExp.$1 + ':' + RegExp.$2;
				var fnName = RegExp.$3;
				fnName = fnName.replace(/<anonymous function\:?\s?(\S+)?>/g, ANON);
				lines[j++] = fnName + '@' + location;
			}
		}

		lines.splice(j, lines.length - j);
		return lines;
	},

	// Opera 7.x-9.x only!
	opera: function (e) {
		var lines = e.message.split('\n'), ANON = '{anonymous}',
            lineRE = /Line\s+(\d+).*script\s+(http\S+)(?:.*in\s+function\s+(\S+))?/i,
            i, j, len;

		for (i = 4, j = 0, len = lines.length; i < len; i += 2) {
			//TODO: RegExp.exec() would probably be cleaner here
			if (lineRE.test(lines[i])) {
				lines[j++] = (RegExp.$3 ? RegExp.$3 + '()@' + RegExp.$2 + RegExp.$1 : ANON + '()@' + RegExp.$2 + ':' + RegExp.$1) + ' -- ' + lines[i + 1].replace(/^\s+/, '');
			}
		}

		lines.splice(j, lines.length - j);
		return lines;
	},

	// Safari, IE, and others
	other: function (curr) {
		var ANON = '{anonymous}', fnRE = /function\s*([\w\-$]+)?\s*\(/i,
            stack = [], fn, args, maxStackSize = 10;

		while (curr && stack.length < maxStackSize) {
			fn = fnRE.test(curr.toString()) ? RegExp.$1 || ANON : ANON;
			args = Array.prototype.slice.call(curr['arguments']);
			stack[stack.length] = fn + '(' + this.stringifyArguments(args) + ')';
			curr = curr.caller;
		}
		return stack;
	},

	/**
	* Given arguments array as a String, subsituting type names for non-string types.
	*
	* @param {Arguments} object
	* @return {Array} of Strings with stringified arguments
	*/
	stringifyArguments: function (args) {
		for (var i = 0; i < args.length; ++i) {
			var arg = args[i];
			if (arg === undefined) {
				args[i] = 'undefined';
			} else if (arg === null) {
				args[i] = 'null';
			} else if (arg.constructor) {
				if (arg.constructor === Array) {
					if (arg.length < 3) {
						args[i] = '[' + this.stringifyArguments(arg) + ']';
					} else {
						args[i] = '[' + this.stringifyArguments(Array.prototype.slice.call(arg, 0, 1)) + '...' + this.stringifyArguments(Array.prototype.slice.call(arg, -1)) + ']';
					}
				} else if (arg.constructor === Object) {
					args[i] = '#object';
				} else if (arg.constructor === Function) {
					args[i] = '#function';
				} else if (arg.constructor === String) {
					args[i] = '"' + arg + '"';
				}
			}
		}
		return args.join(',');
	},

	sourceCache: {},

	/**
	* @return the text from a given URL.
	*/
	ajax: function (url) {
		var req = this.createXMLHTTPObject();
		if (!req) {
			return;
		}
		req.open('GET', url, false);
		req.setRequestHeader('User-Agent', 'XMLHTTP/1.0');
		req.send('');
		return req.responseText;
	},

	/**
	* Try XHR methods in order and store XHR factory.
	*
	* @return <Function> XHR function or equivalent
	*/
	createXMLHTTPObject: function () {
		var xmlhttp, XMLHttpFactories = [
            function () {
            	return new XMLHttpRequest();
            }, function () {
            	return new ActiveXObject('Msxml2.XMLHTTP');
            }, function () {
            	return new ActiveXObject('Msxml3.XMLHTTP');
            }, function () {
            	return new ActiveXObject('Microsoft.XMLHTTP');
            }
        ];
		for (var i = 0; i < XMLHttpFactories.length; i++) {
			try {
				xmlhttp = XMLHttpFactories[i]();
				// Use memoization to cache the factory
				this.createXMLHTTPObject = XMLHttpFactories[i];
				return xmlhttp;
			} catch (e) { }
		}
	},

	/**
	* Given a URL, check if it is in the same domain (so we can get the source
	* via Ajax).
	*
	* @param url <String> source url
	* @return False if we need a cross-domain request
	*/
	isSameDomain: function (url) {
		return url.indexOf(location.hostname) !== -1;
	},

	/**
	* Get source code from given URL if in the same domain.
	*
	* @param url <String> JS source URL
	* @return <Array> Array of source code lines
	*/
	getSource: function (url) {
		if (!(url in this.sourceCache)) {
			this.sourceCache[url] = this.ajax(url).split('\n');
		}
		return this.sourceCache[url];
	},

	guessFunctions: function (stack) {
		for (var i = 0; i < stack.length; ++i) {
			var reStack = /\{anonymous\}\(.*\)@(\w+:\/\/([\-\w\.]+)+(:\d+)?[^:]+):(\d+):?(\d+)?/;
			var frame = stack[i], m = reStack.exec(frame);
			if (m) {
				var file = m[1], lineno = m[4]; //m[7] is character position in Chrome
				if (file && this.isSameDomain(file) && lineno) {
					var functionName = this.guessFunctionName(file, lineno);
					stack[i] = frame.replace('{anonymous}', functionName);
				}
			}
		}
		return stack;
	},

	guessFunctionName: function (url, lineNo) {
		try {
			return this.guessFunctionNameFromLines(lineNo, this.getSource(url));
		} catch (e) {
			return 'getSource failed with url: ' + url + ', exception: ' + e.toString();
		}
	},

	guessFunctionNameFromLines: function (lineNo, source) {
		var reFunctionArgNames = /function ([^(]*)\(([^)]*)\)/;
		var reGuessFunction = /['"]?([0-9A-Za-z_]+)['"]?\s*[:=]\s*(function|eval|new Function)/;
		// Walk backwards from the first line in the function until we find the line which
		// matches the pattern above, which is the function definition
		var line = "", maxLines = 10;
		for (var i = 0; i < maxLines; ++i) {
			line = source[lineNo - i] + line;
			if (line !== undefined) {
				var m = reGuessFunction.exec(line);
				if (m && m[1]) {
					return m[1];
				} else {
					m = reFunctionArgNames.exec(line);
					if (m && m[1]) {
						return m[1];
					}
				}
			}
		}
		return '(?)';
	}
};/*	SWFObject v2.2 <http://code.google.com/p/swfobject/> 
is released under the MIT License <http://www.opensource.org/licenses/mit-license.php> 
*/
var swfobject = function () { var D = "undefined", r = "object", S = "Shockwave Flash", W = "ShockwaveFlash.ShockwaveFlash", q = "application/x-shockwave-flash", R = "SWFObjectExprInst", x = "onreadystatechange", O = window, j = document, t = navigator, T = false, U = [h], o = [], N = [], I = [], l, Q, E, B, J = false, a = false, n, G, m = true, M = function () { var aa = typeof j.getElementById != D && typeof j.getElementsByTagName != D && typeof j.createElement != D, ah = t.userAgent.toLowerCase(), Y = t.platform.toLowerCase(), ae = Y ? /win/.test(Y) : /win/.test(ah), ac = Y ? /mac/.test(Y) : /mac/.test(ah), af = /webkit/.test(ah) ? parseFloat(ah.replace(/^.*webkit\/(\d+(\.\d+)?).*$/, "$1")) : false, X = ! +"\v1", ag = [0, 0, 0], ab = null; if (typeof t.plugins != D && typeof t.plugins[S] == r) { ab = t.plugins[S].description; if (ab && !(typeof t.mimeTypes != D && t.mimeTypes[q] && !t.mimeTypes[q].enabledPlugin)) { T = true; X = false; ab = ab.replace(/^.*\s+(\S+\s+\S+$)/, "$1"); ag[0] = parseInt(ab.replace(/^(.*)\..*$/, "$1"), 10); ag[1] = parseInt(ab.replace(/^.*\.(.*)\s.*$/, "$1"), 10); ag[2] = /[a-zA-Z]/.test(ab) ? parseInt(ab.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0 } } else { if (typeof O.ActiveXObject != D) { try { var ad = new ActiveXObject(W); if (ad) { ab = ad.GetVariable("$version"); if (ab) { X = true; ab = ab.split(" ")[1].split(","); ag = [parseInt(ab[0], 10), parseInt(ab[1], 10), parseInt(ab[2], 10)] } } } catch (Z) { } } } return { w3: aa, pv: ag, wk: af, ie: X, win: ae, mac: ac} } (), k = function () { if (!M.w3) { return } if ((typeof j.readyState != D && j.readyState == "complete") || (typeof j.readyState == D && (j.getElementsByTagName("body")[0] || j.body))) { f() } if (!J) { if (typeof j.addEventListener != D) { j.addEventListener("DOMContentLoaded", f, false) } if (M.ie && M.win) { j.attachEvent(x, function () { if (j.readyState == "complete") { j.detachEvent(x, arguments.callee); f() } }); if (O == top) { (function () { if (J) { return } try { j.documentElement.doScroll("left") } catch (X) { setTimeout(arguments.callee, 0); return } f() })() } } if (M.wk) { (function () { if (J) { return } if (!/loaded|complete/.test(j.readyState)) { setTimeout(arguments.callee, 0); return } f() })() } s(f) } } (); function f() { if (J) { return } try { var Z = j.getElementsByTagName("body")[0].appendChild(C("span")); Z.parentNode.removeChild(Z) } catch (aa) { return } J = true; var X = U.length; for (var Y = 0; Y < X; Y++) { U[Y]() } } function K(X) { if (J) { X() } else { U[U.length] = X } } function s(Y) { if (typeof O.addEventListener != D) { O.addEventListener("load", Y, false) } else { if (typeof j.addEventListener != D) { j.addEventListener("load", Y, false) } else { if (typeof O.attachEvent != D) { i(O, "onload", Y) } else { if (typeof O.onload == "function") { var X = O.onload; O.onload = function () { X(); Y() } } else { O.onload = Y } } } } } function h() { if (T) { V() } else { H() } } function V() { var X = j.getElementsByTagName("body")[0]; var aa = C(r); aa.setAttribute("type", q); var Z = X.appendChild(aa); if (Z) { var Y = 0; (function () { if (typeof Z.GetVariable != D) { var ab = Z.GetVariable("$version"); if (ab) { ab = ab.split(" ")[1].split(","); M.pv = [parseInt(ab[0], 10), parseInt(ab[1], 10), parseInt(ab[2], 10)] } } else { if (Y < 10) { Y++; setTimeout(arguments.callee, 10); return } } X.removeChild(aa); Z = null; H() })() } else { H() } } function H() { var ag = o.length; if (ag > 0) { for (var af = 0; af < ag; af++) { var Y = o[af].id; var ab = o[af].callbackFn; var aa = { success: false, id: Y }; if (M.pv[0] > 0) { var ae = c(Y); if (ae) { if (F(o[af].swfVersion) && !(M.wk && M.wk < 312)) { w(Y, true); if (ab) { aa.success = true; aa.ref = z(Y); ab(aa) } } else { if (o[af].expressInstall && A()) { var ai = {}; ai.data = o[af].expressInstall; ai.width = ae.getAttribute("width") || "0"; ai.height = ae.getAttribute("height") || "0"; if (ae.getAttribute("class")) { ai.styleclass = ae.getAttribute("class") } if (ae.getAttribute("align")) { ai.align = ae.getAttribute("align") } var ah = {}; var X = ae.getElementsByTagName("param"); var ac = X.length; for (var ad = 0; ad < ac; ad++) { if (X[ad].getAttribute("name").toLowerCase() != "movie") { ah[X[ad].getAttribute("name")] = X[ad].getAttribute("value") } } P(ai, ah, Y, ab) } else { p(ae); if (ab) { ab(aa) } } } } } else { w(Y, true); if (ab) { var Z = z(Y); if (Z && typeof Z.SetVariable != D) { aa.success = true; aa.ref = Z } ab(aa) } } } } } function z(aa) { var X = null; var Y = c(aa); if (Y && Y.nodeName == "OBJECT") { if (typeof Y.SetVariable != D) { X = Y } else { var Z = Y.getElementsByTagName(r)[0]; if (Z) { X = Z } } } return X } function A() { return !a && F("6.0.65") && (M.win || M.mac) && !(M.wk && M.wk < 312) } function P(aa, ab, X, Z) { a = true; E = Z || null; B = { success: false, id: X }; var ae = c(X); if (ae) { if (ae.nodeName == "OBJECT") { l = g(ae); Q = null } else { l = ae; Q = X } aa.id = R; if (typeof aa.width == D || (!/%$/.test(aa.width) && parseInt(aa.width, 10) < 310)) { aa.width = "310" } if (typeof aa.height == D || (!/%$/.test(aa.height) && parseInt(aa.height, 10) < 137)) { aa.height = "137" } j.title = j.title.slice(0, 47) + " - Flash Player Installation"; var ad = M.ie && M.win ? "ActiveX" : "PlugIn", ac = "MMredirectURL=" + O.location.toString().replace(/&/g, "%26") + "&MMplayerType=" + ad + "&MMdoctitle=" + j.title; if (typeof ab.flashvars != D) { ab.flashvars += "&" + ac } else { ab.flashvars = ac } if (M.ie && M.win && ae.readyState != 4) { var Y = C("div"); X += "SWFObjectNew"; Y.setAttribute("id", X); ae.parentNode.insertBefore(Y, ae); ae.style.display = "none"; (function () { if (ae.readyState == 4) { ae.parentNode.removeChild(ae) } else { setTimeout(arguments.callee, 10) } })() } u(aa, ab, X) } } function p(Y) { if (M.ie && M.win && Y.readyState != 4) { var X = C("div"); Y.parentNode.insertBefore(X, Y); X.parentNode.replaceChild(g(Y), X); Y.style.display = "none"; (function () { if (Y.readyState == 4) { Y.parentNode.removeChild(Y) } else { setTimeout(arguments.callee, 10) } })() } else { Y.parentNode.replaceChild(g(Y), Y) } } function g(ab) { var aa = C("div"); if (M.win && M.ie) { aa.innerHTML = ab.innerHTML } else { var Y = ab.getElementsByTagName(r)[0]; if (Y) { var ad = Y.childNodes; if (ad) { var X = ad.length; for (var Z = 0; Z < X; Z++) { if (!(ad[Z].nodeType == 1 && ad[Z].nodeName == "PARAM") && !(ad[Z].nodeType == 8)) { aa.appendChild(ad[Z].cloneNode(true)) } } } } } return aa } function u(ai, ag, Y) { var X, aa = c(Y); if (M.wk && M.wk < 312) { return X } if (aa) { if (typeof ai.id == D) { ai.id = Y } if (M.ie && M.win) { var ah = ""; for (var ae in ai) { if (ai[ae] != Object.prototype[ae]) { if (ae.toLowerCase() == "data") { ag.movie = ai[ae] } else { if (ae.toLowerCase() == "styleclass") { ah += ' class="' + ai[ae] + '"' } else { if (ae.toLowerCase() != "classid") { ah += " " + ae + '="' + ai[ae] + '"' } } } } } var af = ""; for (var ad in ag) { if (ag[ad] != Object.prototype[ad]) { af += '<param name="' + ad + '" value="' + ag[ad] + '" />' } } aa.outerHTML = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"' + ah + ">" + af + "</object>"; N[N.length] = ai.id; X = c(ai.id) } else { var Z = C(r); Z.setAttribute("type", q); for (var ac in ai) { if (ai[ac] != Object.prototype[ac]) { if (ac.toLowerCase() == "styleclass") { Z.setAttribute("class", ai[ac]) } else { if (ac.toLowerCase() != "classid") { Z.setAttribute(ac, ai[ac]) } } } } for (var ab in ag) { if (ag[ab] != Object.prototype[ab] && ab.toLowerCase() != "movie") { e(Z, ab, ag[ab]) } } aa.parentNode.replaceChild(Z, aa); X = Z } } return X } function e(Z, X, Y) { var aa = C("param"); aa.setAttribute("name", X); aa.setAttribute("value", Y); Z.appendChild(aa) } function y(Y) { var X = c(Y); if (X && X.nodeName == "OBJECT") { if (M.ie && M.win) { X.style.display = "none"; (function () { if (X.readyState == 4) { b(Y) } else { setTimeout(arguments.callee, 10) } })() } else { X.parentNode.removeChild(X) } } } function b(Z) { var Y = c(Z); if (Y) { for (var X in Y) { if (typeof Y[X] == "function") { Y[X] = null } } Y.parentNode.removeChild(Y) } } function c(Z) { var X = null; try { X = j.getElementById(Z) } catch (Y) { } return X } function C(X) { return j.createElement(X) } function i(Z, X, Y) { Z.attachEvent(X, Y); I[I.length] = [Z, X, Y] } function F(Z) { var Y = M.pv, X = Z.split("."); X[0] = parseInt(X[0], 10); X[1] = parseInt(X[1], 10) || 0; X[2] = parseInt(X[2], 10) || 0; return (Y[0] > X[0] || (Y[0] == X[0] && Y[1] > X[1]) || (Y[0] == X[0] && Y[1] == X[1] && Y[2] >= X[2])) ? true : false } function v(ac, Y, ad, ab) { if (M.ie && M.mac) { return } var aa = j.getElementsByTagName("head")[0]; if (!aa) { return } var X = (ad && typeof ad == "string") ? ad : "screen"; if (ab) { n = null; G = null } if (!n || G != X) { var Z = C("style"); Z.setAttribute("type", "text/css"); Z.setAttribute("media", X); n = aa.appendChild(Z); if (M.ie && M.win && typeof j.styleSheets != D && j.styleSheets.length > 0) { n = j.styleSheets[j.styleSheets.length - 1] } G = X } if (M.ie && M.win) { if (n && typeof n.addRule == r) { n.addRule(ac, Y) } } else { if (n && typeof j.createTextNode != D) { n.appendChild(j.createTextNode(ac + " {" + Y + "}")) } } } function w(Z, X) { if (!m) { return } var Y = X ? "visible" : "hidden"; if (J && c(Z)) { c(Z).style.visibility = Y } else { v("#" + Z, "visibility:" + Y) } } function L(Y) { var Z = /[\\\"<>\.;]/; var X = Z.exec(Y) != null; return X && typeof encodeURIComponent != D ? encodeURIComponent(Y) : Y } var d = function () { if (M.ie && M.win) { window.attachEvent("onunload", function () { var ac = I.length; for (var ab = 0; ab < ac; ab++) { I[ab][0].detachEvent(I[ab][1], I[ab][2]) } var Z = N.length; for (var aa = 0; aa < Z; aa++) { y(N[aa]) } for (var Y in M) { M[Y] = null } M = null; for (var X in swfobject) { swfobject[X] = null } swfobject = null }) } } (); return { registerObject: function (ab, X, aa, Z) { if (M.w3 && ab && X) { var Y = {}; Y.id = ab; Y.swfVersion = X; Y.expressInstall = aa; Y.callbackFn = Z; o[o.length] = Y; w(ab, false) } else { if (Z) { Z({ success: false, id: ab }) } } }, getObjectById: function (X) { if (M.w3) { return z(X) } }, embedSWF: function (ab, ah, ae, ag, Y, aa, Z, ad, af, ac) { var X = { success: false, id: ah }; if (M.w3 && !(M.wk && M.wk < 312) && ab && ah && ae && ag && Y) { w(ah, false); K(function () { ae += ""; ag += ""; var aj = {}; if (af && typeof af === r) { for (var al in af) { aj[al] = af[al] } } aj.data = ab; aj.width = ae; aj.height = ag; var am = {}; if (ad && typeof ad === r) { for (var ak in ad) { am[ak] = ad[ak] } } if (Z && typeof Z === r) { for (var ai in Z) { if (typeof am.flashvars != D) { am.flashvars += "&" + ai + "=" + Z[ai] } else { am.flashvars = ai + "=" + Z[ai] } } } if (F(Y)) { var an = u(aj, am, ah); if (aj.id == ah) { w(ah, true) } X.success = true; X.ref = an } else { if (aa && A()) { aj.data = aa; P(aj, am, ah, ac); return } else { w(ah, true) } } if (ac) { ac(X) } }) } else { if (ac) { ac(X) } } }, switchOffAutoHideShow: function () { m = false }, ua: M, getFlashPlayerVersion: function () { return { major: M.pv[0], minor: M.pv[1], release: M.pv[2]} }, hasFlashPlayerVersion: F, createSWF: function (Z, Y, X) { if (M.w3) { return u(Z, Y, X) } else { return undefined } }, showExpressInstall: function (Z, aa, X, Y) { if (M.w3 && A()) { P(Z, aa, X, Y) } }, removeSWF: function (X) { if (M.w3) { y(X) } }, createCSS: function (aa, Z, Y, X) { if (M.w3) { v(aa, Z, Y, X) } }, addDomLoadEvent: K, addLoadEvent: s, getQueryParamValue: function (aa) { var Z = j.location.search || j.location.hash; if (Z) { if (/\?/.test(Z)) { Z = Z.split("?")[1] } if (aa == null) { return L(Z) } var Y = Z.split("&"); for (var X = 0; X < Y.length; X++) { if (Y[X].substring(0, Y[X].indexOf("=")) == aa) { return L(Y[X].substring((Y[X].indexOf("=") + 1))) } } } return "" }, expressInstallCallback: function () { if (a) { var X = c(R); if (X && l) { X.parentNode.replaceChild(l, X); if (Q) { w(Q, true); if (M.ie && M.win) { l.style.display = "block" } } if (E) { E(B) } } a = false } } } } ();