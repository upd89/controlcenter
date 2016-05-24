function CPV( sID ) {
  this.id = parseInt( sID );
}
function Package( pID ) {
  this.id = parseInt( pID );
  this.cpvs = [];
  this.pristine = true;
  this.addCPV = function( sys ) {
    this.pristine = false;
    for ( var i = 0; i < this.size(); i++ ) {
      if ( this.cpvs[i].id === sys.id ) {
        return;
      }
    }
    this.cpvs.push(sys);
  };
  this.removeCPVByID = function( id ) {
    this.pristine = false;
    for ( var i = 0; i < this.size(); i++ ) {
      if ( this.cpvs[i].id === id ) {
        this.cpvs.splice( i, 1 );
        return;
      }
    }
  };
  this.removeCPV = function( sys ) {
    this.removeCPVByID( sys.id );
  };
  this.reset = function() {
    this.cpvs = [];
  };
  this.size = function() {
    return this.cpvs.length;
  };
}
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
        return this.packages[i];
      }
    }
    this.packages.push( pkg );
    return pkg;
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
  };
  this.cpvCount = function() {
    var tempList = [];
    for ( var i = 0; i < this.size(); i++ ) {
      for ( var j = 0; j < this.packages[i].size(); j++ ) {
        if( tempList.indexOf( this.packages[i].cpvs[j].id ) === -1 ) {
          tempList.push ( this.packages[i].cpvs[j].id );
        }
      }
    }
    return tempList.length;
  };
  this.getFinalList = function() {
    /* Turns   Pkg1: [SysA, SysB],
     *         Pkg2: [SysB]
     *
     * into    SysA: [ Pkg1 ]
     *         SysB: [ Pkg1, Pkg2 ]
     */
    var turnedList = [];

    for ( var i = 0; i < this.size(); i++ ) {
      for ( var j = 0; j < this.packages[i].size(); j++ ) {
        var sysEntry = false;
        for(var k = 0; j < turnedList.length; k++ ) {
          if ( turnedList[k].id === this.packages[i].cpvs[j].id ) {
            sysEntry = turnedList[k];
            break;
          }
        }
        if ( !sysEntry ) {
          turnedList.push ( {
            id: this.packages[i].cpvs[j].id,
            packages: []
          } );
          sysEntry = turnedList[ turnedList.length - 1 ];
        }

        sysEntry.packages.push( this.packages[i].id );
      }
    }
    return turnedList;
  };
}

var list = new List(),
    updateSummary = function() {
      // TODO: pristine packages don't have their correct cpvs yet...
      $("#updateSummary").html( "This will install " + list.size() + " Updates on " + list.cpvCount() + " CPVs" );
    },
    toggleUpdateButton = function() {
      if ( list.size() === 0 ) {
        $("#applyUpdates").attr('disabled', 'disabled');
      } else {
        $("#applyUpdates").removeAttr('disabled').removeClass("disabled");
      }
    },
    showCurrentList = function(){
      //$("#notices").html( JSON.stringify(list) );
      //updateSummary();
      toggleUpdateButton();
    },
    markPackage = function( pkg, checked ){
      $("table.comboUpdates .checkboxInstallUpdate.package[value="+ pkg.id +"]").prop("checked", checked);
    },
    markPackages = function() {
      $("table.comboUpdates .checkboxInstallUpdate.package").prop("checked",false);
      for( var i = 0; i < list.size(); i++ ) {
        markPackage( list.packages[i], true );
      }
    },
    markCPVs = function() {
      var pkg = list.getPackage( getPkgId() );

      if ( pkg.pristine && pkg.size() === 0 ) {
        // untouched, add all
        $("table.comboUpdates .checkboxInstallUpdate.cpv").each( function(e){
          pkg.addCPV( new CPV( $(this).val() ) );
          $(this).prop("checked",true);
        } );
      } else {
        // not empty
        $("table.comboUpdates .checkboxInstallUpdate.cpv").prop("checked",false);
        for( var i = 0; i < pkg.size(); i++ ) {
          $("table.comboUpdates .checkboxInstallUpdate.cpv[value="+ pkg.cpvs[i].id +"]").prop("checked",true);
        }
      }
    },
    unmarkCPVs = function() {
      $("table.comboUpdates .checkboxInstallUpdate.cpv").prop("checked",false);
    },
    unmarkPackages = function() {
      $("table.comboUpdates .checkboxInstallUpdate.package").prop("checked",false);
    },
    getPkgId = function() {
      return parseInt( $("#packageID").data("pkgId") );
    },
    highlightChosenPackage = function() {
      $("table.comboUpdates tr.active").removeClass("active");
      $("table.comboUpdates .checkboxInstallUpdate.package[value="+ getPkgId() +"]").parents("tr").addClass("active");
    },
    clickHandler = function(e) {
      var isPkg = $(e.target).hasClass("package"),
          id = parseInt( $(e.target).val() ),
          checked = $(e.target).is(":checked");

      if ( isPkg ) {
        if ( checked ) {
          list.addPackage( new Package( id ) );
          if ( getPkgId() === id ) { // currently open
            markCPVs();
          }
        } else {
          list.removePackageByID( id );
          if ( getPkgId() === id ) { // currently open
            unmarkCPVs();
          }
        }
      } else {
        var pkg = list.getPackage( getPkgId() );
        if ( !pkg ) {
          // no pkg found --> create it
          pkg = list.addPackage( new Package( getPkgId() ) );
          markPackage( pkg, true );
        }

        if ( checked ) { //add cpv to package
          pkg.addCPV( new CPV( id ) );
        } else {
          pkg.removeCPVByID( id );
          if ( pkg.size() === 0 ) { // removed the last cpv from this package
            markPackage( pkg, false );
            list.removePackage( pkg );
          }
        }
      }

      showCurrentList();
    };

$(document).on("page:change", function(){
  $("table.comboUpdates .checkboxInstallUpdate").on("click", clickHandler);
});
$(document).on("comboview:showCPVs", function(){
  highlightChosenPackage();
  markCPVs();
});
$(document).on("comboview:showPackages", function(){
  markPackages();
});


$(function() {
  list.reset();
  showCurrentList();

  $("#clearList").on("click", function(e) {
    list.reset();
    showCurrentList();
    unmarkPackages();
    unmarkCPVs();
    e.preventDefault();
    return false;
  });

  $("#applyUpdates").on("click", function(e) {
    $.ajax({
      url: $("#comboViewForm")[0].action,
      headers: {
        Accept : "text/javascript; charset=utf-8",
        "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      type: 'POST',
      data: {
        'utf8': $("#comboViewForm input[name='utf8']").val(),
        'authenticity_token': $("#comboViewForm input[name='authenticity_token']").val(),
        'list': JSON.stringify( list )
      },
      success: function(data) {
        if (data.responseText.indexOf("/") === 0) {
          window.location = data.responseText;
        }
      },
      error: function(data) {
        if (data.responseText.indexOf("/") === 0) {
          window.location = data.responseText;
        }
      }
    });
  });
});
