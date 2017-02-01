$(document).ready(function () {
    $("#grid").kendoGrid({
        navigatable: true,
        scrollable: true,
        sortable: true,
        pageable: {
            pageSize: 20,
            pageSizes: true,
            buttonCount: 5
        },
        filterable: {
            extra: false,
            operators: {
                string: {
                    contains: "Contains",
                    eq: "Equal to"
                }
            }
        },
        resizeable: true,
        editable: true,
        toolbar: ["save", "cancel"],
        dataSource: {
            transport: {
                read: {
                    url: "/Toolkit/PerformanceManagement/GetAssignmentsEmployeeList",
                    data: { evaluatorId: $('#SelectedPersonId').val() },
                    dataType: "json",
                    batch: true,
                    pageSize: 20,
                    cache: false
                },
                update: {
                    url: "/Toolkit/PerformanceManagement/UpdateAssignments",
                    type: "GET"
                }
            },
            requestStart: function () {
                $.fancybox.showLoading();
            },
            requestEnd: function () {
                $.fancybox.hideLoading();
            },
            schema: {
                model: {
                    id: "PersonID",
                    fields: {
                        PersonID: { editable: false },
                        NameF: { editable: false },
                        NameL: { editable: false },
                        Departments: { editable: false },
                        Positions: { editable: false },
                        CompanyName: { editable: false },
                        Managers: { editable: false }
                    }
                }
            }
        },
        columns: [{
            field: "PersonID",
            hidden: true
        }, {
            field: "EvaluatorId",
            hidden: true
        },
        
        {
            field: "NameL",
            title: "Last Name",
            width: 100,
            attributes: { style: "font-size: 10px;" },
            headerAttributes: { style: "font-size: 11px;" }
        },
        {
            field: "NameF",
            title: "First Name",
            width: 100, attributes: { style: "font-size: 10px;" },
            headerAttributes: { style: "font-size: 11px;" }
        } 
       ,
        {
            field: "Positions",
            title: "Position",
            width: 150,
         
            attributes: { style: "font-size: 10px;" },
            headerAttributes: { style: "font-size: 11px;" }
        },
        {
            field: "Departments",
            title: "Department",
            width: 150,
            attributes: { style: "font-size: 10px;" },
            headerAttributes: { style: "font-size: 11px;" }
        },{
              field: "Managers",
              title: "Reports To",
              width: 150,
              attributes: { style: "font-size: 10px;" },
              headerAttributes: { style: "font-size: 11px;" }
          },
        {
            field: "CompanyName",
            title: "Company Name",
            width: 100,
            attributes: { style: "font-size: 10px;" },
            headerAttributes: { style: "font-size: 11px;" }
        },
        {
            template: "<input type='checkbox' name='CanEvaluate' title='#= DispEvalMsg ? EvalMsg  : '' #'  data-bind='checked: CanEvaluate'#= EvalsDisabled ? disabled='disabled' : '' # #= CanEvaluate ? checked='checked' : '' # class='CanEvaluate' /> <a href='\\#' style='margin-left:2px;font-size: 12px;font-weight: bold;' class='ViewEvaluators' data-PersonID='#=PersonID#'>Details</a>",
            title: "<input id='checkAllEvaluators', type='checkbox', class='check-box' /> Performance Evaluations ",
            width: 50,
            attributes: { style: "font-size: 10px;" },
            headerAttributes: { style: "font-size: 11px;" }
        },
        {
            template: "<input type='checkbox' name='CanDiscipline' title='#= DispDisActMesg ? DisActMesg  : '' #'  data-bind='checked: CanDiscipline'#= DisActDisabled ? disabled='disabled' : '' # #= CanDiscipline ? checked='checked' : '' # class='CanDiscipline' /> <a href='\\#' style='margin-left:2px;font-size: 12px;font-weight: bold;' class='ViewDisciplinarians' data-PersonID='#=PersonID#'>Details </a>",
            title: "<input id='checkAllDisciplinaryActions', type='checkbox', class='check-box' /> Disciplinary Actions ",
            width: 50,
            attributes: { style: "font-size: 10px;" },
            headerAttributes: { style: "font-size: 11px;" }
        },
        {
            template: "<input type='checkbox' name='CanTerminate'  title='#= DispTermMsg ? TermMsg  : '' #'       data-bind='checked: CanTerminate'   #= TermiDisabled ? disabled='disabled' : '' # #= CanTerminate ? checked='checked' : '' # class='CanTerminate' /> <a href='\\#' style='margin-left:2px;font-size: 12px;font-weight: bold;' class='ViewTerminators' data-PersonID='#=PersonID#'>Details </a>",
            title: "<input id='checkAllTerminations', type='checkbox', class='check-box' /> Terminations " ,
            width: 50,
            attributes: { style: "font-size: 10px;" },
            headerAttributes: { style: "font-size: 11px;" }
        }]
    });

    
});
 
