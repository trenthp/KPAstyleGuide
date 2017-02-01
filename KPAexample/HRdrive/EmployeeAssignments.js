function GetEmployeeAssignments(personId, evaluators, disciplinarians, terminators) {
    $.ajax({
        url: "/PerformanceManagement/GetEmployeesAssignments",
        data: {
            personId: personId,
            evaluators: evaluators,
            disciplinarians: disciplinarians,
            terminators: terminators
        }, cache: false,
        success: function (data) {
            var $form = $(data);

            var buttons = {
                Close: {
                    className: "btn-default"
                }
            };

            bootbox.dialog({
                title: "Evaluator Assignments",
                message: $form,
                show: true,
                closeButton: true,
                buttons: buttons
            });
        }
    });
}



function GetEvaluatorAssignments(personId) {
    ShowFancyBoxWork();
    $.ajax({
        url: "/Person/GetEvaluatorAssignments",
        data: {
            personId: personId
        },
        complete: HideFancyBoxWork,
        cache: false,
        success: function (data) {
            var $form = $(data);

            var buttons = {
                Close: {
                    className: "btn-default"
                }
            };

            bootbox.dialog({
                title: "Evaluator Assignments",
                message: $form,
                show: true,
                closeButton: true,
                buttons: {
                    Save: {
                        className: "btn-success",
                        callback: function () {
                            $("#evaluatorAssignments").submit();
                            return false;
                        }
                    },
                    Close: {
                        className: "btn-default"
                    }
                }
            });
        }
    });
}