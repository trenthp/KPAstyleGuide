
var Accordion = {
	//ctl the control used to trigger this function
	//toggleType = 0:one content is shown at a time, 1:multiple can be shown at a time
	Toggle: function(ctl, toggleType) {
		var item = $(ctl).closest('.Item');
		if (toggleType === 0) {
			//hide all content except the one clicked by user
			$(ctl).closest('.Accordion').find('.Item').each(function() {
				if ($(this).attr('id') != $(item).attr('id')) {
					Accordion.ToggleItem(this, true);
				}
			});
		}
		Accordion.ToggleItem(item, $(item).find('.Content').is(':visible'));
	},
	ToggleItem: function(item, hiding) {
		var content = $(item).find('.Content');
		var hfVisible = $(item).find('.Header').find('input[type=hidden]');
		var captionBtn = $(item).find('.HeaderCaption');
		var toggleBtn = $(item).find('.ToggleButton');
		var img = $(toggleBtn).attr('src');
		//set height to auto if it isnt specified
		if ($(content).get(0).clientHeight === 0) {
			$(content).css('height', 'auto');
		}
		//hfvisible used to ensure visible state of content after server side update
		hfVisible.val(hiding ? '0' : '1');
		captionBtn.attr('title', hiding ? 'Expand' : 'Collapse');
		toggleBtn.attr('title', hiding ? 'Expand' : 'Collapse');
		toggleBtn.attr('src', hiding ? img.replace("collapse", "expand") : img.replace("expand", "collapse"));
		if (hiding) {
			$(content).slideUp();
		}
		else {
			$(content).slideDown();
		}
	}
}
var Address =
{
    BrowserSpecific: function ()
    {
        //if ($.browser.msie)
        //{
        //    $('#ZipCell').addClass('IE');
        //}
    }
};

$(document).ready(function() {
	Address.BrowserSpecific();
});
(function (controls, $) {

    var arrowUp = "glyphicon glyphicon-chevron-up";
    var arrowDown = "glyphicon glyphicon-chevron-down";

    // ReSharper disable once InconsistentNaming
    function Search(actext, ajax, fromArrow) {
        var list = actext.siblings(".dropdown-menu");
        var norec = actext.siblings(".ac-no-records");
        var autopost = ajax.Post;

        var search = actext.val();

        var url = ajax.Url + "?search=" + (search ? encodeURIComponent(search) : "")
            + "&key=" + ajax.Key + "&arg=" + encodeURIComponent(ajax.Arg);

        var postParams = ajax.PostParameters;

        $.post(url, postParams, function (results)
        {
            var html = "";

            if (results.Items === undefined || results.Items === null || results.Items.length === 0)
            {
                if (fromArrow)
                {
                   if (norec.css('display') === 'none')
                   {
                       list.empty().hide();
                       norec.show();
                   }
                   else
                   {
                       list.empty().hide();
                       norec.hide();
                       actext.siblings(".input-group-addon").find("span").attr("class", arrowDown);
                   }
                }
                else
                {
                    if (actext.val().length > 0)
                    {
                        list.empty().hide();
                        norec.show();
                    }
                    else
                    {
                        list.empty().hide();
                        norec.hide();
                        actext.siblings(".input-group-addon").find("span").attr("class", arrowDown);

                        if (results.Items !== undefined && results.Items !== null) {
                            __doPostBack(actext.parent().attr("name"), "clear");
                        }
                    }
                }

                return;
            }

            for (var index = 0; index < results.Items.length; index++) {
                var item = results.Items[index];

                html += "<li tabindex='-1'>";

                if (ajax.UsedInSPA)
                {
                    html += "<a tabindex='-1' onclick=\"window.autoComplete.onClickSPA($(this), ";
                    html += index + ", '" + ajax.Key + "')\">" + item.Name + "</a></li>";
                }
                else
                {
                   
                    html += "<a tabindex='-1' onclick=\"window.autoComplete.onClick($(this),";
                    html += index + ", " + autopost + ")\">" + item.Name + "</a></li>";
                }

            }

            if (results.More) {
                if (ajax.UsedInSPA)
                {
                    html += "<li class=\"autocomplete-page\"><a onclick=\"window.autoComplete.onPage(event, $(this), true, true,'" + ajax.Key + "')\">Show more</a></li>";
                }
                else
                {
                    html += "<li class=\"autocomplete-page\"><a onclick=\"window.autoComplete.onPage(event, $(this), true, false)\">Show more</a></li>";
                }
            }

            norec.hide();
            list.empty().append(html);
            list.show();

            actext.parent().data({ Items: results.Items, Url: url, List: list, Autopost: autopost, Page: 0, PostParametersStored: postParams });
        });
    }


    controls.init = function (id, ajax)
    {
        // If already bound, unbind the event
        $(document).off("keyup", id + " .form-control");
        $(document).off("dblclick", id + " .form-control");

        $(document).off("click", id + " .input-group-addon");

        $(document).on("keyup", id + " .form-control", $.debounce(250, function () {
            $(this).siblings(".input-group-addon").find("span").attr("class", arrowUp);
            Search($(this), ajax, false);
        }));

        $(document).on("dblclick", id + " .form-control", $.debounce(250, function () {
            var istextBoxDisable = $(this).parent().find('input[type="text"]')[0].disabled;
            if (!istextBoxDisable) {
                $(this).siblings(".input-group-addon").find("span").attr("class", arrowUp);
                Search($(this), ajax, false);
            }
        }));

        $(document).on("click", id + " .input-group-addon", function (event) {

            $(".autocomplete .dropdown-menu").hide();
            $(".autocomplete .dropdown-menu").parent().removeClass("open");

            $(".autocomplete .ac-no-records").hide();

            var loc = $(this);
            var istextBoxDisable = $(this).parent().find('input[type="text"]')[0].disabled;


            if (loc.find("span").attr("class") === arrowUp || istextBoxDisable) {
                loc.find("span").attr("class", arrowDown);
                $('.autocomplete .glyphicon-chevron-up').attr("class", arrowDown);

                event.stopPropagation();
                event.preventDefault();
                return;
            }
            else {
                $('.autocomplete .glyphicon-chevron-up').attr("class", arrowDown);
            }

            loc.find("span").attr("class", arrowUp);
            Search($(this).prev(), ajax, true);

            event.stopPropagation();
            event.preventDefault();

        });

        function clearAutoCompletes() {
            var scan = $(id + " .form-control");
            scan.siblings("ul").hide();
            scan.siblings(".ac-no-records").hide();
            scan.siblings(".input-group-addon").find("span").attr("class", arrowDown);
        };


        $(document).click(function () {
            clearAutoCompletes();
        });

        //$(document).keyup(function (event) {
        //    var $current = $('.dropdown-menu li.active');
        //    var $next;
        //    if (event.keyCode == 38)
        //        $next = $current.prev();
        //    if (event.keyCode == 40)
        //        $next = $current.next();

        //    if ($next.length > 0) {
        //        $('.dropdown-menu li').removeClass('active');
        //        $next.addClass('active');
        //    }
        //});
    }

    controls.onClick = function (list, val, post) {
        var ctrl = list.parent().parent().parent();
        var items = ctrl.data().Items;

        ctrl.children(":hidden").val(items[val].Id);
        ctrl.children(":text").val(items[val].Name);

        list.parent().parent().hide();

        if (post === true) {
            __doPostBack(ctrl.attr("data-name"), items[val].Id);
        }
    }

    controls.onClickSPA = function (list, val, key) {
        var ctrl = list.parent().parent().parent();
        var items = ctrl.data().Items;

        var id = items[val].Id;
        var name = items[val].Name;

        angular.element(list).scope().HandleAutoCompleteClick(key, id, name);

        list.parent().parent().hide();
    }

    controls.onPage = function (event, link, next, usedInSPA, key, insurerLetter) {
        var list = link.parent().parent();
        var ctrl = list.parent();
        var data = ctrl.data();
        var postParams = data.PostParametersStored;

        data.Page = (next ? data.Page + 1 : data.Page - 1);
        event.stopPropagation();

        $.post(data.Url + "&page=" + data.Page, postParams, function (results) {
            var html = "";

            data.Items = data.Items.concat(results.Items);
            for (var index = 0; index < data.Items.length; index++) {
                var item = data.Items[index];
                //if (index == 0) {
                //    html += "<li class=\"active\">";
                //} else {
                    html += "<li>";
                //}

                if (usedInSPA) {
                    html += "<a onclick=\"window.autoComplete.onClickSPA($(this), ";
                    html += index + ", '" + key + "', '" + insurerLetter + "')\">" + item.Name + "</a></li>";
                }
                else {

                    html += "<a onclick=\"window.autoComplete.onClick($(this),";
                    html += index + ", " + data.Autopost + ")\">" + item.Name + "</a></li>";
                }
            }

            if (results.More) {
                if (usedInSPA) {
                    html += "<li class=\"autocomplete-page\"><a onclick=\"window.autoComplete.onPage(event, $(this), true, true,'" + key + "', '" + insurerLetter + "')\">Show more</a></li>";
                }
                else {
                    html += "<li class=\"autocomplete-page\"><a onclick=\"window.autoComplete.onPage(event, $(this), true, false)\">Show more</a></li>";
                }
            }

            list.empty().append(html);
            ctrl.data(data);
        });
    }

}(window.autoComplete = window.autoComplete || {}, jQuery));
var CertificateLines = {
	PlaceCtl: function (index, gvName) {
		var cell = $('#tcLines');
		var parentRow = cell.parent();
		var rows = $('#' + gvName + ' > tbody').children('.MainRow,.AltRow');
		var row = rows.eq(index);
		var btn = row.find('.LineExpander');
		//simple case: do we just want to toggle the row?
		if (parentRow.prev()[0] == row[0]) {
			cell.toggle();
			if (btn.attr('src') == 'img.axd?ico16=expand') {
				btn.attr('src', 'img.axd?ico16=collapse');
			}
			else {
				btn.attr('src', 'img.axd?ico16=expand');
			}
			return;
		}
		else {
			cell.hide();
		}
		//remove the control from the dom
		var ctl = $('#divLinesContainer').detach();
		//remove the old container row
		parentRow.remove();
		//get number of columns
		var cols = row.find('td').length;
		//add new container row
		$('.LineExpander').attr('src', 'img.axd?ico16=expand');
		btn.attr('src', 'img.axd?ico16=collapse');
		row.after('<tr><td id=tcLines colspan=' + cols + '></td></tr>');
		//have to put it in a timecause cause of timing issue with selecting #tcLines right after inserting it?
		setTimeout(function () { $('#tcLines').append(ctl).show(); }, 200);
	},
	Reset: function (button) {
		$(button).parents('td').hide();
		$('.LineExpander').attr('src', 'img.axd?ico16=expand');
	}
};
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
var SCKEditor = {
    Show: function (clientId)
    {
        $(document).ready(function () {
            var element = document.getElementById(clientId);
            if (element) {
                var existingEditor = CKEDITOR.instances[clientId];
                if (existingEditor) {
                    try {
                        existingEditor.destroy();
                    } catch (e) {
                    }
                }

                var editor = CKEDITOR.replace(clientId);

                editor.on("change", function () {
                    editor.updateElement();
                });
            }
        });
    },

    SetContent: function (clientId, content)
    {
        var editor = CKEDITOR.instances[clientId];
        if (editor) {
            try {
                editor.setData(content);
                editor.updateElement();
            } catch (e) { }
        }
    }
};
/* =========================================================
 * bootstrap-datepicker.js 
 * http://www.eyecon.ro/bootstrap-datepicker
 * =========================================================
 * Copyright 2012 Stefan Petre
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */

//  This is for hiding datepickers when escape key is pressed. 
//  Otherwise, they remain visible if activated inside a group box that is dismissed with the escape key.
$(document).keydown(function (e) {
    if (e.keyCode === 27)//Escape key maps to key 27
    {
        $(".datepicker").hide();
    }
});