$(document).on("change", "#checkAllEvaluators", function () {
    var state = $(this).is(':checked');
        var grid = $('#grid').data().kendoGrid;
        $.each(grid.dataSource.view(), function () {
            if (this['EvalsDisabled'] != true) {
                if (this['CanEvaluate'] != state)
                    this.dirty = true;
                this['CanEvaluate'] = state;
            }
        });
        grid.refresh();
        
}).on("change", "#checkAllTerminations", function (e) {
        var state = $(this).is(':checked');
        var grid = $('#grid').data().kendoGrid;
        $.each(grid.dataSource.view(), function () {
            if (this['TermiDisabled'] != true) {
                if (this['CanTerminate'] != state)
                    this.dirty = true;
                this['CanTerminate'] = state;
            }
        });
        grid.refresh();

}).on("change", "#checkAllDisciplinaryActions", function (e) {
        var state = $(this).is(':checked');
        var grid = $('#grid').data().kendoGrid;
        $.each(grid.dataSource.view(), function () {
            if (this['DisActDisabled']!= true) {
                if (this['CanDiscipline'] != state)
                    this.dirty = true;
                this['CanDiscipline'] = state;
            }
        });
        grid.refresh();

                })
    .on('change', '#SelectedPersonId', function () {
        $('#grid').data('kendoGrid').dataSource.read({ evaluatorId: $('Select#SelectedPersonId').val() });
        $('#grid').data('kendoGrid').refresh();
    }).on('change', '#SelectedCompanyId', function () {
        $.ajax({
            url: "/PerformanceManagement/GetEmployeesForAssignmentsJson",
            type: "post",
            data: { selectedCompanyId: $('Select#SelectedCompanyId').val() },
            dataType: "Json",
            beforeSend: $.fancybox.showLoading,
            complete: $.fancybox.hideLoading,
            cache: false,
            success: function (data) {
                 
                var $this = $("#SelectedPersonId");
                $this.empty();
                $.each(data, function (i, sli) {

                    var $option = $("<option />")
                        .text(sli.Text)
                        .attr({
                            value: sli.Value,
                            selected: sli.Selected
                        });
                    $option.appendTo($this);

                });
                $this.select2();
                  $('#grid').data('kendoGrid').dataSource.read({ evaluatorId: $('Select#SelectedPersonId').val() });
                  $('#grid').data('kendoGrid').refresh();
            },

            error: function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                alert(thrownError);
            }
        });
      
      
    }).on("change", "input.CanEvaluate", function (e) {
            var grid = $("#grid").data("kendoGrid"),
            dataItem = grid.dataItem($(e.target).closest("tr"));
            dataItem.set("CanEvaluate", this.checked);
    }).on("change", "input.CanTerminate", function (e) {
        var grid = $("#grid").data("kendoGrid"),
        dataItem = grid.dataItem($(e.target).closest("tr"));
        dataItem.set("CanTerminate", this.checked);
    }).on("change", "input.CanDiscipline", function (e) {
        var grid = $("#grid").data("kendoGrid"),
        dataItem = grid.dataItem($(e.target).closest("tr"));
        dataItem.set("CanDiscipline", this.checked);
    }).on("click", "a.ViewEvaluators", function (e) {
        var personId =$(this).attr('data-personid');
        GetEmployeeAssignments(personId, true, false, false);
    }).on("click", "a.ViewTerminators", function (e) {
        var personId = $(this).attr('data-personid');
        GetEmployeeAssignments(personId, false, false, true);
    }).on("click", "a.ViewDisciplinarians", function (e) {
        var personId = $(this).attr('data-personid');
        GetEmployeeAssignments(personId, false, true, false);
    });

 


