$(function() {

    $(document).on('click', ".remove_grp" , function( e ) {
        e.preventDefault();
        var id = $(this).parent(".grp_entry").data("grpId"),
            name = $(this).parent(".grp_entry").text();

        $(this).parents(".addPackageGroupForm").find(".grp_select").find('option[value="'+ id +'"]').removeAttr("disabled");
        return false;
    });


    $(".grp_select").on("change", function(){
        var grpID = $(this).val(),
            grpName = $(this).find(":selected").text();

        $(this).parents("td").find("ul").append(
            $('<li class="grp_entry" data-grp-id="'+ grpID +'">'+ grpName +'<a class="remove_grp"><i class="fa fa-remove"></i></a></li>')
        );

        $(this).find('option[value="'+ grpID +'"]').attr("disabled", "disabled");
        $(this).find('option:eq(0)').prop('selected', true);
    });
});