!function ($) {

    // Picker object

    var Datepicker = function (element, options) {
        this.temp = false;

        this.element = $(element);
        this.format = DPGlobal.parseFormat(options.format || this.element.data('date-format') || 'mm/dd/yyyy');
        $('#dpicker_' + element.id).remove();    //  This is to remove the previously created datepicker element so the DOM doesn't get cluttered
        this.picker = $(DPGlobal.template).attr('id', 'dpicker_' + element.id)  //  Tag the element with and ID so we can track it and remove it later
							.appendTo('body')
							.on({
							    click: $.proxy(this.click, this)//,
							    //mousedown: $.proxy(this.mousedown, this)
							});
        this.isInput = this.element.is('input');
        this.component = this.element.is('.date') ? this.element.find('.input-group-addon') : false;

        if (this.isInput) {
            //this.element.on({
            //    //focus: $.proxy(this.show, this),
            //    //blur: $.proxy(this.blur, this),
            //    //keyup: $.proxy(this.update, this)
            //});

            this.tempCal = this.element.next('.input-group-addon');
            if (this.tempCal != null) {
                this.tempCal.on('click', $.proxy(this.toggle, this));
            }
        }
        else {
        if (this.component) {
                this.component.on('click', $.proxy(this.show, this));
        } else {
                this.element.on('click', $.proxy(this.show, this));
            }
        }

        this.minViewMode = options.minViewMode || this.element.data('date-minviewmode') || 0;
        if (typeof this.minViewMode === 'string') {
            switch (this.minViewMode) {
                case 'months':
                    this.minViewMode = 1;
                    break;
                case 'years':
                    this.minViewMode = 2;
                    break;
                default:
                    this.minViewMode = 0;
                    break;
            }
        }
        this.viewMode = options.viewMode || this.element.data('date-viewmode') || 0;
        if (typeof this.viewMode === 'string') {
            switch (this.viewMode) {
                case 'months':
                    this.viewMode = 1;
                    break;
                case 'years':
                    this.viewMode = 2;
                    break;
                default:
                    this.viewMode = 0;
                    break;
            }
        }
        this.startViewMode = this.viewMode;
        this.weekStart = options.weekStart || this.element.data('date-weekstart') || 0;
        this.weekEnd = this.weekStart === 0 ? 6 : this.weekStart - 1;
        this.onRender = options.onRender;
        this.fillDow();
        this.fillMonths();
        this.update(new Date());
        this.showMode();
    };

    Datepicker.prototype = {
        constructor: Datepicker,

        toggle: function () {
            
            if (this.temp == false) {
                this.show();
                this.temp = true;
            } else {
                this.hide();
                this.temp = false;
            }
        },

        show: function (e) {
            if (this.component) {
                this.height = this.component.outerHeight();
                this.width = this.component.outerWidth();
            } else {
                this.height = this.element.outerHeight();
                this.width = this.element.outerWidth();
            }
            this.picker.show();
            this.place();
            $(window).on('resize', $.proxy(this.place, this));
            if (e) {
                e.stopPropagation();
                e.preventDefault();
            }
            if (!this.isInput) {
            }
            var that = this;
            $(document).on('mousedown', function (ev) {
                if ($(ev.target).closest('.datepicker').length == 0) {
                    that.hide();
                }
            }); 
            this.element.trigger({
                type: 'show',
                date: this.date
            });
        },
        
        hide: function () {
            this.picker.hide();
            $(window).off('resize', this.place);
            this.viewMode = this.startViewMode;
            this.showMode();
            if (!this.isInput) {
                $(document).off('mousedown', this.hide);
            }
            //this.set();
            this.element.trigger({
                type: 'hide',
                date: this.date
            });

            this.temp = false;
        },

        set: function () {
            var formated = DPGlobal.formatDate(this.date, this.format);
            if (!this.isInput) {
                if (this.component) {
                    this.element.find('input').prop('value', formated);
                }
                this.element.data('date', formated);
            } else {
                this.element.prop('value', formated);
            }
        },

        setValue: function (newDate) {
            if (typeof newDate === 'string') {
                this.date = DPGlobal.parseDate(newDate, this.format);
            } else {
                this.date = new Date(newDate);
            }
            this.set();
            this.viewDate = new Date(this.date.getFullYear(), this.date.getMonth(), 1, 0, 0, 0, 0);
            this.fill();
        },

        place: function () {
            var offset = this.component ? this.component.offset() : this.element.offset(),
		        pickerHeight = this.picker.outerHeight(),
		        pickerWidth = this.picker.outerWidth(),
		        screenHeight = $(window).height(),
		        top = offset.top + this.height;

            if (top + pickerHeight > screenHeight) {
                top = offset.top - pickerHeight - 2;

                if (this.picker.hasClass('datepicker-top')) {
                    this.picker.removeClass('datepicker-top').addClass('datepicker-bottom');
                }
            }
            else if (this.picker.hasClass('datepicker-bottom')) {
                this.picker.removeClass('datepicker-bottom').addClass('datepicker-top');
            }

            this.picker.css({
                left: offset.left + this.width - pickerWidth,
                top: top
            });
        },

        update: function (newDate) {
            var date = typeof newDate === 'string' ? newDate : (this.isInput ? this.element.prop('value') : this.element.data('date'));
            this.date = date ? DPGlobal.parseDate(date, this.format) : new Date();
            this.viewDate = new Date(this.date.getFullYear(), this.date.getMonth(), 1, 0, 0, 0, 0);
            this.fill();
        },

        fillDow: function () {
            var dowCnt = this.weekStart;
            var html = '<tr>';
            while (dowCnt < this.weekStart + 7) {
                html += '<th class="dow">' + DPGlobal.dates.daysMin[(dowCnt++) % 7] + '</th>';
            }
            html += '</tr>';
            this.picker.find('.datepicker-days thead').append(html);
        },

        fillMonths: function () {
            var html = '';
            var i = 0
            while (i < 12) {
                html += '<span class="month">' + DPGlobal.dates.monthsShort[i++] + '</span>';
            }
            this.picker.find('.datepicker-months td').append(html);
        },

        fill: function () {
            var d = new Date(this.viewDate),
				year = d.getFullYear(),
				month = d.getMonth(),
				currentDate = this.date.valueOf();
            this.picker.find('.datepicker-days th:eq(1)')
						.text(DPGlobal.dates.months[month] + ' ' + year);
            var prevMonth = new Date(year, month - 1, 28, 0, 0, 0, 0),
				day = DPGlobal.getDaysInMonth(prevMonth.getFullYear(), prevMonth.getMonth());
            prevMonth.setDate(day);
            prevMonth.setDate(day - (prevMonth.getDay() - this.weekStart + 7) % 7);
            var nextMonth = new Date(prevMonth);
            nextMonth.setDate(nextMonth.getDate() + 42);
            nextMonth = nextMonth.valueOf();
            var html = [];
            var clsName,
				prevY,
				prevM;
            while (prevMonth.valueOf() < nextMonth) {
                if (prevMonth.getDay() === this.weekStart) {
                    html.push('<tr>');
                }
                clsName = this.onRender(prevMonth);
                prevY = prevMonth.getFullYear();
                prevM = prevMonth.getMonth();
                if ((prevM < month && prevY === year) || prevY < year) {
                    clsName += ' old';
                } else if ((prevM > month && prevY === year) || prevY > year) {
                    clsName += ' new';
                }
                if (prevMonth.valueOf() === currentDate) {
                    clsName += ' active';
                }
                html.push('<td class="day ' + clsName + '">' + prevMonth.getDate() + '</td>');
                if (prevMonth.getDay() === this.weekEnd) {
                    html.push('</tr>');
                }
                prevMonth.setDate(prevMonth.getDate() + 1);
            }
            this.picker.find('.datepicker-days tbody').empty().append(html.join(''));
            var currentYear = this.date.getFullYear();

            var months = this.picker.find('.datepicker-months')
						.find('th:eq(1)')
							.text(year)
							.end()
						.find('span').removeClass('active');
            if (currentYear === year) {
                months.eq(this.date.getMonth()).addClass('active');
            }

            html = '';
            year = parseInt(year / 10, 10) * 10;
            var yearCont = this.picker.find('.datepicker-years')
								.find('th:eq(1)')
									.text(year + '-' + (year + 9))
									.end()
								.find('td');
            year -= 1;
            for (var i = -1; i < 11; i++) {
                html += '<span class="year' + (i === -1 || i === 10 ? ' old' : '') + (currentYear === year ? ' active' : '') + '">' + year + '</span>';
                year += 1;
            }
            yearCont.html(html);
        },

        click: function (e) {
            e.stopPropagation();
            e.preventDefault();
            var target = $(e.target).closest('span, td, th');
            if (target.length === 1) {
                switch (target[0].nodeName.toLowerCase()) {
                    case 'th':
                        switch (target[0].className) {
                            case 'switch':
                                this.showMode(1);
                                break;
                            case 'prev':
                            case 'next':
                                this.viewDate['set' + DPGlobal.modes[this.viewMode].navFnc].call(
									this.viewDate,
									this.viewDate['get' + DPGlobal.modes[this.viewMode].navFnc].call(this.viewDate) +
									DPGlobal.modes[this.viewMode].navStep * (target[0].className === 'prev' ? -1 : 1)
								);
                                this.fill();
                                break;
                        }
                        break;
                    case 'span':
                        if (target.is('.month')) {
                            var month = target.parent().find('span').index(target);
                            this.viewDate.setMonth(month);
                        } else if (target.is('.year')) {
                            var year = parseInt(target.text(), 10) || 0;
                            this.viewDate.setFullYear(year);
                        }
                        this.showMode(-1);
                        this.fill();
                        break;
                    case 'td':
                        if (target.is('.day') && !target.is('.disabled')) {
                            var day = parseInt(target.text(), 10) || 1;
                            var month = this.viewDate.getMonth();
                            if (target.is('.old')) {
                                month -= 1;
                            } else if (target.is('.new')) {
                                month += 1;
                            }
                            var year = this.viewDate.getFullYear();
                            this.date = new Date(year, month, day, 0, 0, 0, 0);
                            this.viewDate = new Date(year, month, Math.min(28, day), 0, 0, 0, 0);
                            this.fill();
                            this.set();
                            this.element.trigger({
                                type: 'changeDate',
                                date: this.date,
                                viewMode: DPGlobal.modes[this.viewMode].clsName
                            });
                            this.hide();
                        }
                        break;
                }
            }
        },

        mousedown: function (e) {
            e.stopPropagation();
            e.preventDefault();
        },

        showMode: function (dir) {
            if (dir) {
                this.viewMode = Math.max(this.minViewMode, Math.min(2, this.viewMode + dir));
            }
            this.picker.find('>div').hide().filter('.datepicker-' + DPGlobal.modes[this.viewMode].clsName).show();
        }
    };

    $.fn.datepicker = function (option, val) {
        return this.each(function () {
            var $this = $(this),
				data = $this.data('datepicker'),
				options = typeof option === 'object' && option;
            if (!data) {
                $this.data('datepicker', (data = new Datepicker(this, $.extend({}, $.fn.datepicker.defaults, options))));
            }
            if (typeof option === 'string') data[option](val);
        });
    };

    $.fn.datepicker.defaults = {
        onRender: function (date) {
            return '';
        }
    };
    $.fn.datepicker.Constructor = Datepicker;

    var DPGlobal = {
        modes: [
			{
			    clsName: 'days',
			    navFnc: 'Month',
			    navStep: 1
			},
			{
			    clsName: 'months',
			    navFnc: 'FullYear',
			    navStep: 1
			},
			{
			    clsName: 'years',
			    navFnc: 'FullYear',
			    navStep: 10
			}],
        dates: {
            days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
            daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            daysMin: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],
            months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        },
        isLeapYear: function (year) {
            return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0))
        },
        getDaysInMonth: function (year, month) {
            return [31, (DPGlobal.isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month]
        },
        parseFormat: function (format) {
            var separator = format.match(/[.\/\-\s].*?/),
				parts = format.split(/\W+/);
            if (!separator || !parts || parts.length === 0) {
                throw new Error("Invalid date format.");
            }
            return { separator: separator, parts: parts };
        },
        parseDate: function (date, format) {
            var parts = date.split(format.separator),
				date = new Date(),
				val;
            date.setHours(0);
            date.setMinutes(0);
            date.setSeconds(0);
            date.setMilliseconds(0);
            if (parts.length === format.parts.length) {
                var year = date.getFullYear(), day = date.getDate(), month = date.getMonth();
                for (var i = 0, cnt = format.parts.length; i < cnt; i++) {
                    val = parseInt(parts[i], 10) || 1;
                    switch (format.parts[i]) {
                        case 'dd':
                        case 'd':
                            day = val;
                            date.setDate(val);
                            break;
                        case 'mm':
                        case 'm':
                            month = val - 1;
                            date.setMonth(val - 1);
                            break;
                        case 'yy':
                            year = 2000 + val;
                            date.setFullYear(2000 + val);
                            break;
                        case 'yyyy':
                            year = val;
                            date.setFullYear(val);
                            break;
                    }
                }
                date = new Date(year, month, day, 0, 0, 0);
            }
            return date;
        },
        formatDate: function (date, format) {
            var val = {
                d: date.getDate(),
                m: date.getMonth() + 1,
                yy: date.getFullYear().toString().substring(2),
                yyyy: date.getFullYear()
            };
            val.dd = (val.d < 10 ? '0' : '') + val.d;
            val.mm = (val.m < 10 ? '0' : '') + val.m;
            var date = [];
            for (var i = 0, cnt = format.parts.length; i < cnt; i++) {
                date.push(val[format.parts[i]]);
            }
            return date.join(format.separator);
        },
        headTemplate: '<thead>' +
							'<tr>' +
								'<th class="prev">&lsaquo;</th>' +
								'<th colspan="5" class="switch"></th>' +
								'<th class="next">&rsaquo;</th>' +
							'</tr>' +
						'</thead>',
        contTemplate: '<tbody><tr><td colspan="7"></td></tr></tbody>'
    };
    DPGlobal.template = '<div class="datepicker datepicker-top dropdown-menu">' +
							'<div class="datepicker-days">' +
								'<table class=" table-condensed">' +
									DPGlobal.headTemplate +
									'<tbody></tbody>' +
								'</table>' +
							'</div>' +
							'<div class="datepicker-months">' +
								'<table class="table-condensed">' +
									DPGlobal.headTemplate +
									DPGlobal.contTemplate +
								'</table>' +
							'</div>' +
							'<div class="datepicker-years">' +
								'<table class="table-condensed">' +
									DPGlobal.headTemplate +
									DPGlobal.contTemplate +
								'</table>' +
							'</div>' +
						'</div>';

}(window.jQuery);


function ActivateDatePicker(id, allowPast, allowFuture, allowToday, highlightToday) {
    var nowTemp = new Date();
    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
    var nowPlusOne = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate() + 1, 0, 0, 0, 0);

    $(id).datepicker({
        onRender: function (date) {
            var dtCheck = new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0, 0, 0, 0);

            if (!allowPast && dtCheck < now) {
                return "disabled";
            }
            if (!allowFuture && dtCheck > now) {
                return "disabled";
            }
            if (!allowToday && dtCheck >= now && dtCheck < nowPlusOne) {
                return "disabled";
            }
            if (highlightToday && date.valueOf() === now.valueOf()) {
                return "today";
            }
            return "";
        }
    });


}







function AttachPicker(ctl) {
	$(document).ready(function() {
		$(ctl).datepicker({
			changeMonth: true,
			changeYear: true
		});
	});
}
/*!
 * jQuery throttle / debounce - v1.1 - 3/7/2010
 * http://benalman.com/projects/jquery-throttle-debounce-plugin/
 * 
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */

// Script: jQuery throttle / debounce: Sometimes, less is more!
//
// *Version: 1.1, Last updated: 3/7/2010*
// 
// Project Home - http://benalman.com/projects/jquery-throttle-debounce-plugin/
// GitHub       - http://github.com/cowboy/jquery-throttle-debounce/
// Source       - http://github.com/cowboy/jquery-throttle-debounce/raw/master/jquery.ba-throttle-debounce.js
// (Minified)   - http://github.com/cowboy/jquery-throttle-debounce/raw/master/jquery.ba-throttle-debounce.min.js (0.7kb)
// 
// About: License
// 
// Copyright (c) 2010 "Cowboy" Ben Alman,
// Dual licensed under the MIT and GPL licenses.
// http://benalman.com/about/license/
// 
// About: Examples
// 
// These working examples, complete with fully commented code, illustrate a few
// ways in which this plugin can be used.
// 
// Throttle - http://benalman.com/code/projects/jquery-throttle-debounce/examples/throttle/
// Debounce - http://benalman.com/code/projects/jquery-throttle-debounce/examples/debounce/
// 
// About: Support and Testing
// 
// Information about what version or versions of jQuery this plugin has been
// tested with, what browsers it has been tested in, and where the unit tests
// reside (so you can test it yourself).
// 
// jQuery Versions - none, 1.3.2, 1.4.2
// Browsers Tested - Internet Explorer 6-8, Firefox 2-3.6, Safari 3-4, Chrome 4-5, Opera 9.6-10.1.
// Unit Tests      - http://benalman.com/code/projects/jquery-throttle-debounce/unit/
// 
// About: Release History
// 
// 1.1 - (3/7/2010) Fixed a bug in <jQuery.throttle> where trailing callbacks
//       executed later than they should. Reworked a fair amount of internal
//       logic as well.
// 1.0 - (3/6/2010) Initial release as a stand-alone project. Migrated over
//       from jquery-misc repo v0.4 to jquery-throttle repo v1.0, added the
//       no_trailing throttle parameter and debounce functionality.
// 
// Topic: Note for non-jQuery users
// 
// jQuery isn't actually required for this plugin, because nothing internal
// uses any jQuery methods or properties. jQuery is just used as a namespace
// under which these methods can exist.
// 
// Since jQuery isn't actually required for this plugin, if jQuery doesn't exist
// when this plugin is loaded, the method described below will be created in
// the `Cowboy` namespace. Usage will be exactly the same, but instead of
// $.method() or jQuery.method(), you'll need to use Cowboy.method().

