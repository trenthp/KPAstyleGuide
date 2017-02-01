Namespace("Kpa.Hrm.Web", function () {
    window.Kpa.Hrm.Web.Common = (function ($) {
        // Private
        var defaults = {
            className: "alert-danger",
            dismiss: true,
            fade: true
        };

        var self = {
            createAlert: function (opts) {
                /// <summary>Creates an alert jQuery wrapper for a DOM element with the specified content.</summary> 
                /// <param name="opts" type="object" optional="true">
                /// An options object which allows overriding the following default settings: 
                /// • object content: null 
                /// • string className: "alert-danger" 
                /// • bool dismiss: true 
                /// • bool fade: true 
                /// </param>
                /// <returns type="jQuery" />
                opts = $.extend(defaults, opts);

                var $alert = $("<div />").addClass("alert " + opts.className).attr("role", "alert");

                if (opts.dismiss === true) {
                    $alert.addClass("alert-dismissable");

                    $("<button />")
                        .addClass("close")
                        .attr({
                            "data-dismiss": "alert",
                            "aria-label": "close"
                        })
                        .append("<span aria-hidden=\"true\">&times;</span>")
                        .appendTo($alert);

                    if (opts.fade === true)
                        $alert.addClass("fade in");
                }

                if (typeof opts.content === "string") {
                    $("<p />").html(opts.content).appendTo($alert);
                } else {
                    $alert.append(opts.content);
                }

                return $alert;
            }
        };

        return self;
    }(jQuery));
});

// Deprecated garbage below

/***************************
xb: test the one global object pattern for javascript. 
*************************/

//xiaobing: one global variable added to the project
var HRM = {};

HRM.resetValidation = function () {

    //Removes validation from input-fields
    //$('.input-validation-error').addClass('input-validation-valid');
    //$('.input-validation-error').removeClass('input-validation-error');
    //Removes validation message after input-fields
    //$('.field-validation-error').addClass('field-validation-valid');
    //$('.field-validation-error').removeClass('field-validation-error');
    //Removes validation summary 
    //$('.validation-summary-errors').addClass('validation-summary-valid');
    //$('.validation-summary-errors').removeClass('validation-summary-errors');


    $('.field-validation-error').empty();
    //$('.validation-summary-errors').empty();

    return 0;

};

//xiaobing: function to clear form elements
HRM.clearFormElements = function (ele) {

    $(ele).find(':input').each(function () {
        switch (this.type) {
            case 'password':
            case 'select-multiple':
            case 'text':
            case 'textarea':
                $(this).val('');
                break;
            case 'select-one':
                $(this).prop('selectedIndex', 0);
                break;
            case 'checkbox':
            case 'radio':
                this.checked = false;
        } 
    });

};


HRM.clearNonDisabledFormElements = function (ele) {

    $(ele).find(':input:not(:disabled)').each(function () {
        switch (this.type) {
            case 'password':
            case 'select-multiple':
            case 'select-one':
            case 'text':
            case 'textarea':
                $(this).val('');
                break;
            case 'checkbox':
            case 'radio':
                this.checked = false;
        }
    });

};

//To show message, create a div in view as following
//<div id="message" class="alert alert-success" style="display: none"></div>
HRM.clearFormElements_ResetValidation = function (ele) {
    HRM.clearFormElements(ele);
    HRM.resetValidation();
};

HRM.clearNonDisabledFormElements_ResetValidation = function (ele) {
    HRM.clearNonDisabledFormElements(ele);
    HRM.resetValidation();
};

HRM.movePageUp = function () {
    $('html, body').animate({ scrollTop: 0 }, 'slow');
};

HRM.showMessage = function (message) {
    jQuery('div#message').html(message).show();
    HRM.movePageUp();
};

HRM.showMessageNoMove = function (message) {
    jQuery('div#message').html(message).show();
};

HRM.showMessageAndHide = function (message) {
    jQuery('div#message').html(message).show();
    HRM.movePageUp();
    setTimeout(function () {
        $('div#message').fadeOut('slow', function () {
            $('div#message').empty();
        });
    }, 2000);
};

HRM.showMessageAtBottomAndHide = function (message) {
    $('div#message')
        .html(message)
        .show()
        .delay(2000)
        .fadeOut('slow', function() {
            $(this).empty();
        });
};

HRM.showMessageAtBottomAndHideDismissable = function (message) {
    $('div#message')
        .html(message)
        .show();

};

HRM.autoRemoveMessage = function () {
    $('.jqrValidationTarget').change(function () {
        jQuery('div#message').html('').hide();
    });
};

HRM.hideMessage = function () {
    $('div#message')
        .fadeOut('slow', function () {
            $(this).empty();
        });
};

HRM.addAntiForgeryToken = function (data) {
    data.__RequestVerificationToken = $('input[name=__RequestVerificationToken]').val();
    return data;
};

HRM.checkUndefined = function (x) {
    if (x === undefined)
        return 0;
    if (x == 'undefined')
        return 0;
    return x;
};