(function() {
    $(Kpa.Hrm.Web.DOMObserver.initialize);

    // Attach global anti-forgery wire-up for AJAX calls
    $(document).ajaxSend(function(e, xhr, opts) {
        if (opts.type.toUpperCase() == "POST" && !opts.crossDomain) {
            var $aft = $('input[name^="__RequestVerificationToken"]').first();

            // Converts data if not already a string
            if (opts.data && typeof opts.data !== "string") {
                opts.data = $.param(opts.data);
            }

            // Detect initial empty payload and compensate for jQuery failings
            if (!opts.data) {
                opts.data = "";
                xhr.setRequestHeader("Content-Type", opts.contentType);
            }

            // Add token value to data if not present
            if (opts.data.indexOf("__RequestVerificationToken") == -1) {
                opts.data += (opts.data ? "&" : "") + $aft.serialize();
            }
        }
    });

    // Global AJAX error handling
    $(document).ajaxError(function(e, jqXhr) {
        switch (parseInt(jqXhr.status)) {
        case 401:
            window.location = "/Account/UserTimeOut?returnUrl=" + encodeURIComponent(window.location.pathname + window.location.search);
            break;
        case 403:
            window.location = "/Error/AccessDenied";
            break;
        case 500:
            var $alert = $(".hrm-ajax-error").removeClass("hide");
            $alert.children("p, pre").slice(1).remove();
            var errorModel = null;
            try {
                errorModel = JSON.parse(jqXhr.responseText);
            } catch (ex) {
                // Swallow attempted parse exceptions
            }
            if (errorModel && errorModel.ShowErrorDetail) {
                $("<p />").append($("<strong />").html(errorModel.ExceptionType + ": " + errorModel.ExceptionMessage.replace(/\n/g, "<br />"))).appendTo($alert);
                $("<pre />").html(errorModel.ExceptionStackTrace).appendTo($alert);
            }
            setTimeout(function() {
                $alert.addClass("in");
            }, 0);
            break;
        default:

        }
    });

    $(function() {
        $(".hrm-ajax-error button.close").click(function() {
            var $alert = $(this).closest(".hrm-ajax-error").removeClass("in");
            setTimeout(function() {
                $alert.addClass("hide");
            }, 150);
        });
    });
}());