(function (window, undefined) {
    '$:nomunge'; // Used by YUI compressor.

    // Since jQuery really isn't required for this plugin, use `jQuery` as the
    // namespace only if it already exists, otherwise use the `Cowboy` namespace,
    // creating it if necessary.
    var $ = window.jQuery || window.Cowboy || (window.Cowboy = {}),

      // Internal method reference.
      jq_throttle;

    // Method: jQuery.throttle
    // 
    // Throttle execution of a function. Especially useful for rate limiting
    // execution of handlers on events like resize and scroll. If you want to
    // rate-limit execution of a function to a single time, see the
    // <jQuery.debounce> method.
    // 
    // In this visualization, | is a throttled-function call and X is the actual
    // callback execution:
    // 
    // > Throttled with `no_trailing` specified as false or unspecified:
    // > ||||||||||||||||||||||||| (pause) |||||||||||||||||||||||||
    // > X    X    X    X    X    X        X    X    X    X    X    X
    // > 
    // > Throttled with `no_trailing` specified as true:
    // > ||||||||||||||||||||||||| (pause) |||||||||||||||||||||||||
    // > X    X    X    X    X             X    X    X    X    X
    // 
    // Usage:
    // 
    // > var throttled = jQuery.throttle( delay, [ no_trailing, ] callback );
    // > 
    // > jQuery('selector').bind( 'someevent', throttled );
    // > jQuery('selector').unbind( 'someevent', throttled );
    // 
    // This also works in jQuery 1.4+:
    // 
    // > jQuery('selector').bind( 'someevent', jQuery.throttle( delay, [ no_trailing, ] callback ) );
    // > jQuery('selector').unbind( 'someevent', callback );
    // 
    // Arguments:
    // 
    //  delay - (Number) A zero-or-greater delay in milliseconds. For event
    //    callbacks, values around 100 or 250 (or even higher) are most useful.
    //  no_trailing - (Boolean) Optional, defaults to false. If no_trailing is
    //    true, callback will only execute every `delay` milliseconds while the
    //    throttled-function is being called. If no_trailing is false or
    //    unspecified, callback will be executed one final time after the last
    //    throttled-function call. (After the throttled-function has not been
    //    called for `delay` milliseconds, the internal counter is reset)
    //  callback - (Function) A function to be executed after delay milliseconds.
    //    The `this` context and all arguments are passed through, as-is, to
    //    `callback` when the throttled-function is executed.
    // 
    // Returns:
    // 
    //  (Function) A new, throttled, function.

    $.throttle = jq_throttle = function (delay, no_trailing, callback, debounce_mode) {
        // After wrapper has stopped being called, this timeout ensures that
        // `callback` is executed at the proper times in `throttle` and `end`
        // debounce modes.
        var timeout_id,

          // Keep track of the last time `callback` was executed.
          last_exec = 0;

        // `no_trailing` defaults to falsy.
        if (typeof no_trailing !== 'boolean') {
            debounce_mode = callback;
            callback = no_trailing;
            no_trailing = undefined;
        }

        // The `wrapper` function encapsulates all of the throttling / debouncing
        // functionality and when executed will limit the rate at which `callback`
        // is executed.
        function wrapper() {
            var that = this,
              elapsed = +new Date() - last_exec,
              args = arguments;

            // Execute `callback` and update the `last_exec` timestamp.
            function exec() {
                last_exec = +new Date();
                callback.apply(that, args);
            };

            // If `debounce_mode` is true (at_begin) this is used to clear the flag
            // to allow future `callback` executions.
            function clear() {
                timeout_id = undefined;
            };

            if (debounce_mode && !timeout_id) {
                // Since `wrapper` is being called for the first time and
                // `debounce_mode` is true (at_begin), execute `callback`.
                exec();
            }

            // Clear any existing timeout.
            timeout_id && clearTimeout(timeout_id);

            if (debounce_mode === undefined && elapsed > delay) {
                // In throttle mode, if `delay` time has been exceeded, execute
                // `callback`.
                exec();

            } else if (no_trailing !== true) {
                // In trailing throttle mode, since `delay` time has not been
                // exceeded, schedule `callback` to execute `delay` ms after most
                // recent execution.
                // 
                // If `debounce_mode` is true (at_begin), schedule `clear` to execute
                // after `delay` ms.
                // 
                // If `debounce_mode` is false (at end), schedule `callback` to
                // execute after `delay` ms.
                timeout_id = setTimeout(debounce_mode ? clear : exec, debounce_mode === undefined ? delay - elapsed : delay);
            }
        };

        // Set the guid of `wrapper` function to the same of original callback, so
        // it can be removed in jQuery 1.4+ .unbind or .die by using the original
        // callback as a reference.
        if ($.guid) {
            wrapper.guid = callback.guid = callback.guid || $.guid++;
        }

        // Return the wrapper function.
        return wrapper;
    };

    // Method: jQuery.debounce
    // 
    // Debounce execution of a function. Debouncing, unlike throttling,
    // guarantees that a function is only executed a single time, either at the
    // very beginning of a series of calls, or at the very end. If you want to
    // simply rate-limit execution of a function, see the <jQuery.throttle>
    // method.
    // 
    // In this visualization, | is a debounced-function call and X is the actual
    // callback execution:
    // 
    // > Debounced with `at_begin` specified as false or unspecified:
    // > ||||||||||||||||||||||||| (pause) |||||||||||||||||||||||||
    // >                          X                                 X
    // > 
    // > Debounced with `at_begin` specified as true:
    // > ||||||||||||||||||||||||| (pause) |||||||||||||||||||||||||
    // > X                                 X
    // 
    // Usage:
    // 
    // > var debounced = jQuery.debounce( delay, [ at_begin, ] callback );
    // > 
    // > jQuery('selector').bind( 'someevent', debounced );
    // > jQuery('selector').unbind( 'someevent', debounced );
    // 
    // This also works in jQuery 1.4+:
    // 
    // > jQuery('selector').bind( 'someevent', jQuery.debounce( delay, [ at_begin, ] callback ) );
    // > jQuery('selector').unbind( 'someevent', callback );
    // 
    // Arguments:
    // 
    //  delay - (Number) A zero-or-greater delay in milliseconds. For event
    //    callbacks, values around 100 or 250 (or even higher) are most useful.
    //  at_begin - (Boolean) Optional, defaults to false. If at_begin is false or
    //    unspecified, callback will only be executed `delay` milliseconds after
    //    the last debounced-function call. If at_begin is true, callback will be
    //    executed only at the first debounced-function call. (After the
    //    throttled-function has not been called for `delay` milliseconds, the
    //    internal counter is reset)
    //  callback - (Function) A function to be executed after delay milliseconds.
    //    The `this` context and all arguments are passed through, as-is, to
    //    `callback` when the debounced-function is executed.
    // 
    // Returns:
    // 
    //  (Function) A new, debounced, function.

    $.debounce = function (delay, at_begin, callback) {
        return callback === undefined
          ? jq_throttle(delay, at_begin, false)
          : jq_throttle(delay, callback, at_begin !== false);
    };

})(this);


(function ($) {
    var m_uploadGroups = {};
    var m_uploadCtrls = {};

    function getUpload(ctrl) {
        var upload = m_uploadCtrls[ctrl.attr("id")];
        if (upload) {
            return upload;
        }

        return {
            fid: null,
            file: false,
            uploadForm: null,
            uploadCtrl: null,
            group: null,
            submit: null,
            reset: null
        };
    }

    function setUpload(ctrl, upload) {
        m_uploadCtrls[ctrl.attr("id")] = upload;
    }

    function submitFiles(ctrl, upload) {
        $(ctrl).children(".progress").show();
        $(ctrl).find(".info").text("Uploading " + $(ctrl).children(".file").text() + " (0% complete)");

        upload.uploadForm.submit();

        updateProgress(ctrl, upload.fid, {
            Progress: 0,
            Complete: false
        });
    }

    function updateProgress(ctrl, fid, progress) {
        if (progress.Complete) {
            $(ctrl).find(".gauge").css("width", "592px");
            $(ctrl).find(".info").text("Uploading " + $(ctrl).children(".file").text() + " (100% complete)");
        }
        else {
            var width = progress.Progress * .01 * 592;
            $(ctrl).find(".gauge").css("width", width + "px");
            $(ctrl).find(".info").text("Uploading " + $(ctrl).children(".file").text() + " (" + progress.Progress + "% complete)");

            setTimeout(function () {
                $.get("UploadManager.axd?doc=status&fid=" + fid, function (update) {
                    updateProgress(ctrl, fid, update);
                });
            }, 2000);
        }
    }

    function setForm(ctrl, upload, info) {
        upload.uploadCtrl = info.form.children("input");
        upload.uploadForm = info.form;
        upload.fid = info.fid;

        setUpload(ctrl, upload);
    }

    function getUploadGroup(group) {
        var upload = m_uploadGroups[group];
        if (!upload) {
            upload = {
                upload: [],
                current: 0,
                uploaded: 0,
                submit: null,
            };

            m_uploadGroups[group] = upload;
        }

        return upload;
    }

    function uploadFile(group, submit) {
        if (submit) {
            submit.click();
        }
        else {
            var ctrl = getUploadGroup(group);

            if (ctrl.current < ctrl.upload.length) {
                ctrl.upload[ctrl.current++].documentUpload("submit", group);
            }
            else {
                ctrl.current = 0;
                ctrl.submit.click();
            }
        }
    }

    var members = {
        init: function(settings) {
            this.each(function () {
                var upload = getUpload($(this));
                upload.group = settings.group;
                upload.submit = settings.submit;
                upload.reset = settings.reset;
                setUpload($(this), upload);
            });

            getUploadGroup(settings.group).upload.push(this);
        },
        submitter: function (info) {
            this.each(function() {
                var upload = getUpload($(this));
                
                setForm($(this), upload, info);
            });

        },
        browse: function () {
            var upload = getUpload($(this));
            upload.uploadCtrl.click();
        },
        selected: function (file) {
            var upload = getUpload($(this));
            upload.file = true;

            if (file.display) {
                this.children(".file").html(file.name);
            }

            if (upload.submit) {
                submitFiles(this, upload);
            }
        },
        submit: function (group) {
            this.each(function () {
                var ctrl = $(this);

                var upload = getUpload(ctrl);
                if (upload.file) {
                    submitFiles(ctrl, upload);
                }
                else if (group) {
                    ctrl.children("input").val("0");
                    uploadFile(group, upload.submit);
                }
            });
        },
        uploaded: function (info) {
            this.each(function () {
                var ctrl = $(this);

                var upload = getUpload($(this));
                upload.file = false;

                ctrl.children("input").val(upload.fid);
                ctrl.children(".progress").hide();

                if (upload.reset) {
                    ctrl.children(".file").html(upload.reset);
                }

                setForm(ctrl, upload, info);
                uploadFile(upload.group, upload.submit);
            });
        }
    };

    $.fn.documentUpload = function (action, param, arg) {
        if (members[action]) {
            return members[action].call(this, param, arg);
        }
        else if (typeof action === 'object' || !action) {
            return members.init.call(this, action, param);
        }

        $.error(action + " is not a member of 'Document Upload'.");
    };

    $.initUpload = function (group, button) {
        getUploadGroup(group).submit = button;
    };

    $.submitUpload = function (group) {
        if (m_uploadGroups[group].current <= 0) {
            uploadFile(group);
        }
    };

    $.autoSubmit = function () {
    };
})(jQuery);

function validateAdd(sourceNumber)
{
    var allowAdd = true;
    var curCategory = $("[id$=ddlReportCategory]").val();

    if (curCategory == 2)
    {
        if (sourceNumber != 5 && sourceNumber != 8)
        {
            $(".Right tr").each(function(){
                var ds = $(this).attr("data-source");
                if (ds == "5" || ds == "8") {
                    Message.Show({ Message: "Invalid column combination. Try Scheduled Trainings or Training History instead.", Type: MessageType.Warning, IsSticky: false });
                    allowAdd = false;
                    return false;
                }
            });
        }
        else if (sourceNumber === 5 || sourceNumber == 8)
        {
            $(".Right tr").each(function(){
                var ds = $(this).attr("data-source");
                if (ds != sourceNumber) {
                    Message.Show({ Message: "Invalid column combination. Try Scheduled Trainings or Training History instead.", Type: MessageType.Warning, IsSticky: false });
                    allowAdd = false;
                    return false;
                }
            });
        }

    }

    return allowAdd;
}

