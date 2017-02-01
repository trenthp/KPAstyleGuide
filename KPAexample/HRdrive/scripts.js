function BindSelect2() {
    var $selects = $(this);

    // Single-select dropdowns require a completely blank option element to enable placeholders
    $selects.not("[multiple]").each(function () {
        var $this = $(this),
            $placeholder = $this.children('[value=""]');

        if ($placeholder.length) {
            $this.attr("data-placeholder", $placeholder.text().trim());
            $placeholder.text("");
        }
    });

    try {
        $selects
            .each(function(i, el) {
                var $this = $(el);

                var opts = {
                    minimumResultsForSearch: 20
                };

                if (!$this.is("[data-val-required]")) {
                    opts.allowClear = true;
                }

                $this.select2(opts);
            })
            .focus(function() {
                $(this).select2("focus"); // Ironically not handled by base functionality
            });
    }
    catch(err) {}
}

function SetTinyMceValidation(selector) {
    $(selector).closest("form").on("invalid-form", function () {
        var self = this;

        // Defer handler until after validation processing has completed
        setTimeout(function () {
            // Apply error classes as needed to container aliases
            $(selector, self).each(function () {
                var $this = $(this);
                var $editor = $this.siblings(".mce-container").removeClass("input-validation-error");

                if ($this.hasClass("input-validation-error")) {
                    $editor.addClass("input-validation-error");
                }
            });
        }, 0);
    });
}

function calculateServerLength(str) {
    ///<summary>Calculate actual string length on server based on Windows' combined carriage return/line feed breaks.</summary>
    ///<param name="str">The string whose server length is to be calculated.</param>
    ///<returns type="int" />
    return str.length + str.split("\n").length - 1;
}

function GetTinyMceSettings(selector) {
    return {
        selector: selector,
        theme: "modern",
        height: 320,
        plugins: "advlist,anchor,autolink,charmap,code,contextmenu,directionality,hr,image,insertdatetime,link,lists,media,nonbreaking,paste,preview,print,searchreplace,table,textcolor",
        toolbar1: "newdocument | formatselect fontselect fontsizeselect | bold italic underline | forecolor backcolor | code",
        toolbar2: "undo redo | cut copy paste pastetext | bullist numlist | outdent indent | alignleft aligncenter alignright alignjustify | searchreplace | preview",
        browser_spellcheck: true,
        paste_data_images: true,
        setup: function(ed) {
            var $el = $(ed.getElement());
            var lastKeyup = null;

            var characterLimit = $el.data("valLengthMax");

            ed.on("init", function() {
                // Ensure the source text field is not ignored for validation by removing CSS display: none from plugin
                $el.removeAttr("style");

                if (characterLimit) {
                    var statusbar = ed.theme.panel && ed.theme.panel.find('#statusbar')[0];
                    if (statusbar) {
                        setTimeout(function() {
                            statusbar.insert({
                                type: 'label',
                                name: 'charactercount',
                                text: ['Markup Characters Remaining: {0}', characterLimit - calculateServerLength(ed.getContent())],
                                classes: 'wordcount',
                                disabled: ed.settings.readonly
                            }, 0);
                        }, 0);
                    }
                }
            });

            if (characterLimit) {
                ed.on("keyup change", function() {
                    if (lastKeyup) {
                        clearTimeout(lastKeyup);
                    }

                    lastKeyup = setTimeout(function() {
                        var remaining = characterLimit - calculateServerLength(ed.getContent());
                        var label = ed.theme.panel.find('#charactercount').text(['Markup Characters Remaining: {0}', remaining]).removeClass("hrm-character-overflow");
                        if (remaining < 0) {
                            label.addClass("hrm-character-overflow");
                        }
                    }, 350);
                });
            }
        }
    };
}

(function() {
    var initializeSelect2 = function() {
        var select2Selector = "select:not(.select2-offscreen):not(.hrm-select2-ignore)";

        // Bind full document initially
        BindSelect2.call($(select2Selector));

        // Bind dynamically inserted content (i.e. AJAX views)
        Kpa.Hrm.Web.DOMObserver.listenOnAdded("select:not(.select2-offscreen):not(.hrm-select2-ignore)", BindSelect2);

        // Collapse and accordion handling
        $(document)
            .on("show.bs.collapse", ".hrm-accordion", function() {
                $(this).removeClass("hrm-collapse");
            })
            .on("hide.bs.collapse", ".hrm-accordion", function() {
                $(this).addClass("hrm-collapse");
            });

        $(".hrm-timepicker").kendoTimePicker().closest(".k-timepicker").addClass("form-control");

        Kpa.Hrm.Web.DOMObserver.listenOnAdded("input.hrm-timepicker:not([data-role=timepicker])", function() {
            $(this).kendoTimePicker().closest(".k-timepicker").addClass("form-control");
        });
    }

    var initializeTinyMce = function () {
        var selector = ".hrm-rich-text-editor";
        tinymce.init(GetTinyMceSettings(selector));
        SetTinyMceValidation(selector);
    };

    $(function() {
        initializeSelect2();
        initializeTinyMce();
    });
}());