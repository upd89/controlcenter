var list,
    showCurrentList = function(){
      $("#notices").html( JSON.stringify(list) );
    },
    initList = function() {
      list = {
        packages: [],
        systems: []
      };
    },
    markPackages = function() {
      $("table.comboUpdates .checkboxInstallUpdate.package").prop("checked",false);
      for( var i = 0; i < list.packages; i++ ) {
        $("table.comboUpdates .checkboxInstallUpdate.package[value="+ list.packages[i] +"]").prop("checked",true);
      }
    };

var clickHandler = function(e) {
  var isPkg = $(e.target).hasClass("package"),
      targetList = isPkg ? list.packages : list.systems,
      id = $(e.target).val();

  if ( $(e.target).is(":checked") ) {
    if ( targetList.indexOf( id ) === -1 ) {
      targetList.push( id );
    }
  } else {
    targetList.splice( targetList.indexOf( id ), 1 );
  }

  showCurrentList();
};

$(document).on("page:change", function(){
  $("table.comboUpdates .checkboxInstallUpdate").on("click", clickHandler);

  
});


$(function() {
  initList();

  //$("table.comboUpdates .checkboxInstallUpdate").on("click", clickHandler);
  $("#clearList").on("click", function(e) {
    initList();
    showCurrentList();
    e.preventDefault();
    return false;
  });
});