var DLP =
{
    CheckListCounts: function(clientId)
    {
        var leftCount = $("#" + clientId).find(".Left .DlpTable tr").length;
        var rightCount = $("#" + clientId).find(".Right .DlpTable tr").length;

        var leftSpan = $("#" + clientId).find(".Left .EmptySpan");
        if (leftCount == 0)
        {
            leftSpan.html($("#" + clientId + "_EmptyUnassigned").val()).show();
        }
        else
        {
            leftSpan.html("").hide();
        }

        var rightSpan = $("#" + clientId).find(".Right .EmptySpan");
        if (rightCount == 0) {
            rightSpan.html($("#" + clientId + "_EmptyAssigned").val()).show();
        }
        else {
            rightSpan.html("").hide();
        }
    },

    ChangeToMinus : function(tr) 
    {
        $(tr).find("td:nth-child(2)").removeClass("glyphicon-plus").addClass("glyphicon-minus");
        tr.removeClass("bg-primary").addClass("bg-warning");
    },

    ChangeToPlus : function(tr) {
        $(tr).find("td:nth-child(2)").removeClass("glyphicon-minus").addClass("glyphicon-plus");
        tr.removeClass("bg-warning").addClass("bg-primary");
    },

    Sort: function (table) {
        var tbody = table.find("tbody");

        tbody.find("tr").sort(function (a, b) {
            return $("td:first", a).text().localeCompare($("td:first", b).text());
        }).appendTo(tbody);
    },

    BatchAssign: function(elemObj, dontSort)
    {
        var clientId = $(elemObj).parents(".DualListPanel").attr("id");
        var items = $("#" + clientId).find(".Left").find("tr");
        var copyToTable = $("#" + clientId).find(".Right").find("tbody").first();
        if (copyToTable.length == 0)
        {
            $("#" + clientId).find(".Right").find("table").append("<tbody></tbody>");
            copyToTable = $("#" + clientId).find(".Right").find("tbody").first();
        }
        items.each(function(){
            var trElm = $(this);
            var id = trElm.children("td").last().children("input").val();
            trElm.detach();
            trElm.appendTo(copyToTable);

            DLP.ChangeToMinus(trElm);
 
            DLP.Append(clientId, id);
        });
        if (!dontSort) {
            DLP.Sort(copyToTable.parent());
        }
        DLP.CheckListCounts(clientId);
    },

    BatchUnassign: function(elemObj, dontSort)
    {
        var clientId = $(elemObj).parents(".DualListPanel").attr("id");
        var items = $("#" + clientId).find(".Right").find("tr");
        var copyToTable = $("#" + clientId).find(".Left").find("tbody").first();
        if (copyToTable.length == 0)
        {
            $("#" + clientId).find(".Left").find("table").append("<tbody></tbody>");
            copyToTable = $("#" + clientId).find(".Left").find("tbody").first();
        }
        items.each(function(){
            var trElm = $(this);
            var id = trElm.children("td").last().children("input").val();
            trElm.detach();
            trElm.appendTo(copyToTable);

            DLP.ChangeToPlus(trElm);

            DLP.Remove(clientId, id);
        });
        if (!dontSort) {
            DLP.Sort(copyToTable.parent());
        }
        DLP.CheckListCounts(clientId);
    },

    Append: function(clientId, id)
    {
        var case1 = "," + id + ",";
        var case2 = id + ",";
        var str = $("#" + clientId + "_HiddenAssignedItems").val();

        //if the last char isn't a comma, we need to add one (this happens bc of the implementation of DLP.Remove())
        if (str.charAt(str.length - 1) != "," && str.length > 0)
        {
            str += "," + id + ",";
        }
        else
        {
            str += id + ",";
        }
        $("#" + clientId + "_HiddenAssignedItems").val(str);
    },

    Remove: function(clientId, id)
    {
        var str = $("#" + clientId + "_HiddenAssignedItems").val();
        str = str.replace(id + ",", "");
        $("#" + clientId + "_HiddenAssignedItems").val(str);
    },

    InsertWithHeaders: function(tr, dontSort)
    {
        var trElm = $(tr);

        var clientId = $(trElm).parents(".DualListPanel").attr("id");
        var isAssigning = $(trElm).parents("div").hasClass("Left");

        var copyToTable = null;
        var id = -1;

        //Check if source exists 
        var dataSource = $(trElm).attr("data-source");

        if (isAssigning)
        {
            var add = true;

            if (dataSource != undefined)
            {
                add = validateAdd(dataSource);
            }

            if (add)
            {
                trElm.detach();

                DLP.ChangeToMinus(trElm);

                //asp.net will not render tbody tag if nothing is in the table
                copyToTable = $("#" + clientId).find(".Right").find("tbody").first();
                if (copyToTable.length == 0) {
                    $("#" + clientId).find(".Right").find("table").append("<tbody></tbody>");
                    copyToTable = $("#" + clientId).find(".Right").find("tbody").first();
                }
                id = trElm.children("td").last().children("input").val();
                DLP.Append(clientId, id);
                trElm.appendTo(copyToTable);
            }
          
        }
        else {

            trElm.detach();

            DLP.ChangeToPlus(trElm);

            var index = $(trElm).attr("data-index");

            var arrayOfTrs = $(".Left tr").filter(function(){
                return parseInt($(this).attr("data-index")) < parseInt(index);
            });

            copyToTable = arrayOfTrs[arrayOfTrs.length - 1];
            if (copyToTable.length == 0) {
                $("#" + clientId).find(".Left").find("table").append("<tbody></tbody>");
                copyToTable = $("#" + clientId).find(".Left").find("tbody").first();
            }
            id = trElm.children("td").last().children("input").val();
            DLP.Remove(clientId, id);
            $(copyToTable).after(trElm);
        }
        DLP.CheckListCounts(clientId);
    },

    Insert: function(tr, dontSort) {
        var trElm = $(tr);

        var clientId = $(trElm).parents(".DualListPanel").attr("id");
        var isAssigning = $(trElm).parents("div").hasClass("Left");

        trElm.detach();

        var copyToTable = null;
        var id = -1;

        if (isAssigning) {
            DLP.ChangeToMinus(trElm);

            //asp.net will not render tbody tag if nothing is in the table
            copyToTable = $("#" + clientId).find(".Right").find("tbody").first();
            if (copyToTable.length == 0) {
                $("#" + clientId).find(".Right").find("table").append("<tbody></tbody>");
                copyToTable = $("#" + clientId).find(".Right").find("tbody").first();
            }
            id = trElm.children("td").last().children("input").val();
            DLP.Append(clientId, id);
        } else {
            DLP.ChangeToPlus(trElm);

            copyToTable = $("#" + clientId).find(".Left").find("tbody").first();
            if (copyToTable.length == 0) {
                $("#" + clientId).find(".Left").find("table").append("<tbody></tbody>");
                copyToTable = $("#" + clientId).find(".Left").find("tbody").first();
            }
            id = trElm.children("td").last().children("input").val();
            DLP.Remove(clientId, id);
        }
        trElm.appendTo(copyToTable);

        if (!dontSort) {
            DLP.Sort(copyToTable.parent());
        }
        DLP.CheckListCounts(clientId);
    }
};


//$(document).ready(function ()
//{
//    DLP.Initialize();
//});

$(document).ready(function() { EditProducer.BrowserSpecific(); });

EditProducer =
{
	BrowserSpecific: function() {
		
		
	}
}
function SetEnterHandle(boxName, btnName) {
	Misc.KeyToBtn(boxName, 13, btnName);
}
var EmployeeWitness = {
	ShowSubstance: function() {
		$('.SubstanceDesc').show();
	},
	HideSubstance: function() {
		$('.SubstanceDesc').hide();
	},
	ShowSubstanceAction: function() {
		$('.SubstanceAction').show();
	},
	HideSubstanceAction: function() {
		$('.SubstanceAction').hide();
	}
};

var dialogRedirect = false;
var redirectButton = "";

//Script to hide dialogs when the escape key is pressed
$(document).keydown(function (e) {
    if (e.keyCode === 27)//Escape key maps to key 27
    {
        GroupBox.FindAndHideGroupBox();
    }
});

var GroupBox = {
    SetTitle: function (newTitle, gbName)
    {
        GroupBox.GetBox(gbName).find('.GroupBoxHeader').text(newTitle);
    },
    GetName: function (name)
    {
        if (name.charAt(0) !== '#' && name.charAt(0) !== '.')
        {
            name = "#" + name;
        }
        return name;
    },
    GetBox: function (name)
    {
        name = GroupBox.GetName(name);
        return $(name + ' .GroupBoxBox');
    },
    Destroy: function (gbName)
    {
        var box = $(GroupBox.GetName(gbName));
        if (box.length === 0)
        {
            box = $('[id$=' + gbName + ']');
        }
        box.find('iframe').attr('src', '');
        box.hide();
    },
    Position : function(name) {
        var box = $(GroupBox.GetName(name));

        if (box.length === 0) {
            box = $('[id$=' + name + ']');
        }
        var boxData = box.find('.GroupBoxBox');

        boxData.css('top', parseInt(boxData.css('top'), 10) + $(document).scrollTop());
    },
    FindAndHideGroupBox: function () {

        //  Hide any open file upload progress bar dialogs before hiding any group boxes
        var uploadBoxes = $(".s-upload-box:visible");
        if (uploadBoxes.length > 0) {
            uploadBoxes.hide();
            return false;
        }

        var elems = $(".GroupBoxBox:visible");
        var containerElements = $(".GroupBoxContainer:visible");
        var highest = 0;
        var lowest = 0;
        var lowestIndex = 0;
        var highestIndex = 0;

        var redirectClassPresent = false;

        if (containerElements.length < 1) {
            return false;
        }

        elems.each(function (i, value) {

            var zindex = window.document.defaultView.getComputedStyle(value).getPropertyValue('z-index');
           
            if (zindex !== "auto") {
                if (parseInt(zindex) >= highest) {
                    highest = zindex;
                    highestIndex = i;

                    redirectClassPresent = $(containerElements[i]).hasClass("redirectButtonDiv");
                }

                if (parseInt(zindex) < lowest)
                {
                    lowest = zindex;
                    lowestIndex = i;
                }
            }
        });

        if ((highestIndex === lowestIndex && dialogRedirect && redirectButton !== "") || redirectClassPresent)
        {
            $(".GroupBoxBox:visible ." + redirectButton).click();
        }
        else
        {
            containerElements[highestIndex].style.display = "none";
        }

        return false;
    },
    SetDialogPage:function(btnName)
    {
        dialogRedirect = true;
        redirectButton = btnName;
    }
};
// Hover.js
//
// JavaScript for the Hover Button

var SucceedHover =
{
    MouseOver : function(btn)
    {
		var css = $(btn).attr('class');
		
		css += '_hover';
		
		$(btn).attr('class', css);
    },
    
    MouseOut : function(btn)
    {
		var css = $(btn).attr('class');
		
		css = css.substring(0, css.length - 6);
		
		$(btn).attr('class', css);
    }
}
var InputRestrict =
{
    NumsOnly: function(keyCode)
    {
        if (keyCode >= 48 && keyCode <= 57)
        {
            return true;
        }
        return false;
    },
    AlphaOnly: function(keyCode)
    {
        if ((keyCode >= 97 && keyCode <= 122) || (keyCode >= 65 && keyCode <= 90))
        {
            return true;
        }
        return false;
    }
};
/*
Lightbox for Bootstrap 3 by @ashleydw
https://github.com/ashleydw/lightbox
License: https://github.com/ashleydw/lightbox/blob/master/LICENSE
 */

