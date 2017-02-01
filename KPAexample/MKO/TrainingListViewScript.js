var attendList = null;

function GetAssociatedStudents(trainingId, accountId, facilityURL) {
    beginRequest();
    $('#trainingIdHidden').val(trainingId);

    if (facilityURL != null && facilityURL != '') {
        $('#facilityUserManagementLink').attr("href", facilityURL);
    }

    Kpa.AdminWeb.Services.OnsiteTrainingService.GetAssociatedStudents(trainingId, accountId, GetAssociatedStudentsCallback, FailedCallback);
}

function GetAssociatedStudentsCallback(result, eventArgs) {
    attendList = Sys.Serialization.JavaScriptSerializer.deserialize(result);

    $('#associatedUserList').find("tr:gt(0)").remove();

    for (var i = 0; i < attendList.length; i++) {
	    var positionString = "";
		if (attendList[i].Position) {
			positionString = " (" + attendList[i].Position + ") ";
		}

        if (i % 2) {
            $('#associatedUserList').append('<tr class="alt"><td>' + attendList[i].FirstName + ' ' + attendList[i].LastName + positionString +
				'</td><td style="text-align:center;"><input id=chk_' + attendList[i].StudentId + ' type="checkbox" /></td></tr>');
        } else {
        	$('#associatedUserList').append('<tr><td>' + attendList[i].FirstName + ' ' + attendList[i].LastName + positionString +
				'</td><td style="text-align:center;"><input id=chk_' + attendList[i].StudentId + ' type="checkbox" /></td></tr>');
        }

        var chk = $('#chk_' + attendList[i].StudentId);
        if (chk) {
            chk.prop('checked', attendList[i].SignedUp);
        }
    }
    endRequest();
    var title = $('#' + $('#trainingIdHidden').val() + '_description a#_lnkTopic').text().trim();
    $('#trainingTitle').text('Add Users to ' + title + ' Training');
    showModal('associatedUsersPanelExtender');
}

function SubmitAssociatedStudents() {
    var newUserCount = 0;
    if (attendList) {
        beginRequest();
        for (var i = 0; i < attendList.length; i++) {
            var chk = $('#chk_' + attendList[i].StudentId);
            if (chk) {
                attendList[i].SignedUp = chk.is(':checked');
                if (attendList[i].SignedUp) {
                    newUserCount = newUserCount + 1;
                }
            }
        }

        var curAttendanceCount = $('#mainlist').find('#' + $('#trainingIdHidden').val()).find('#_lblAttendance').text();
        if (newUserCount > curAttendanceCount) {
            alert('The training roster lists ' + curAttendanceCount + ' users, but you checked off ' + newUserCount + ' as having attended. ' +
                'Please ensure only those employees that attended the training are checked off on the list.');
        } else {
            $find('associatedUsersPanelExtender').hide();
            Kpa.AdminWeb.Services.OnsiteTrainingService.SubmitAssociatedStudents(Sys.Serialization.JavaScriptSerializer.serialize(attendList), $('#trainingIdHidden').val(), SubmitAssociatedStudentsCallback, FailedCallback);
        }

        endRequest();
    }
}

function SubmitAssociatedStudentsCallback(result, eventArgs) {
    var newUserCount = 0;
    if (attendList) {
        for (var i = 0; i < attendList.length; i++) {
            if (attendList[i].SignedUp)
                newUserCount = newUserCount + 1;
        }

        $('#mainlist').find('#' + $('#trainingIdHidden').val()).find('#_lblAssociated').text(newUserCount);
    }

    endRequest();
    if (!result) {
        alert('Error saving associated users');
    }
}

