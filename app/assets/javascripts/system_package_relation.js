function System( sID ) {
  this.id = parseInt( sID );
};
function Package( pID ) {
  this.id = parseInt( pID );
  this.systems = [];
  this.pristine = true;
  this.addSystem = function( sys ) {
    this.pristine = false;
    for ( var i = 0; i < this.size(); i++ ) {
      if ( this.systems[i].id === sys.id ) {
        return;
      }
    }
    this.systems.push(sys);
  };
  this.removeSystemByID = function( id ) {
    this.pristine = false;
    for ( var i = 0; i < this.size(); i++ ) {
      if ( this.systems[i].id === id ) {
        this.systems.splice( i, 1 );
        return;
      }
    }
  };
  this.removeSystem = function( sys ) {
    this.removeSystemByID( sys.id );
  };
  this.reset = function() {
    this.systems = [];
  };
  this.size = function() {
    return this.systems.length;
  }
};
function List() {
  this.packages = [];
  this.getPackage = function( id ) {
    for ( var i = 0; i < this.size(); i++ ) {
      if ( this.packages[i].id === id ) {
        return this.packages[i];
      }
    }
    return false;
  };
  this.addPackage = function( pkg ) {
    for ( var i = 0; i < this.size(); i++ ) {
      if ( this.packages[i].id === pkg.id ) {
        return;
      }
    }
    this.packages.push( pkg );
  };
  this.removePackageByID = function( id ) {
    for ( var i = 0; i < this.size(); i++ ) {
      if ( this.packages[i].id === id ) {
        this.packages.splice( i, 1 );
        return;
      }
    }
  };
  this.removePackage = function( pkg ) {
    this.removePackageByID( pkg.id );
  };
  this.reset = function() {
    this.packages = [];
  };
  this.size = function() {
    return this.packages.length;
  }
};

var list = new List(),
    showCurrentList = function(){
      $("#notices").html( JSON.stringify(list) );
    },
    markPackages = function() {
      $("table.comboUpdates .checkboxInstallUpdate.package").prop("checked",false);
      for( var i = 0; i < list.size(); i++ ) {
        $("table.comboUpdates .checkboxInstallUpdate.package[value="+ list.packages[i] +"]").prop("checked",true);
      }
    },
    markSystems = function() {
      var pkg = list.getPackage( getPkgId() );

      if ( pkg.pristine && pkg.size() === 0 ) {
        // untouched, add all
        $("table.comboUpdates .checkboxInstallUpdate.system").each( function(e){
          pkg.addSystem( new System( $(this).val() ) );
          $(this).prop("checked",true);
        } );
      } else {
        // not empty
        $("table.comboUpdates .checkboxInstallUpdate.system").prop("checked",false);
        for( var i = 0; i < pkg.size(); i++ ) {
          $("table.comboUpdates .checkboxInstallUpdate.system[value="+ pkg.systems[i].id +"]").prop("checked",true);
        }
      }
    },
    getPkgId = function() {
      return $("#packageID").data("pkgId")
    },clickHandler = function(e) {
      var isPkg = $(e.target).hasClass("package"),
          id = parseInt( $(e.target).val() ),
          checked = $(e.target).is(":checked");

      if ( isPkg ) {
        if ( checked ) {
          list.addPackage( new Package( id ) );
        } else {
          list.removePackageByID( id );
        }
      } else {
        var pkg = list.getPackage( getPkgId() );
        if ( checked ) { //add system to package
          pkg.addSystem( new System( id ) );
        } else {
          pkg.removeSystemByID( id )
        }
      }

      showCurrentList();
    };

$(document).on("page:change", function(){
  $("table.comboUpdates .checkboxInstallUpdate").on("click", clickHandler);

});
$(document).on("comboview:showSystems", function(){
    markSystems();
});
$(document).on("comboview:showPackages", function(){
    markPackages();
});


$(function() {
  list.reset();

  //$("table.comboUpdates .checkboxInstallUpdate").on("click", clickHandler);
  $("#clearList").on("click", function(e) {
    list.reset();
    showCurrentList();
    e.preventDefault();
    return false;
  });
});