(function () {
    "use strict";
    var $, EkkoLightbox;

    $ = jQuery;

    EkkoLightbox = function (element, options) {
        var content, footer, header;
        this.options = $.extend({
            title: null,
            footer: null,
            remote: null
        }, $.fn.ekkoLightbox.defaults, options || {});
        this.$element = $(element);
        content = '';
        this.modal_id = this.options.modal_id ? this.options.modal_id : 'ekkoLightbox-' + Math.floor((Math.random() * 1000) + 1);
        header = '<div class="modal-header"' + (this.options.title || this.options.always_show_close ? '' : ' style="display:none"') + '><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title" style="white-space:nowrap; overflow:hidden; text-overflow:ellipsis">' + (this.options.title || "&nbsp;") + '</h4></div>';
        footer = '<div class="modal-footer"' + (this.options.footer ? '' : ' style="display:none"') + '>' + this.options.footer + '</div>';
        $(document.body).append('<div id="' + this.modal_id + '" class="ekko-lightbox modal fade" tabindex="-1"><div class="modal-dialog"><div class="modal-content">' + header + '<div class="modal-body"><div class="ekko-lightbox-container"><div></div></div></div>' + footer + '</div></div></div>');
        this.modal = $('#' + this.modal_id);
        this.modal_dialog = this.modal.find('.modal-dialog').first();
        this.modal_content = this.modal.find('.modal-content').first();
        this.modal_body = this.modal.find('.modal-body').first();
        this.modal_header = this.modal.find('.modal-header').first();
        this.modal_footer = this.modal.find('.modal-footer').first();
        this.lightbox_container = this.modal_body.find('.ekko-lightbox-container').first();
        this.lightbox_body = this.lightbox_container.find('> div:first-child').first();
        this.showLoading();
        this.modal_arrows = null;
        this.border = {
            top: parseFloat(this.modal_dialog.css('border-top-width')) + parseFloat(this.modal_content.css('border-top-width')) + parseFloat(this.modal_body.css('border-top-width')),
            right: parseFloat(this.modal_dialog.css('border-right-width')) + parseFloat(this.modal_content.css('border-right-width')) + parseFloat(this.modal_body.css('border-right-width')),
            bottom: parseFloat(this.modal_dialog.css('border-bottom-width')) + parseFloat(this.modal_content.css('border-bottom-width')) + parseFloat(this.modal_body.css('border-bottom-width')),
            left: parseFloat(this.modal_dialog.css('border-left-width')) + parseFloat(this.modal_content.css('border-left-width')) + parseFloat(this.modal_body.css('border-left-width'))
        };
        this.padding = {
            top: parseFloat(this.modal_dialog.css('padding-top')) + parseFloat(this.modal_content.css('padding-top')) + parseFloat(this.modal_body.css('padding-top')),
            right: parseFloat(this.modal_dialog.css('padding-right')) + parseFloat(this.modal_content.css('padding-right')) + parseFloat(this.modal_body.css('padding-right')),
            bottom: parseFloat(this.modal_dialog.css('padding-bottom')) + parseFloat(this.modal_content.css('padding-bottom')) + parseFloat(this.modal_body.css('padding-bottom')),
            left: parseFloat(this.modal_dialog.css('padding-left')) + parseFloat(this.modal_content.css('padding-left')) + parseFloat(this.modal_body.css('padding-left'))
        };
        this.modal.on('show.bs.modal', this.options.onShow.bind(this)).on('shown.bs.modal', (function (_this) {
            return function () {
                _this.modal_shown();
                return _this.options.onShown.call(_this);
            };
        })(this)).on('hide.bs.modal', this.options.onHide.bind(this)).on('hidden.bs.modal', (function (_this) {
            return function () {
                if (_this.gallery) {
                    $(document).off('keydown.ekkoLightbox');
                }
                _this.modal.remove();
                return _this.options.onHidden.call(_this);
            };
        })(this)).modal('show', options);
        return this.modal;
    };

    EkkoLightbox.prototype = {
        modal_shown: function () {
            var video_id;
            if (!this.options.remote) {
                return this.error('No remote target given');
            } else {
                this.gallery = this.$element.data('gallery');
                if (this.gallery) {
                    if (this.options.gallery_parent_selector === 'document.body' || this.options.gallery_parent_selector === '') {
                        this.gallery_items = $(document.body).find('*[data-gallery="' + this.gallery + '"]');
                    } else {
                        this.gallery_items = this.$element.parents(this.options.gallery_parent_selector).first().find('*[data-gallery="' + this.gallery + '"]');
                    }
                    this.gallery_index = this.gallery_items.index(this.$element);
                    $(document).on('keydown.ekkoLightbox', this.navigate.bind(this));
                    if (this.options.directional_arrows && this.gallery_items.length > 1) {
                        this.lightbox_container.append('<div class="ekko-lightbox-nav-overlay"><a href="#" class="' + this.strip_stops(this.options.left_arrow_class) + '"></a><a href="#" class="' + this.strip_stops(this.options.right_arrow_class) + '"></a></div>');
                        this.modal_arrows = this.lightbox_container.find('div.ekko-lightbox-nav-overlay').first();
                        this.lightbox_container.find('a' + this.strip_spaces(this.options.left_arrow_class)).on('click', (function (_this) {
                            return function (event) {
                                event.preventDefault();
                                return _this.navigate_left();
                            };
                        })(this));
                        this.lightbox_container.find('a' + this.strip_spaces(this.options.right_arrow_class)).on('click', (function (_this) {
                            return function (event) {
                                event.preventDefault();
                                return _this.navigate_right();
                            };
                        })(this));
                    }
                }
                if (this.options.type) {
                    if (this.options.type === 'image') {
                        return this.preloadImage(this.options.remote, true);
                    } else if (this.options.type === 'youtube' && (video_id = this.getYoutubeId(this.options.remote))) {
                        return this.showYoutubeVideo(video_id);
                    } else if (this.options.type === 'vimeo') {
                        return this.showVimeoVideo(this.options.remote);
                    } else if (this.options.type === 'instagram') {
                        return this.showInstagramVideo(this.options.remote);
                    } else if (this.options.type === 'url') {
                        return this.loadRemoteContent(this.options.remote);
                    } else if (this.options.type === 'video') {
                        return this.showVideoIframe(this.options.remote);
                    } else {
                        return this.error("Could not detect remote target type. Force the type using data-type=\"image|youtube|vimeo|instagram|url|video\"");
                    }
                } else {
                    return this.detectRemoteType(this.options.remote);
                }
            }
        },
        strip_stops: function (str) {
            return str.replace(/\./g, '');
        },
        strip_spaces: function (str) {
            return str.replace(/\s/g, '');
        },
        isImage: function (str) {
            return str.match(/(^data:image\/.*,)|(\.(jp(e|g|eg)|gif|png|bmp|webp|svg)((\?|#).*)?$)/i);
        },
        isSwf: function (str) {
            return str.match(/\.(swf)((\?|#).*)?$/i);
        },
        getYoutubeId: function (str) {
            var match;
            match = str.match(/^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/);
            if (match && match[2].length === 11) {
                return match[2];
            } else {
                return false;
            }
        },
        getVimeoId: function (str) {
            if (str.indexOf('vimeo') > 0) {
                return str;
            } else {
                return false;
            }
        },
        getInstagramId: function (str) {
            if (str.indexOf('instagram') > 0) {
                return str;
            } else {
                return false;
            }
        },
        navigate: function (event) {
            event = event || window.event;
            if (event.keyCode === 39 || event.keyCode === 37) {
                if (event.keyCode === 39) {
                    return this.navigate_right();
                } else if (event.keyCode === 37) {
                    return this.navigate_left();
                }
            }
        },
        navigateTo: function (index) {
            var next, src;
            if (index < 0 || index > this.gallery_items.length - 1) {
                return this;
            }
            this.showLoading();
            this.gallery_index = index;
            this.$element = $(this.gallery_items.get(this.gallery_index));
            this.updateTitleAndFooter();
            src = this.$element.attr('data-remote') || this.$element.attr('href');
            this.detectRemoteType(src, this.$element.attr('data-type') || false);
            if (this.gallery_index + 1 < this.gallery_items.length) {
                next = $(this.gallery_items.get(this.gallery_index + 1), false);
                src = next.attr('data-remote') || next.attr('href');
                if (next.attr('data-type') === 'image' || this.isImage(src)) {
                    return this.preloadImage(src, false);
                }
            }
        },
        navigate_left: function () {
            if (this.gallery_items.length === 1) {
                return;
            }
            if (this.gallery_index === 0) {
                this.gallery_index = this.gallery_items.length - 1;
            } else {
                this.gallery_index--;
            }
            this.options.onNavigate.call(this, 'left', this.gallery_index);
            return this.navigateTo(this.gallery_index);
        },
        navigate_right: function () {
            if (this.gallery_items.length === 1) {
                return;
            }
            if (this.gallery_index === this.gallery_items.length - 1) {
                this.gallery_index = 0;
            } else {
                this.gallery_index++;
            }
            this.options.onNavigate.call(this, 'right', this.gallery_index);
            return this.navigateTo(this.gallery_index);
        },
        detectRemoteType: function (src, type) {
            var video_id;
            type = type || false;
            if (type === 'image' || this.isImage(src)) {
                this.options.type = 'image';
                return this.preloadImage(src, true);
            } else if (type === 'youtube' || (video_id = this.getYoutubeId(src))) {
                this.options.type = 'youtube';
                return this.showYoutubeVideo(video_id);
            } else if (type === 'vimeo' || (video_id = this.getVimeoId(src))) {
                this.options.type = 'vimeo';
                return this.showVimeoVideo(video_id);
            } else if (type === 'instagram' || (video_id = this.getInstagramId(src))) {
                this.options.type = 'instagram';
                return this.showInstagramVideo(video_id);
            } else if (type === 'video') {
                this.options.type = 'video';
                return this.showVideoIframe(video_id);
            } else {
                this.options.type = 'url';
                return this.loadRemoteContent(src);
            }
        },
        updateTitleAndFooter: function () {
            var caption, footer, header, title;
            header = this.modal_content.find('.modal-header');
            footer = this.modal_content.find('.modal-footer');
            title = this.$element.data('title') || "";
            caption = this.$element.data('footer') || "";
            if (title || this.options.always_show_close) {
                header.css('display', '').find('.modal-title').html(title || "&nbsp;");
            } else {
                header.css('display', 'none');
            }
            if (caption) {
                footer.css('display', '').html(caption);
            } else {
                footer.css('display', 'none');
            }
            return this;
        },
        showLoading: function () {
            this.lightbox_body.html('<div class="modal-loading">' + this.options.loadingMessage + '</div>');
            return this;
        },
        showYoutubeVideo: function (id) {
            var height, rel, width;
            if ((this.$element.attr('data-norelated') != null) || this.options.no_related) {
                rel = "&rel=0";
            } else {
                rel = "";
            }
            width = this.checkDimensions(this.$element.data('width') || 560);
            height = width / (560 / 315);
            return this.showVideoIframe('//www.youtube.com/embed/' + id + '?badge=0&autoplay=1&html5=1' + rel, width, height);
        },
        showVimeoVideo: function (id) {
            var height, width;
            width = this.checkDimensions(this.$element.data('width') || 560);
            height = width / (500 / 281);
            return this.showVideoIframe(id + '?autoplay=1', width, height);
        },
        showInstagramVideo: function (id) {
            var height, width;
            width = this.checkDimensions(this.$element.data('width') || 612);
            this.resize(width);
            height = width + 80;
            this.lightbox_body.html('<iframe width="' + width + '" height="' + height + '" src="' + this.addTrailingSlash(id) + 'embed/" frameborder="0" allowfullscreen></iframe>');
            this.options.onContentLoaded.call(this);
            if (this.modal_arrows) {
                return this.modal_arrows.css('display', 'none');
            }
        },
        showVideoIframe: function (url, width, height) {
            height = height || width;
            this.resize(width);
            this.lightbox_body.html('<div class="embed-responsive embed-responsive-16by9"><iframe width="' + width + '" height="' + height + '" src="' + url + '" frameborder="0" allowfullscreen class="embed-responsive-item"></iframe></div>');
            this.options.onContentLoaded.call(this);
            if (this.modal_arrows) {
                this.modal_arrows.css('display', 'none');
            }
            return this;
        },
        loadRemoteContent: function (url) {
            var disableExternalCheck, width;
            width = this.$element.data('width') || 560;
            this.resize(width);
            disableExternalCheck = this.$element.data('disableExternalCheck') || false;
            if (!disableExternalCheck && !this.isExternal(url)) {
                this.lightbox_body.load(url, $.proxy((function (_this) {
                    return function () {
                        return _this.$element.trigger('loaded.bs.modal');
                    };
                })(this)));
            } else {
                this.lightbox_body.html('<iframe width="' + width + '" height="' + width + '" src="' + url + '" frameborder="0" allowfullscreen></iframe>');
                this.options.onContentLoaded.call(this);
            }
            if (this.modal_arrows) {
                this.modal_arrows.css('display', 'none');
            }
            return this;
        },
        isExternal: function (url) {
            var match;
            match = url.match(/^([^:\/?#]+:)?(?:\/\/([^\/?#]*))?([^?#]+)?(\?[^#]*)?(#.*)?/);
            if (typeof match[1] === "string" && match[1].length > 0 && match[1].toLowerCase() !== location.protocol) {
                return true;
            }
            if (typeof match[2] === "string" && match[2].length > 0 && match[2].replace(new RegExp(":(" + {
              "http:": 80,
              "https:": 443
            }[location.protocol] + ")?$"), "") !== location.host) {
                return true;
            }
            return false;
        },
        error: function (message) {
            this.lightbox_body.html(message);
            return this;
        },
        preloadImage: function (src, onLoadShowImage) {
            var img;
            img = new Image();
            if ((onLoadShowImage == null) || onLoadShowImage === true) {
                img.onload = (function (_this) {
                    return function () {
                        var image;
                        image = $('<img />');
                        image.attr('src', img.src);
                        image.addClass('img-responsive');
                        _this.lightbox_body.html(image);

                        if (img.width < 250) {
                            _this.lightbox_body.attr('style', 'margin:auto;width:' + img.width + 'px;');
                        }
                        else {
                            _this.lightbox_body.attr('style', '');
                        }

                        if (_this.modal_arrows) {
                            _this.modal_arrows.css('display', 'block');
                        }
                        return image.load(function () {
                            if (_this.options.scale_height) {
                                _this.scaleHeight(img.height, img.width);
                            } else {
                                _this.resize(img.width);
                            }
                            return _this.options.onContentLoaded.call(_this);
                        });
                    };
                })(this);
                img.onerror = (function (_this) {
                    return function () {
                        return _this.error('Failed to load image: ' + src);
                    };
                })(this);
            }
            img.src = src;
            return img;
        },
        scaleHeight: function (height, width) {
            var border_padding, factor, footer_height, header_height, margins, max_height;
            header_height = this.modal_header.outerHeight(true) || 0;
            footer_height = this.modal_footer.outerHeight(true) || 0;
            if (!this.modal_footer.is(':visible')) {
                footer_height = 0;
            }
            if (!this.modal_header.is(':visible')) {
                header_height = 0;
            }
            border_padding = this.border.top + this.border.bottom + this.padding.top + this.padding.bottom;
            margins = parseFloat(this.modal_dialog.css('margin-top')) + parseFloat(this.modal_dialog.css('margin-bottom'));
            max_height = $(window).height() - border_padding - margins - header_height - footer_height;
            factor = Math.min(max_height / height, 1);
            this.modal_dialog.css('height', 'auto').css('max-height', max_height);
            return this.resize(factor * width);
        },
        resize: function (width) {
            var width_total;
            width_total = width + this.border.left + this.padding.left + this.padding.right + this.border.right;
            this.modal_dialog.css('width', 'auto').css('min-width', '250px').css('max-width', width_total);
            this.lightbox_container.find('a').css('line-height', function () {
                return $(this).parent().height() + 'px';
            });
            return this;
        },
        checkDimensions: function (width) {
            var body_width, width_total;
            width_total = width + this.border.left + this.padding.left + this.padding.right + this.border.right;
            body_width = document.body.clientWidth;
            if (width_total > body_width) {
                width = this.modal_body.width();
            }
            return width;
        },
        close: function () {
            return this.modal.modal('hide');
        },
        addTrailingSlash: function (url) {
            if (url.substr(-1) !== '/') {
                url += '/';
            }
            return url;
        }
    };

    $.fn.ekkoLightbox = function (options) {
        return this.each(function () {
            var $this;
            $this = $(this);
            options = $.extend({
                remote: $this.attr('data-remote') || $this.attr('href'),
                gallery_parent_selector: $this.attr('data-parent'),
                type: $this.attr('data-type')
            }, options, $this.data());
            new EkkoLightbox(this, options);
            return this;
        });
    };

    $.fn.ekkoLightbox.defaults = {
        gallery_parent_selector: 'document.body',
        left_arrow_class: '.glyphicon .glyphicon-chevron-left',
        right_arrow_class: '.glyphicon .glyphicon-chevron-right',
        directional_arrows: true,
        type: null,
        always_show_close: true,
        no_related: false,
        scale_height: true,
        loadingMessage: 'Loading...',
        onShow: function () { },
        onShown: function () { },
        onHide: function () { },
        onHidden: function () { },
        onNavigate: function () { },
        onContentLoaded: function () { }
    };

}).call(this);
var ProgressBar = {
    UpdateFrequency: 100,
    FinishDelay: 200,
    Height: 30,
    Width: 600,
    HandlerUrl: '',
    LastValue: -1,
    FinishLabel: 'Done',
    UpdateTimeout: null,
    Show: function (label) {
        ProgressBar.HandlerUrl = $('.SProgressBar').attr('handlerDir');
        ProgressBar.Resize();
        if (label) {
            $('.SProgressBarLabel').html(label);
        }
        $('.SProgressBar').show();
        $('.SProgressBarBar').progressbar({ value: 0 });
        if (ProgressBar.HandlerUrl) {
            ProgressBar.Update();
        }
        return true;
    },
    Hide: function () {
        $('.SProgressBar').hide();
        $('.SProgressBarBar').progressbar('option', 'value', 0);
        $('.SProgressBarLabel').html('');
    },
    Resize: function () {
        $('.SProgressBar .Body').css({ left: $(document).width() / 2 - ProgressBar.Width / 2, top: $(document).height() / 2 - ProgressBar.Height / 2 });
        $('.SProgressBar .Overlay').css({ width: $(document).width(), height: $(document).height() });
    },
    Update: function (value, label) {
        if (value) {
            $('.SProgressBarBar').progressbar('option', 'value', value);
            ProgressBar.LastValue = value;

            if (label) {
                $('.SProgressBarLabel').html(label);
            }
        }
        else if (ProgressBar.HandlerUrl) {
            $.get(ProgressBar.HandlerUrl, null, function (data) { ProgressBar.ProccessData(data); });
        }
    },
    ProccessData: function (data) {
        var items = data.split('|||');
        var val = parseInt(items[0]);
        var label = items[1];
        if (val < ProgressBar.LastValue) { //request has finished with a 0 (appstate lost?)
            val = 100;
            label = ProgressBar.FinishLabel;
        }
        $('.SProgressBarBar').progressbar('option', 'value', val);
        if (label == '') {
            $('.SProgressBarLabel').html('Importing...');
        } else {
            $('.SProgressBarLabel').html(label);
        }
        if (val < 100 && val >= 0) {
            ProgressBar.LastValue = val;
            ProgressBar.UpdateTimeout = setTimeout(function () { ProgressBar.Update(); }, ProgressBar.UpdateFrequency);
        } else {
            setTimeout(function () { ProgressBar.Hide(); }, ProgressBar.FinishDelay);
            ProgressBar.LastValue = 0;
        }
    },
    ForceHide: function () {
        clearTimeout(ProgressBar.UpdateTimeout);
        $('.SProgressBarBar').progressbar('option', 'value', 100);
        $('.SProgressBarLabel').html(ProgressBar.FinishLabel);
        setTimeout(function () { ProgressBar.Hide(); }, ProgressBar.FinishDelay);
        ProgressBar.LastValue = 0;
    }
};
var RecordTrainingFiles = {
	//	CurrentIndex: null,
	FileAdded: function (args) {
		var files = '';
		for (var i = 0; i < args.length; i++) {
			files += args[i].Index + ',';
		}
		if (files.length > 0 && files[files.length - 1] == ',') {
			files = files.substr(0, files.length - 1);
		}
		$('input[id$=hfFileName]').val(files);
		$('input[id$=btnFileAdded]').click();
		//		RecordTrainingFiles.CurrentIndex = args.Index;
	},
	FileRemoved: function (args) {
		$('input[id$=hfFileName]').val(args.Name);
		$('input[id$=btnFileRemoved]').click();
	},
	SetSelectedTypeLabel: function (label) {
		//		if (RecordTrainingFiles.CurrentIndex == null) {
		//			return;
		//		}
		//		var trIndex = RecordTrainingFiles.CurrentIndex + 1;
		//		var td = $('.SFileUploadFilesTable').find('tr:eq(' + trIndex + ')').children('td:first');
		//		td.text(td.text() + label);
	}
};
var Reorder =
{
	Initialize: function() {

		$('div.reorder').sortable({ items: 'div.dragme',
			update: function(e) {
				var txt = '';
				$('.lblsort').each(function(o) { txt = txt + this.innerHTML + ',' });
				$("[Id$='hdnOrder']").val(txt);

				__doPostBack($("[id$='btnReorderHidden']").attr("name"), '');
			}
		});
	}
}
var SCheckBox = {
	Setup: function() {
	    $(document).on('mouseover', '.SCheckBox', function () {
			$(this).addClass('Hover');
			$(this).next('label').addClass('Hover');
	    }).on('mouseout', '.SCheckBox', function () {
			$(this).removeClass('Hover');
			$(this).next('label').removeClass('Hover');
		});
	    $(document).on('mouseover','label', function () {
			if ($(this).prev('.SCheckBox').length != 1) {
				return;
			}
			$(this).addClass('Hover');
			$(this).prev('.SCheckBox').addClass('Hover');

	    }).on('mouseout', 'label', function () {
			if ($(this).prev('.SCheckBox').length != 1) {
				return;
			}
			$(this).removeClass('Hover');
			$(this).prev('.SCheckBox').removeClass('Hover');
		});
	}
};
$(document).ready(function() {
//	SCheckBox.Setup();
});
$(document).ready(function ()
{;
    $(document).on("click", ".SCheckAll :checkbox", function ()
    {
        var cbs = $(this).closest(".SCheckAll").find(":checkbox");
        if ($(this).attr("id") == cbs.eq(0).attr("id"))
        {
            var toggle = $(this).prop("checked");
            cbs.slice(1).prop("checked", toggle);
        }
        else if (cbs.slice(1).filter(':not(:checked)').length)
        {
            cbs.eq(0).prop('checked', false);
        }
        else
        {
            cbs.eq(0).prop('checked', true);
        }
    });
});

var SColorPicker = {
	Show: function (divName, boxName, offset) {
		var div = $('#' + divName);
		var box = $('#' + boxName);
		var pos = box.offset();
//		if (offset != null) {
//			pos.top = offset.top > 0 ? offset.top : pos.top;
//			pos.left = offset.left > 0 ? offset.left : pos.left;
//		}
		$('.ColorPickerContainer:not(#' + divName + ')').hide();
		pos.left = pos.left + box.width() + 40;
		div.parent().offset(pos);
		div.toggle();
		var f = div.farbtastic('#' + boxName);
	}
};
var SDownloader = {
    Download: function (url, showIeBox)
    {
            $('.SDownloader').attr('src', url);
        return true;
    }
};
var SelectDocument =
{
};
function ShowSelEmpSearch() { 
	$('#divBrowse').hide();
	$('#divSearch').show();
}

function ShowSelEmpBrowse() {
	$('#divSearch').hide();
	$('#divBrowse').show();
}

function SetEmployeeSelected(name) {
	$('.EmployeeNameLabel').text(name);
}

function HideResults() {
	$('.SelEmployeeResults').hide();
}

function ShowResults() {
	$('.SelEmployeeResults').show();
	$('#findfirstnote').hide();
}

function SetEnterKey(boxName,btnName) {
	Misc.KeyToBtn(boxName,13,btnName);
}
var SelectGroup =
{
	ShowSearch: function() {
		$('#TR_GroupSearch td').show();
		return true;
	},
	HideSearch: function() {
		$('#TR_GroupSearch td').hide();
		return true;
	}
}
//obsolete
var SelectToolbox =
{
	ShowToolboxes: function() {
		$('#SelToolboxResults').show();
		$('#SelGroupResourcesResults').hide();
	},
	ShowGroupResources: function() {
		$('#SelToolboxResults').hide();
		$('#SelGroupResourcesResults').show();
	}
};
var SelectTraining = {
    SetTrainingSelected: function (name) {
        $('.TrainingNameLabel').text(name);
    },
    SetEnterKey: function (box, btn) {
        Misc.KeyToBtn(box, 13, btn);
    },
    ShowResults: function () {
        $('.SelTrainingResults').show();
        $('#spnSelTrainingNote').hide();
    },
    HideResults: function () {
        $('.SelTrainingResults').hide();
        $('#spnSelTrainingNote').show();
    },
    ShowOfflineResults: function () {
        $('#divResultsOnline').hide();
        $('#divResultsOffline').show();
        SelectTraining.ShowResults();
    },
    ShowOnlineResults: function () {
        $('#divResultsOffline').hide();
        $('#divResultsOnline').show();
        SelectTraining.ShowResults();
    },
    ShowOfflineResultsOnly: function () {
        $('#tdOnOffSelector').hide();
        $('#divResultsOnline').hide();
        $('#divResultsOffline').show();
        SelectTraining.ShowResults();
    },
    ShowOnlineResultsOnly: function () {
        $('#tdOnOffSelector').hide();
        $('#divResultsOffline').hide();
        $('#divResultsOnline').show();
        SelectTraining.ShowResults();
    }
};
(function (control, $) {
    function drag(e) {
        e.stopPropagation();
        e.preventDefault();
    }

    function addFile(uploader, file, index, id, s3Load, showDownloadLink) {
        var hiddenFields = (uploader).find('input:hidden');
        
        if (hiddenFields.val().indexOf(id) > -1) {
            var html = "<div class=\"s-upload-file\" ";
            if (index > 0) {
                html += "border-top: solid 1px black\"";
            }

            html += ">";
            if (id && showDownloadLink) {   //  If file id was provided, make a download link.
                html += "<a href=\"#\" onclick=\"";
                var downloadLink = "$('.SDownloader').attr('src','Library.axd?file=" + id + "')";

                if (s3Load)
                {
                    downloadLink = "$('.SDownloader').attr('src','Library.axd?s3Load=true&file=" + id + "')";
                }

                html += downloadLink + "; return false;\" >" + file.name + "</a>";
            } else {
                html += file.name;
            }

            html += "<span class=\"glyphicon glyphicon-trash\" onclick=\"window.files.delete("
                + "$(this).parent()," + index + ")\" /></div>";

            uploader.append(html);
        }
    }

    function sendFile(files, uploader, options) {
        if (files) {
            var progress = $("#" + options.progressbar);
            var value = uploader.find("input:first");
            var input = uploader.find("input:last");

            var bar = progress.find(".progress-bar");
            var text = progress.find(".text");

            text.html("Uploading ... 0% Complete");
            bar.css("width", "0");

            var fd = new FormData();

            if (options.multiple) {
                fd.append("filemode", "multiple");
                var prevFiles = value.val();
                if (prevFiles) {
                    fd.append("id", prevFiles);
                }

                for (var i = 0; i < files.length; i++) {                 
                    fd.append("file" + i, files[i]);
                }
            }
            else {
                fd.append("filemode", "single");
                fd.append("file0", files[0]);
            }

            var xhr = new XMLHttpRequest();
            xhr.upload.addEventListener("progress", function (e) {
                if (e.lengthComputable) {
                    var percentage = Math.round(e.loaded / e.total * 100) + "%";
                    text.html("Uploading ... " + percentage + " Complete");
                    bar.css("width", percentage);
                }
            }, false);
            xhr.addEventListener("load", function () {
                if (xhr.status !== 200) {
                    text.html(xhr.statusText);
                    bar.css("width", 0);
                    return;
                }
                var id = xhr.response;
                value.val(id);
                input.replaceWith(input);

                var idArray = id.split("\*");

                //  The files array contains only the newly added files. However, the idArray contains all the
                //  current file ids with the newest files at the end. 
                //  So we need to work backwards through the two arrays to set the ids. -D.B. 10/8/15
                for (var i = files.length - 1, k = idArray.length - 1; i >= 0; i--, k--) {
                    if (!files[i].id) {
                        files[i].id = idArray[k];
                    }
                }

                if (options.multiple) {
                    for (i = 0; i < files.length; i++) {
                        addFile(uploader, files[i], i, files[i].id, options.s3Load, options.showDownloadLink === "true");
                    }
                }
                else {
                    if (options.hideFileUploadDiv === "false") {
                        uploader.children(".s-upload-file").remove();
                        addFile(uploader, files[0], 0, id, options.s3Load, options.showDownloadLink === "true");
                    }
                    else {
                        $(".lnkFile").text(files[0].name);
                        $(".lnkFile").attr("href", "Library.axd?" + (options.s3Load ? "s3Load=true&" : "") + "file=" + id);
                    }
                }

            });
            xhr.addEventListener("loadend", function () {
                $("div#ProgressBarCancel").hide();
                $("div#ProgressBarClose").show();
                bar.removeClass("active");
            });
            xhr.addEventListener("abort", function () {
                text.html("Upload cancelled.");
                bar.css("width", 0);
            });

            $("div#ProgressBarCancel").click(function () { xhr.abort(); });

            $("div#ProgressBarCancel").show();
            $("div#ProgressBarClose").hide();
            progress.show();
            xhr.open("POST", options.url);
            xhr.send(fd);
        }
    }

    control.init = function (uploader) {        
        var ctrl = $("#" + uploader.id);
        var target = ctrl.children("div:first");
        target.bind("dragenter", drag);
        target.bind("dragover", drag);
        target.bind("drop", function (e) {
            drag(e);

            sendFile(e.originalEvent.dataTransfer.files, ctrl, uploader);
        });

        ctrl.find("input").bind("change", function () {            
            var files = $(this).get(0).files;
            if (files && files.length) {
                sendFile(files, ctrl, uploader);
            }
        });

        ctrl.find("input").bind("click", function () {
            this.value = null;
        });
    };

    control.delete = function (row, index) {
        var input = row.parent().find("input:first");

        var files = input.val().split("*");
        files.splice(index, 1);

        input.val(files.length > 0 ? files.join("*") : "");
        row.remove();
    };

}(window.files = window.files || {}, jQuery));

var SGridView = {

    ClearSelections: function (gvName) {
        var gv = $('#' + gvName);
        var allBox = gv.find('[id$=chkAll]');
        allBox.prop('checked', false);
        var boxes = gv.find('[id$=chkSelector]');
        boxes.prop('checked', false);
    }
};

var SCheckBoxGVAdv =
{
    ToggleCheckAll: function (allBox, listName)
    {
        $("input[class='" + listName + "']input[type='checkbox']:enabled").prop("checked", allBox.checked);
    },

    OnCheck: function (listName)
    {
        var all = true;
        $("input[class='" + listName + "']input[type='checkbox']").each(function () {
            all &= $(this).prop("checked");
        });

        var allCheck = $("input[class='" + listName + "All']input[type='checkbox']");
        allCheck.prop("checked", all);
    }
};

var GridHack =
{
    oldValue: "GridHiddenButtonField",

    GetObj : function()
    {
        return $('#' + GridHack.oldValue);
    },

    SetPostValue: function(obj)
    {
        if (typeof window.chrome === "object")
        {
            var name = $(obj).attr('name');
            var id = $(obj).attr('id');

            var o = GridHack.GetObj();

            o.attr('id', id);
            o.attr('name', name);

            GridHack.oldValue = id;
        }
    },

    ClearPostValue : function()
    {
        if (typeof window.chrome === "object")
        {
            var o = GridHack.GetObj();

            o.attr('id', "GridHiddenButtonField");
            o.attr('name', "");

            GridHack.oldValue = "GridHiddenButtonField";
        }
    }
};

//  These are the listeners that make the grid paging controls work. DEF-579
var GridPaging =
{
    Initialize: function () {
        GridPaging.SetupTextbox();
        GridPaging.SetupButton();
        GridPaging.SetupSizeSelect();
    },
    SetupTextbox: function () {
        $('.pager-text').off();
        $('.pager-text').keyup(function(e) {
            e.stopPropagation();
            e.preventDefault();
            if (e.keyCode === 13) {
                var page = 'Page$' + $(this).val();
                var grid = $(this).data('grid-target');
                __doPostBack(grid, page);
            }
        });
        $('.pager-text').focus(function() { $(this).select(); });
    },
    SetupButton: function() {
        $('.pager-button').off();
        $('.pager-button').click(function(e) {
            e.stopPropagation();
            e.preventDefault();
            var page = 'Page$' + $(this).prev().val();
            var grid = $(this).data('grid-target');
            __doPostBack(grid, page);
        });
    },
    SetupSizeSelect: function() {
        $('.pager-size').off();
        $('.pager-size').change(function(e) {
            e.stopPropagation();
            e.preventDefault();
            var pageSize = 'sgvonpagesizechange$' + $(this).val();
            var grid = $(this).data('grid-target');
            __doPostBack(grid, pageSize);
        });
    }
}


var SHoverButton = {
	HoverOver: function(btn) {
		$(btn).removeClass('Normal').addClass('Hover');
		SHoverButton.__HandleIE6(btn, 'Normal', 'Hover');
	},
	HoverOut: function(btn) {
		$(btn).removeClass('Hover').addClass('Normal');
		SHoverButton.__HandleIE6(btn, 'Hover', 'Normal');
	},
	Down: function(btn) {
		$(btn).removeClass('Hover').addClass('Down');
		SHoverButton.__HandleIE6(btn, 'Hover', 'Down');
	},
	Up: function(btn) {
		$(btn).removeClass('Down').addClass('Hover');
		SHoverButton.__HandleIE6(btn, 'Down', 'Hover');
	},
	SetEvents: function() {
	    $(document).on('mouseover', '.SHoverButton:enabled', function () {
			SHoverButton.HoverOver(this);
	    }).on('mouseout', '.SHoverButton:enabled', function () {
			SHoverButton.HoverOut(this);
	    }).one('mousedown', '.SHoverButton:enabled', function () {
			SHoverButton.Down(this);
	    }).on('mouseup', '.SHoverButton:enabled', function () {
			SHoverButton.Up(this);
		});
	},
	__HandleIE6: function(btn, oldState, newState) {
		return;
	}
};

$(document).ready(function() {
	SHoverButton.SetEvents();
});
var SMenu = {
    IsFirstLoad: true,
    ShowCat: function (name) {
        $('.CategoryContent').hide();
        $('#' + name).show();
    },
    SetEvents: function () {
        $('.Task, .Category').hover(function () {
            var $t = $(this);
            
                $t.stop().css('color', 'white').animate({ backgroundColor: '#4e77b5' }, 300, function () { $t.addClass('MenuItemHover'); });
            
            url = $t.find('img').attr('src');
            $t.find('img').attr('src', url + '_hover');
            $t.find('.TaskTooltip').show();
        }, function () {
            var $t = $(this);
           
                $t.stop().css('color', 'black').css('background-color', 'transparent');
            
            $t.removeClass('MenuItemHover');
            url = $t.find('img').attr('src');
            $t.find('img').attr('src', url.replace('_hover', ''));
            $t.find('.TaskTooltip').hide();
        });
        $('.SMenuButton').hover(function () {
            $(this).css('font-weight', 'bold').css('background-image', 'url(img.axd?grad=SMenuButtonGradHover)');
        }, function () {
            $(this).css('font-weight', 'normal').css('background-image', 'url(img.axd?grad=SMenuButtonGrad)');
        });
        $('.Category').mousedown(function () {
            $('.Category').removeClass('MenuItemDown');
            $(this).addClass('MenuItemDown');
        });
        $('.VerticalMenuBar').hover(function () {
            $(this).addClass('Hover');
        }, function () {
            $(this).removeClass('Hover');
        }).click(function () {
            SMenu.Toggle();
        });
    },
    Show: function () {
        $('.ButtonMenu').removeClass('MenuHide');
        $('.IE6DropDownExcluder').show();
    },
    Hide: function () {
        $('.ButtonMenu').addClass('MenuHide');
        $('.IE6DropDownExcluder').hide();
    },
    Toggle: function () {

        var iFrameContents = $('#gbMainiframe').attr('src');

        if ($('.ButtonMenu').hasClass('MenuHide')) {
            $('.ButtonMenu').removeClass('MenuHide');
            $('.IE6DropDownExcluder').show();
        }
        else if(iFrameContents.length > 0) {
           $('.ButtonMenu').addClass('MenuHide');
            $('.IE6DropDownExcluder').hide();
        }
    },
    Leave: function (url) {
        Wait.Show();
        window.location.href = url;
    },
    ClearSelection: function () {
        $('.MenuItemDown').each(function () {
            $(this).removeClass('MenuItemDown');
        });
    }
};

$(document).ready(function () {
	SMenu.SetEvents();
	if ($('.VerticalMenuBar:visible').length == 1) {
		$('.MainContent > .GroupBoxBox').css({ left: '25px', top: '0px', width: '975px', bottom: '0px', position: 'absolute' });
	}
});
var SNavMenu = {
	__inMenuItem: false,
	__inSubMenuItem: false,
	__currentSubMenu: null,
	__currentMainIndex: -1,
	__hideDelay: 100,
	__slideSpeed: 100,
	__hideTimeoutHandler: null,
	SetupEvents: function() {
		$('.SNavMenu').delegate('.SNavMenuItem', 'mouseenter', function() {
			var subMenu = $(this).find('.SNavMenuSubMenu:first');
			subMenu.slideDown(SNavMenu.__slideSpeed);
			SNavMenu.__inMenuItem = true;
		}).delegate('.SNavMainItem', 'mouseenter', function() {
			var index = $('.SNavMainItem').index(this);
			if (SNavMenu.__currentMainIndex != -1 && SNavMenu.__currentMainIndex != index) {
				$('.SNavMainItem:eq(' + SNavMenu.__currentMainIndex + ')').find('.SNavMenuSubMenu:first').slideUp(SNavMenu.__slideSpeed);
			}
			SNavMenu.__currentMainIndex = index;
		}).delegate('.SNavMenuItem', 'mouseleave', function() {
			SNavMenu.__inMenuItem = false;
			SNavMenu.__currentSubMenu = $(this).find('.SNavMenuSubMenu:first');
			SNavMenu.StartHideCheck();
		}).delegate('.SNavMenuSubMenu', 'mouseenter', function() {
			SNavMenu.__inSubMenuItem = true;
		}).delegate('.SNavMenuSubMenu', 'mouseleave', function() {
			SNavMenu.__inSubMenuItem = false;
			SNavMenu.__currentSubMenu = $(this);
			SNavMenu.StartHideCheck();
		}).delegate('.SNavMenuItem', 'hover', function() {
			$(this).toggleClass('LFRx_StaticHover').toggleClass('SNavItemHover');
		});
	},
	StartHideCheck: function() {
		clearTimeout(SNavMenu.__hideTimeoutHandler);
		SNavMenu.__hideTimeoutHandler = setTimeout(function() { SNavMenu.HideCheck(); }, SNavMenu.__hideDelay);
	},
	HideCheck: function() {
		if (!SNavMenu.__inMenuItem && !SNavMenu.__inSubMenuItem) {
			SNavMenu.__currentSubMenu.slideUp(SNavMenu.__slideSpeed);
		}
	}
};

$(document).ready(function() {
	SNavMenu.SetupEvents();
});
var SortBox =
{
    Open: function(sortarea) {
        $(sortarea).sortable({ update: SortBox.Reordered });
    },

    Reordered: function(e, ui) {
        var cls = "reordermain";
        var othercls = "reorderalt";

        ui.item.parent().children("div").each(
            function() {
                if ($(this).hasClass(othercls)) {
                    $(this).removeClass(othercls);
                    $(this).addClass(cls);
                }

                var tmp = cls;
                cls = othercls;
                othercls = tmp;
            });
    },

    Save: function(sortarea, sortids) {
        var ids = "";

        // get the ids for each item
        $(sortarea).children("div").each(function() { ids = ids + "," + $(this).children("span:last").text(); });

        if (ids == "") { return false; }

        // send the ids to the page
        $(sortids).val(ids.substr(1));

        $(sortarea).sortable('distroy');
        return true;
    },

    Close: function(sortarea, sortbox) {
        $(sortarea).sortable('destroy');
        Display.Hide(sortbox);
    }
}

var SPlaceholder = {
    Setup: function () {
        $('.SPlaceholder').delegate('.SPlaceholderButton', 'hover', function () {
            $(this).toggleClass('SPlaceholderButtonHover');
        }).delegate('.SPlaceholderButton', 'click', function () { 
            $(this).parent('.SPlaceholder').find('.SPlaceholderButton').removeClass('.SPlaceholderButtonSelected');
            $(this).addClass('.SPlaceholderButtonSelected');
        });
    }
};

$(document).ready(function () {
    SPlaceholder.Setup() 
});
var SProgressBar = {
    Max: 1,
    Current: 1,
    HandlerToUse: "Import.axd?type=",
    StopProgress : false,

    GetHandler : function(importType) {
        var h = SProgressBar.HandlerToUse;

        if (importType !== "role") {
            h += importType + "&";
        } else {
            h += "?";
        }
        var date = new Date();

        return h + "req=" + date.getTime();
    },

    SetMax: function (m, isAllFields) {
        SProgressBar.Max = m;
        SProgressBar.Update(SProgressBar.Current, isAllFields);
    },
    Update: function (curPos, isAllFields) {
        SProgressBar.Current = curPos > SProgressBar.Max ? SProgressBar.Current : curPos;
        var suffix = isAllFields ? " records completed." : " required records completed.";
        $(".SProgressBar .ProgressLabel").text(SProgressBar.Current + " of " + SProgressBar.Max + suffix);
        if (SProgressBar.Max > 0) {
            $(".SProgressBar .CurrentProgress").css("width", (SProgressBar.Current / SProgressBar.Max * 100) + "%");
            if (SProgressBar.Current === SProgressBar.Max) {
                $(".SProgressBar").css("border", "2px solid #ABF698");
            }
            else {
                $(".SProgressBar").css("border", "1px solid black");
            }
        }
    },
    SucceesHandler: function (data, importType, max, script) {
        if (SProgressBar.StopProgress) {
            $(".SProgressBarXX").hide();
            $(".SProgressBar").hide();
            alert("Progress stopped. Note that this does not reverse any organizations that have already been updated.");
            return;
        }
        if (importType === "role") {
            SProgressBar.Current += 1;

            var bar = $("#pbBar");
            bar.prop("aria-valuenow", SProgressBar.Current);
            bar.css("width", ((SProgressBar.Current / max) * 100) + "%");
        } else {
            SProgressBar.Current = data.Rows;
            $("#pbImport").progressbar({ value: SProgressBar.Current / max * 100 });
        }

        if (SProgressBar.Current >= max || data.Completed) {
            $(".SProgressBarXX").hide();
            $(".SProgressBar").hide();
            eval(script);
            return;
        }
        else {
            $("#pbLabel").text(SProgressBar.Current + " of " + max + " records processed.");

            $.get(SProgressBar.GetHandler(importType), function (d) {
                SProgressBar.SucceesHandler(d, importType, max, script);
            });
        }
    },

    Import: function (importType, max, script) {
        SProgressBar.Current = 0;
        SProgressBar.Max = max;
        SProgressBar.StopProgress = false;

        if (importType === "role") {
            SProgressBar.HandlerToUse = "ProgressRole.axd";

            var bar = $("#pbBar");

            bar.prop("aria-valuemin", 0);
            bar.prop("aria-valuemax", max);
            bar.prop("aria-valuenow", 0);
            bar.css("width", "0");

            $("pbLabel").text("0 of " + max + " companies updated.");
        } else {
            $("#pbImport").progressbar({ value: 0 });
            $("#pbLabel").html("0 of " + max + " records processed.");
        }
        $(".StopProgress").prop("disabled", false);

        $.get(SProgressBar.GetHandler(importType), function (data) {
            SProgressBar.SucceesHandler(data, importType, max, script);
        });
    },

    

    GenericSuccessHandler: function (data, handler, totalRecords, recordLabel, doneScript) {
        if (data.Completed) {
            $(".SProgressBarXX").hide();
            eval(doneScript);
        }
        else {
            $("#pbImport").progressbar({ value: data.Rows / totalRecords * 100 });
            $("#pbLabel").html(data.Rows + " of " + totalRecords + " " + recordLabel + " processed.");

            var d = new Date();
            $.get(handler + "&_time=" + d.getTime(), function (d) {
                SProgressBar.GenericSuccessHandler(d, handler, totalRecords, recordLabel, doneScript);
            });
        }        
    },

    StopProcess : function() {
        SProgressBar.StopProgress = true;
        $("#spnStopped").show();
        $(".StopProgress").prop("disabled", true);
    },

    Handler: function (handler, totalRecords, recordLabel, doneScript) {
        $("#pbImport").progressbar({ value: 0 });
        $("#pbLabel").html("0 of " + totalRecords + " " + recordLabel + " processed.");

        var d = new Date();
        $.get(handler + "&_time=" + d.getTime(), function (d) {
            SProgressBar.GenericSuccessHandler(d, handler, totalRecords, recordLabel, doneScript);
        });        
    }
};


var SRadioButton = {
	Setup: function() {
	    $(document).on('mouseover', '.SRadioButton', function () {
			$(this).addClass('Hover');
			$(this).next('label').addClass('Hover');
	    }).on('mouseout', '.SRadioButton', function () {
			$(this).removeClass('Hover');
			$(this).next('label').removeClass('Hover');
		});
	    $(document).on('mouseover', 'label', function () {
			if ($(this).prev().is('.SRadioButton')) {
				$(this).addClass('Hover');
				$(this).prev().addClass('Hover');
			}
			}).on('mouseout', 'label', function () {
			if ($(this).prev().is('.SRadioButton')) {
				$(this).removeClass('Hover');
				$(this).prev().removeClass('Hover');
			}
		});
	}
};
$(document).ready(function() {
//	SRadioButton.Setup();
});
var SRadioButtonList = {
	Setup: function() {
	    $(document).on('mouseover', '.SRadioButtonList td',function () {
			$(this).addClass('Hover');
	    }).on('mouseout', '.SRadioButtonList td',function () {
			$(this).removeClass('Hover');
		});
	},
	SelectedIndex: function(name) {
		var inputs = $('#' + name).find('input');
		var selectedItem = $('#' + name).find('input:checked');
		return inputs.index(selectedItem);
	},
	SetSelected: function(name, index) {
	    $('#' + name).find('input').prop('checked', false);
	    $('#' + name).find('input:eq(' + index + ')').prop('checked', true);
	}
};

$(document).ready(function() {
//	SRadioButtonList.Setup();
});
var SStateButton = {
	ChangeState: function (btn) {
		if ($(btn).find("img").attr("src") == "img.axd?ico16=delete") {
			$(btn).find("img").attr("src", "img.axd?ico16=ycheck");
			$(btn).find("input").val("1");
		}
		else if ($(btn).find("img").attr("src") == "img.axd?ico16=ycheck") {
			$(btn).find("img").attr("src", "img.axd?ico16=check");
			$(btn).find("input").val("3");
		}
		else if ($(btn).find("img").attr("src") == "img.axd?ico16=check") {
			$(btn).find("img").attr("src", "img.axd?ico16=delete");
			$(btn).find("input").val("0");
		}
	},

	SetState: function (btn, state) {
		$(btn).find("input").val(state);
		if (state == 0) {
			$(btn).find("img").attr("src", "img.axd?ico16=delete");
		}
		else if (state == 1) {
			$(btn).find("img").attr("src", "img.axd?ico16=ycheck");
		}
		else if (state == 3) {
			$(btn).find("img").attr("src", "img.axd?ico16=check");
		}
	}
};
var SInput = {
	IsAlpha: function (keyCode) {
		if ((keyCode >= 97 && keyCode <= 122) || (keyCode >= 65 && keyCode <= 90)) {
			return true;
		}
		return false;
	},
	IsNumeric: function (keyCode) {
		if ((keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105)) {
			return true;
		}
		return false;
	},
	IsOther: function (keyCode) {
		if ([9, 8, 13, 46, 37, 38, 39, 40].indexOf(keyCode) != -1) {
			return true;
		}
		return false;
	}
};

var SInputRestrict =
{
	NumsOnly: function (k) {
		if (SInput.IsNumeric(k) || SInput.IsOther(k)) {
			return true;
		}
		return false;
	},
	AlphaOnly: function (k) {
		var result = false;
		if (SInput.IsAlpha(k) || SInput.IsOther(k)) {
			return true;
		}
		return false;
	},
	AlphaNumeric: function (k) {
		if (SInput.IsNumeric(k) || SInput.IsAlpha(k) || SInput.IsOther(k)) {
			return true;
		}
		return false;
	},
	Restrict: function (k, r) {
		switch (r) {
			case 1:
				return SInputRestrict.NumsOnly(k);
			case 2:
				return SInputRestrict.AlphaOnly(k);
			case 3:
				return SInputRestrict.AlphaNumeric(k);
			default:
				return true;
		}
	}
};

var STextBoxIncDec = {
	Timer: -1,
	Count: 0,
	Last: 0,
	Increment: 1,
	ResetTime: 250,
	Thresholds: [50, 100, 100, 150, 200, 250],
	Increments: [1, 10, 100, 1000, 10000, 100000],
	GetIncrement: function (count) {
		var i = 0;
		for (; i < 6; i++) {
			if (count < STextBoxIncDec.Thresholds[i]) {
				return STextBoxIncDec.Increments[i];
			}
		}
		return STextBoxIncDec.Increments[i];
	},
	IncDec: function (box, keyCode) {
		if (box.value == "") {
			box.value = "0";
		}
		if (this.Timer != -1) {
			clearTimeout(this.Timer);
		}
		this.Increment = this.GetIncrement(this.Count);
		if (keyCode == 38) {
			box.value = parseInt(box.value) + this.Increment;
			//reset count if user switched arrow keys
			if (this.Last == -1) {
				this.Count = 0;
			}
			this.Last = 1;
		}
		else if (keyCode == 40) {
			box.value = parseInt(box.value) - this.Increment;
			//reset count if user switched arrow keys
			if (this.Last == 1) {
				this.Count = 0;
			}
			this.Last = -1;
		}
		this.Count++;
		this.Timer = setTimeout('function(){STextBoxIncDec.Count = 0;}', this.ResetTime);
	}
};

var STextBox = {
	KeyDown: function (evt, options) {
		var box = evt.srcElement;

		if (options.updown) {
			STextBoxIncDec.IncDec(box, evt.keyCode);
		}

		if (options.restrict) {
			return SInputRestrict.Restrict(evt.keyCode, parseInt(options.restrict));
		}
		return true;
	},
	KeyPress: function (evt, options) {
		var box = evt.srcElement;
	},
	SetupWatermark: function () {
	    $(document).on('focus', '.STextBox', function () {
			var water = $(this).attr('watermark');
			if (water != '' && $(this).val() == water) {
				$(this).val('').removeClass('Note');
			}
	    }).on('blur', '.STextBox', function () {
			var water = $(this).attr('watermark');
			if (water != undefined && water != '' && $(this).val() == '') {
				$(this).val(water);
				$(this).addClass('Note');
			}
		});
	}
};

$(document).ready(function () {
	STextBox.SetupWatermark();
	$(document).on('focus', '.STextBox', function () {
		$(this).addClass('HasFocus');
	}).on('blur', '.STextBox', function (){
	    $(this).removeClass('HasFocus');
	});
});
// I am using jquery to process the payment. It knows what form to 
// process it on based on the name 'payment-form'
jQuery(function ($) {
    //payment submission
    $('#charge_form').submit(function (event) {
        var $form = $('#charge_form');

        Stripe.createToken($form, stripeResponseHandler);

        // Prevent the form from submitting with the default action
        return false;
    });
    //if there is a error, it is displayed on the page if there was
    //no error this is where it gets sent to the server.
    var stripeResponseHandler = function (status, response) {
        $('#hdfStripeToken').val('');
        $('#hdfErrorCode').val('');

        //  It is important to clear out all the credit card information
        //  because we must not post any of it back to our server.
        $('.stripeCardType, ' +
            '.stripeCardName, ' +
            '.stripeCardNumber, ' +
            '.stripeCardExpMonth, ' +
            '.stripeCardExpYear, ' +
            '.stripeCardCVC,' +
            '#StripeFormName,' +
            '#StripeFormNumber,' +
            '#StripeFormExpMonth,' +
            '#StripeFormExpYear,' +
            '#StripeFormCVC').val('');

        if (response.error) {
            //  Post back error code so the form can highlight the bad field
            $('#hdfErrorCode').val(response.error.code || response.error.type || "unspecified_error");
            $('#btnStripePostback').click();

        } else {
            var token = response.id;

            $('#hdfStripeToken').val(token);
            $('#btnStripePostback').click();
        }
    };
});

(function ($) {
    var g_interval = null;
    var g_progressbar = null;
    var g_upload = null;

    function Progress() {
        $.ajax({
            type: "POST",
            url: "../../Services/Status.asmx/GetUploadStatus",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            data: "{ fid: '" + g_upload + "' }",
            success: function (data) {
                var status = data.d;

                if (status != null) {
                    g_progressbar.find(".Bar").css({ width: (status.Read / status.Total * 100) + '%' });
                    g_progressbar.find(".Label").text("Uploaded " + status.Read + " of " + status.Total + " bytes.");
                }
            }
        });
    }

    $.fn.uploader = function (fileid, options) {
        var empty = {};
        var defaults = { autoSubmit: false, tempFile: false, onComplete: null };
        var settings = $.extend(empty, defaults, options);

        this.each(function () {
            var progressbar = $(this).children("div");
            var input = $(this).children("input");

            new AjaxUpload($(this).children("button"), {
                action: "ajaxupload.axd?fid=" + fileid + "&mode=db&temp=" + (settings.tempFile ? "1" : "0"),
                autoSubmit: settings.autoSubmit,
                onSubmit: function (file, extension) {
                    // Only one file can be uploading at a time.
                    if (g_interval != null) {
                        return false;
                    }

                    // The progress bar should be centered on the screen
                    progressbar.css({ left: '0px', top: '0px', width: $(window).width(), height: $(window).height() }).show();
                    progressbar.children("div:last").css({
                        top: ($(window).height() - progressbar.children("div:last").outerHeight()) / 2,
                        left: ($(window).width() - progressbar.children("div:last").outerWidth()) / 2
                    });

                    // Start the routing which will poll the progress displaying the results to the user
                    g_progressbar = progressbar;
                    g_interval = setInterval(Progress, 100);
                    g_upload = fileid;

                    return true;
                },
                onComplete: function (file, response) {
                    // The file has been upldated. Stop the routing montering the progress and hide the progress bar.
                    clearInterval(g_interval);
                    g_progressbar.hide();
                    g_interval = null;

                    input.val(fileid);

                    if (settings.onComplete != null) {
                        settings.onComplete.call(this, fileid, file, response);
                    }
                }
            });
        });
    };
})(jQuery);
var SWizard = {
	Next: function (wizardId) {
		var wizard = $('#' + wizardId);
		var steps = wizard.find('.SWizardStep');
		var curStep = wizard.find('.SWizardStep:visible');
		var index = steps.index(curStep);
		SWizard.SetStep(wizardId, index + 1);
	},

	Previous: function (wizardId) {
		var wizard = $('#' + wizardId);
		var steps = wizard.find('.SWizardStep');
		var curStep = wizard.find('.SWizardStep:visible');
		var index = steps.index(curStep);
		SWizard.SetStep(wizardId, index - 1);
	},

	Done: function (wizardId) {

	},

	SetStep: function (wizardId, index) {
		var wizard = $('#' + wizardId);
		var steps = wizard.find('.SWizardStep');
		var next = wizard.find('button[id$=btnWizardNext]');
		var done = wizard.find('button[id$=btnWizardDone]');
		var prev = wizard.find('button[id$=btnWizardPrevious]');
		var hfCurStep = wizard.find('input[id$=hfCurStep]');
		if ((index + 1) == steps.length) {
			next.hide();
			done.show();
		}
		else {
			next.show();
			done.hide();
		}
		if (index == 0) {
			prev.hide();
		}
		else {
			prev.show();
		}
		hfCurStep.val(index);
		steps.hide(0, function () {
			steps.eq(index).show();
		});
	}
};
var SucceedTabs = {
    KeyHandlesSet: false,
    Maximize: function (tabId, tabTop) {
        var tab = $('#' + tabId);
        var fcon = tab.find('.STabFrameDiv');
        var newTop = tab.find('table:first').height();

        tab.css({ position: 'absolute', top: tabTop, left: '5px', right: '5px', bottom: '5px' });
        fcon.css({ position: 'absolute', top: newTop, bottom: '0px', left: '0px', right: '0px' });

        setTimeout(function () { SucceedTabs.MaximizePanels(); }, 200);
        $(window).resize(function () {
            SucceedTabs.MaximizePanels();
        });
    },
    MaximizePanels: function () {
        $('.STabIFrame, .STabPanel').each(function () {
            var container = $(this).parent().parent();
            var panelHeight = container.height() > MainWindow.MinIFrameHeight ? container.height() : MainWindow.MinIFrameHeight;
            $(this).css('height', panelHeight);
        });
    },
    Activate: function (tabId, index, url, effects, callback, frameId) {
        var tab = $('#' + tabId);
        var container = tab.children("." + frameId);
        var panels = container.children().children('.STabIFrame, .STabPanel');
        var panel = panels.eq(index);

        var numPanels = panels.length;

        //set the url of the iframe
        if (url != null && url.length > 0) {
            var currUrl = panel.attr('src');
            if (currUrl == null || currUrl.length == 0 || currUrl.indexOf('Loading.aspx') > -1) {
                panel.attr('src', url);
            }
        }

        //show the active panel
        if (effects == 0 ) {

            // IE 10 (version 10.0.9200.16576) in Windows 7 crashes sporadically when switching tabs in a COI. This 
            // timeout before showing the tab seems to fix the problem but I have no idea why. It's a sad hack :'(
            setTimeout(function () { panel.show(); }, 50);
            panels.not(panel).hide();

            if (callback != null) { callback.call(); }
        }
        else if (effects == 1) {
            var slider = $('#' + framecontainer + ' #divSlider');

            container.css('width', tab.width()).css('height', panels.outerHeight());
            panels.each(function () {
                $(this).css('width', tab.width());
            });
            slider.css('width', numPanels * panels.outerWidth());
            slider.animate({ marginLeft: index * -1 * panels.outerWidth() }, 400, "swing", callback);
        }
        else if (effects == 2) {
            container.css({ position: 'relative', top: '0px', left: '0px' });
            panels.each(function () {
                $(this).css({ position: 'absolute', top: '0px', left: '0px', width: '100%' });
            });
            panels.not(panel).fadeOut();
            panel.fadeIn(callback);
        }
        else {
            alert('Not Implemented');
        }
    },
    SetHover: function () {
        $(document).on('mouseover', '.STabItem', function () {
            $('.STabItem').removeClass('STabItemHover');
            if (!$(this).hasClass('STabDisabled')) {
                $(this).addClass('STabItemHover');
            }
        }).on('mouseout', '.STabItem', function () {
            $(this).removeClass('STabItemHover');
        });
    },
    FixWidths: function (tabId, frameId) {
        
    }
};
$(document).ready(function() {
	SucceedTabs.SetHover();
});

(function (control) {
    control.onClick = function (btn, index) {
        var tab = btn.parent().parent().parent();
        var curIndex = tab.data("index");

        if (index != curIndex) {
            switchTab(tab, index, curIndex);
        }
    };

    //control.onNext = function(btn) {
    //    var tab = btn.parent().parent().parent();
    //    var curIndex = tab.data("index");
    //    var tabs = tab.data("tabs");

    //    var index = curIndex + 1;
    //    if (index < tabs) {
    //        var li = switchTab(tab, index, curIndex);
    //        li.children("div").hide();
    //        li.children("a").show();
    //    }
    //};

    //control.onPrev = function (btn) {
    //    var tab = btn.parent().parent().parent();
    //    var index = tab.data("index");

    //    if (index > 0) {
    //        switchTab(tab, index - 1, index);
    //    }
    //};

    function switchTab(tabs, index, prevTab) {
        var nav = tabs.children(".nav").children();
        var panels = tabs.children("div").first().children("div");

        panels.css("display", "none");
        panels.eq(index).css("display", "block");

        nav.removeClass("active");
        var li = nav.eq(index).addClass("active");

        nav.eq(prevTab).addClass("inactive");
        tabs.data("index", index);

        return li;
    }
}(window.tabs = window.tabs || {}));
/*
@author: remy sharp / http://remysharp.com
@params:
feedback - the selector for the element that gives the user feedback. Note that this will be relative to the form the plugin is run against.
hardLimit - whether to stop the user being able to keep adding characters. Defaults to true.
useInput - whether to look for a hidden input named 'maxlength' instead of the maxlength attribute. Defaults to false.
words - limit by characters or words, set this to true to limit by words. Defaults to false.
@license: Creative Commons License - ShareAlike http://creativecommons.org/licenses/by-sa/3.0/
@version: 1.2
@changes: code tidy via Ariel Flesler and fix when pasting over limit and including \t or \n
*/

(function ($) {

    $.fn.maxlength = function (settings) {

        if (typeof settings == 'string') {
            settings = { feedback: settings };
        }

        settings = $.extend({}, $.fn.maxlength.defaults, settings);

        function length(el) {
            var parts = el.value;
            if (settings.words)
                parts = el.value.length ? parts.split(/\s+/) : { length: 0 };
            return parts.length;
        }

        return this.each(function () {
            var field = this,
        	$field = $(field),
        	$form = $(field.form),
        	limit = settings.maxLength > 0 ? settings.maxLength : settings.useInput ? $form.find('input[name=maxlength]').val() : $field.attr('maxlength'),
        	$charsLeft = $form.find(settings.feedback);

            function limitCheck(event) {
                var len = length(this),
        	    exceeded = len >= limit,
        		code = event.keyCode;

                if (!exceeded)
                    return;

                switch (code) {
                    case 8:  // allow delete
                    case 9:
                    case 17:
                    case 36: // and cursor keys
                    case 35:
                    case 37:
                    case 38:
                    case 39:
                    case 40:
                    case 46:
                    case 65:
                        return;

                    default:
                        return settings.words && code != 32 && code != 13 && len == limit;
                }
            }


            var updateCount = function () {
                var len = length(field),
            	diff = limit - len;

                $charsLeft.html(diff || "0");

                // truncation code
                if (settings.hardLimit && diff < 0) {
                    field.value = settings.words ?
                    // split by white space, capturing it in the result, then glue them back
            		field.value.split(/(\s+)/, (limit * 2) - 1).join('') :
            		field.value.substr(0, limit);

                    updateCount();
                }
            };

            $field.keyup(updateCount).change(updateCount);
            if (settings.hardLimit) {
                $field.keydown(limitCheck);
            }

            updateCount();
        });
    };

    $.fn.maxlength.defaults = {
        useInput: false,
        hardLimit: true,
        feedback: '',
        maxLength: 0,
        words: false
    };

})(jQuery);
var WeeklyEmail = {
	CurrentContainer: '',
	EditingDefault: function() {
		$(WeeklyEmail.CurrentContainer + ' .LibraryAdditions td').hide();
		$(WeeklyEmail.CurrentContainer + ' .SoftwareAdditions td').hide();
		$(WeeklyEmail.CurrentContainer + ' .TrainingShort td').hide();
		$(WeeklyEmail.CurrentContainer + ' .ExtraSpacer td').hide();
	},
	EditingWeek: function() {
		$(WeeklyEmail.CurrentContainer + ' .LibraryAdditions td').show();
		$(WeeklyEmail.CurrentContainer + ' .SoftwareAdditions td').show();
		$(WeeklyEmail.CurrentContainer + ' .TrainingShort td').show();
		$(WeeklyEmail.CurrentContainer + ' .ExtraSpacer td').show();
	},
	IsAdmin: function(){
		$(WeeklyEmail.CurrentContainer + ' #divIntroFooterLinks').hide();
		$(WeeklyEmail.CurrentContainer + ' #trNoSend td').hide();
	},
	IsManager: function() {
		$(WeeklyEmail.CurrentContainer + ' #divIntroFooterLinks').hide();
		$(WeeklyEmail.CurrentContainer + ' #divSubject').show();
		$(WeeklyEmail.CurrentContainer + ' #trNoSend td').show();
	},
	UpdateAllVis: function() {
	    WeeklyEmail.ToggleMessage();
	    WeeklyEmail.ToggleTrainingShorts();
		WeeklyEmail.ToggleWebinars();
		WeeklyEmail.ToggleMarketing();
		WeeklyEmail.ToggleLibraryAdditions();
		WeeklyEmail.ToggleNewResources();
	},
	ToggleMessage: function() {
		var chk = $(WeeklyEmail.CurrentContainer + ' .HideMessageCheckbox input');
		WeeklyEmail.__ShowHide('#divMessageContainer', !chk.prop('checked'));
		WeeklyEmail.__ShowHide('#spnMessageHidden', chk.prop('checked'));
	},
	ToggleTrainingShorts: function () {
	    var chk = $(WeeklyEmail.CurrentContainer + ' .HideTrainingShortsCheckbox input');
	    WeeklyEmail.__ShowHide('#divTrainingShortContainer', !chk.prop('checked'));
	    WeeklyEmail.__ShowHide('#spnTrainingShortHidden', chk.prop('checked'));
	},
	ToggleWebinars: function() {
		var chk = $(WeeklyEmail.CurrentContainer + ' .HideWebinarsCheckbox input');
		WeeklyEmail.__ShowHide('#divWebinar', !chk.prop('checked'));
		WeeklyEmail.__ShowHide('#spnWebinarHidden', chk.prop('checked'));
	},
	ToggleMarketing: function() {
		var chk = $(WeeklyEmail.CurrentContainer + ' .HideMarketingCheckbox input');
		WeeklyEmail.__ShowHide('#divMarketingTitle', !chk.prop('checked'));
		WeeklyEmail.__ShowHide('#divMarketingMessage', !chk.prop('checked'));
		WeeklyEmail.__ShowHide('#spnMarketingMessageHidden', chk.prop('checked'));
	},
	ToggleLibraryAdditions: function() {
		var chk = $(WeeklyEmail.CurrentContainer + ' .HideLibraryCheckbox input');
		WeeklyEmail.__ShowHide('#divLibraryAdditions', !chk.prop('checked'));
		WeeklyEmail.__ShowHide('#spnLibraryAdditionsHidden', chk.prop('checked'));
	},
	ToggleNewResources: function() {
		var chk = $(WeeklyEmail.CurrentContainer + ' .HideNewResourcesCheckbox input');
		WeeklyEmail.__ShowHide('#divNewResources', !chk.prop('checked'));
		WeeklyEmail.__ShowHide('#spnNewResourcesHidden', chk.prop('checked'));
	},
	SetContainer: function(name) {
		WeeklyEmail.CurrentContainer = '#' + name;
	},
	__ShowHide: function(id, show) {
		if (show) {
			$(id).slideDown();
		}
		else {
			$(id).slideUp();
		}
	}
}