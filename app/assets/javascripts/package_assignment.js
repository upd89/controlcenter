
var saveList = 0,
    saveAssignment = function( pkgID, groupIDs ) {
        saveList += groupIDs.length;

        for( var i = 0; i < groupIDs.length; i++ ) {
            createAssignment( pkgID, groupIDs[i] );
        }
    },
    createAssignment = function( pkgID, groupID ) {
        var $elem = $( "#package_" + pkgID).find("form.addPackageGroupForm"),
            data = {
                'utf8': $elem.find("input[name='utf8']").val(),
                'authenticity_token': $elem.find("input[name='authenticity_token']").val(),
                'group_assignment': {
                    'package_id': pkgID,
                    'package_group_id': groupID
                },
                "package_assignment": true
            };

        $.ajax({
            url: $elem[0].action,
            headers: {
                Accept : "text/javascript; charset=utf-8",
                "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            type: 'POST',
            data: data,
            success: function(data) {
                saveList--;
                if ( saveList === 0 ) {
                    window.location = "/";
                }
            },
            error: function(data) {}
        });
    };

$(document).on("page:change", function(){
    saveList = 0;

    $("#packageList").off().on('click', ".remove_grp" , function( e ) {
        e.preventDefault();
        var id = $(this).parent(".grp_entry").data("grpId");

        $(this).parents("td").find(".addPackageGroupForm .grp_select").find('option[value="'+ id +'"]').removeAttr("disabled");
        $(this).parent().remove();

        return false;
    });


    $(".grp_select").off().on("change", function(){
        var grpID = $(this).val(),
            grpName = $(this).find(":selected").text();

        $(this).parents("td").find("ul").append(
            $('<li class="grp_entry" data-grp-id="'+ grpID +'">'+ grpName +'<a class="remove_grp"><i class="fa fa-remove"></i></a></li>')
        );

        $(this).find('option[value="'+ grpID +'"]').attr("disabled", "disabled");
        $(this).find('option:eq(0)').prop('selected', true);
    });

    $("#btnSaveAssignments").off().on("click", function() {
        $("#packageList tr ul.selected-groups").each(function(){
            var groups = [];
            $(this).find("li.grp_entry").each(function(){
                groups.push( $(this).data("grpId") )
            });

            console.log( $(this).data("packageId"), groups );

            if ( groups.length > 0 ) {
                saveAssignment($(this).data("packageId"), groups);
            }
        });
       console.log( "save assignments!" );
    });
});
