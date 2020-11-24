
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

  var PACKAGE_PATH;
  if (typeof window === 'object') {
    PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
  } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
    Module['locateFile'](REMOTE_PACKAGE_BASE) :
    ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);

    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;

    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
            var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onerror = function(event) {
        throw new Error("NetworkError for: " + packageName);
      }
      xhr.onload = function(event) {
        if (xhr.status == 200 || xhr.status == 304 || xhr.status == 206 || (xhr.status == 0 && xhr.response)) { // file URLs can return 0
          var packageData = xhr.response;
          callback(packageData);
        } else {
          throw new Error(xhr.statusText + " : " + xhr.responseURL);
        }
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };

    function runWithFS() {

      function assert(check, msg) {
        if (!check) throw msg + new Error().stack;
      }
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);
      Module['FS_createPath']('/', '', true, true);

      function DataRequest(start, end, crunched, audio) {
        this.start = start;
        this.end = end;
        this.crunched = crunched;
        this.audio = audio;
      }
      DataRequest.prototype = {
        requests: {},
        open: function(mode, name) {
          this.name = name;
          this.requests[name] = this;
          Module['addRunDependency']('fp ' + this.name);
        },
        send: function() {},
        onload: function() {
          var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

        },
        finish: function(byteArray) {
          var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      }
    };

    var files = metadata.files;
    for (i = 0; i < files.length; ++i) {
      new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
    }


    var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
    var IDB_RO = "readonly";
    var IDB_RW = "readwrite";
    var DB_NAME = "EM_PRELOAD_CACHE";
    var DB_VERSION = 1;
    var METADATA_STORE_NAME = 'METADATA';
    var PACKAGE_STORE_NAME = 'PACKAGES';
    function openDatabase(callback, errback) {
      try {
        var openRequest = indexedDB.open(DB_NAME, DB_VERSION);
      } catch (e) {
        return errback(e);
      }
      openRequest.onupgradeneeded = function(event) {
        var db = event.target.result;

        if(db.objectStoreNames.contains(PACKAGE_STORE_NAME)) {
          db.deleteObjectStore(PACKAGE_STORE_NAME);
        }
        var packages = db.createObjectStore(PACKAGE_STORE_NAME);

        if(db.objectStoreNames.contains(METADATA_STORE_NAME)) {
          db.deleteObjectStore(METADATA_STORE_NAME);
        }
        var metadata = db.createObjectStore(METADATA_STORE_NAME);
      };
      openRequest.onsuccess = function(event) {
        var db = event.target.result;
        callback(db);
      };
      openRequest.onerror = function(error) {
        errback(error);
      };
    };

    /* Check if there's a cached package, and if so whether it's the latest available */
    function checkCachedPackage(db, packageName, callback, errback) {
      var transaction = db.transaction([METADATA_STORE_NAME], IDB_RO);
      var metadata = transaction.objectStore(METADATA_STORE_NAME);

      var getRequest = metadata.get("metadata/" + packageName);
      getRequest.onsuccess = function(event) {
        var result = event.target.result;
        if (!result) {
          return callback(false);
        } else {
          return callback(PACKAGE_UUID === result.uuid);
        }
      };
      getRequest.onerror = function(error) {
        errback(error);
      };
    };

    function fetchCachedPackage(db, packageName, callback, errback) {
      var transaction = db.transaction([PACKAGE_STORE_NAME], IDB_RO);
      var packages = transaction.objectStore(PACKAGE_STORE_NAME);

      var getRequest = packages.get("package/" + packageName);
      getRequest.onsuccess = function(event) {
        var result = event.target.result;
        callback(result);
      };
      getRequest.onerror = function(error) {
        errback(error);
      };
    };

    function cacheRemotePackage(db, packageName, packageData, packageMeta, callback, errback) {
      var transaction_packages = db.transaction([PACKAGE_STORE_NAME], IDB_RW);
      var packages = transaction_packages.objectStore(PACKAGE_STORE_NAME);

      var putPackageRequest = packages.put(packageData, "package/" + packageName);
      putPackageRequest.onsuccess = function(event) {
        var transaction_metadata = db.transaction([METADATA_STORE_NAME], IDB_RW);
        var metadata = transaction_metadata.objectStore(METADATA_STORE_NAME);
        var putMetadataRequest = metadata.put(packageMeta, "metadata/" + packageName);
        putMetadataRequest.onsuccess = function(event) {
          callback(packageData);
        };
        putMetadataRequest.onerror = function(error) {
          errback(error);
        };
      };
      putPackageRequest.onerror = function(error) {
        errback(error);
      };
    };

    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;

        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          DataRequest.prototype.requests[files[i].filename].onload();
        }
        Module['removeRunDependency']('datafile_game.data');

      };
      Module['addRunDependency']('datafile_game.data');

      if (!Module.preloadResults) Module.preloadResults = {};

      function preloadFallback(error) {
        console.error(error);
        console.error('falling back to default preload behavior');
        fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, processPackageData, handleError);
      };

      openDatabase(
        function(db) {
          checkCachedPackage(db, PACKAGE_PATH + PACKAGE_NAME,
            function(useCached) {
              Module.preloadResults[PACKAGE_NAME] = {fromCache: useCached};
              if (useCached) {
                console.info('loading ' + PACKAGE_NAME + ' from cache');
                fetchCachedPackage(db, PACKAGE_PATH + PACKAGE_NAME, processPackageData, preloadFallback);
              } else {
                console.info('loading ' + PACKAGE_NAME + ' from remote');
                fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE,
                  function(packageData) {
                    cacheRemotePackage(db, PACKAGE_PATH + PACKAGE_NAME, packageData, {uuid:PACKAGE_UUID}, processPackageData,
                      function(error) {
                        console.error(error);
                        processPackageData(packageData);
                      });
                  }
                  , preloadFallback);
              }
            }
            , preloadFallback);
        }
        , preloadFallback);

      if (Module['setStatus']) Module['setStatus']('Downloading...');

    }
    if (Module['calledRun']) {
      runWithFS();
    } else {
      if (!Module['preRun']) Module['preRun'] = [];
      Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
    }

  }
  loadPackage({"package_uuid":"22562be6-b59d-4b65-9fce-877823402cf8","remote_package_size":51717156,"files":[{"filename":"","crunched":0,"start":0,"end":28,"audio":false},{"filename":"","crunched":0,"start":28,"end":49,"audio":false},{"filename":"","crunched":0,"start":49,"end":354,"audio":false},{"filename":"","crunched":0,"start":354,"end":427,"audio":false},{"filename":"","crunched":0,"start":427,"end":905,"audio":false},{"filename":"","crunched":0,"start":905,"end":1801,"audio":false},{"filename":"","crunched":0,"start":1801,"end":6456,"audio":false},{"filename":"","crunched":0,"start":6456,"end":6645,"audio":false},{"filename":"","crunched":0,"start":6645,"end":7069,"audio":false},{"filename":"","crunched":0,"start":7069,"end":8712,"audio":false},{"filename":"","crunched":0,"start":8712,"end":9128,"audio":false},{"filename":"","crunched":0,"start":9128,"end":10476,"audio":false},{"filename":"","crunched":0,"start":10476,"end":15374,"audio":false},{"filename":"","crunched":0,"start":15374,"end":15918,"audio":false},{"filename":"","crunched":0,"start":15918,"end":17410,"audio":false},{"filename":"","crunched":0,"start":17410,"end":21045,"audio":false},{"filename":"","crunched":0,"start":21045,"end":30465,"audio":false},{"filename":"","crunched":0,"start":30465,"end":30705,"audio":false},{"filename":"","crunched":0,"start":30705,"end":31911,"audio":false},{"filename":"","crunched":0,"start":31911,"end":33117,"audio":false},{"filename":"","crunched":0,"start":33117,"end":33305,"audio":false},{"filename":"","crunched":0,"start":33305,"end":34235,"audio":false},{"filename":"","crunched":0,"start":34235,"end":36883,"audio":false},{"filename":"","crunched":0,"start":36883,"end":37215,"audio":false},{"filename":"","crunched":0,"start":37215,"end":37558,"audio":false},{"filename":"","crunched":0,"start":37558,"end":37889,"audio":false},{"filename":"","crunched":0,"start":37889,"end":37945,"audio":false},{"filename":"","crunched":0,"start":37945,"end":39975,"audio":false},{"filename":"","crunched":0,"start":39975,"end":42815,"audio":false},{"filename":"","crunched":0,"start":42815,"end":42975,"audio":false},{"filename":"","crunched":0,"start":42975,"end":43317,"audio":false},{"filename":"","crunched":0,"start":43317,"end":43653,"audio":false},{"filename":"","crunched":0,"start":43653,"end":44602,"audio":false},{"filename":"","crunched":0,"start":44602,"end":44779,"audio":false},{"filename":"","crunched":0,"start":44779,"end":45121,"audio":false},{"filename":"","crunched":0,"start":45121,"end":45464,"audio":false},{"filename":"","crunched":0,"start":45464,"end":48111,"audio":false},{"filename":"","crunched":0,"start":48111,"end":48443,"audio":false},{"filename":"","crunched":0,"start":48443,"end":50953,"audio":false},{"filename":"","crunched":0,"start":50953,"end":53543,"audio":false},{"filename":"","crunched":0,"start":53543,"end":53886,"audio":false},{"filename":"","crunched":0,"start":53886,"end":53942,"audio":false},{"filename":"","crunched":0,"start":53942,"end":54273,"audio":false},{"filename":"","crunched":0,"start":54273,"end":54915,"audio":false},{"filename":"","crunched":0,"start":54915,"end":55612,"audio":false},{"filename":"","crunched":0,"start":55612,"end":55944,"audio":false},{"filename":"","crunched":0,"start":55944,"end":56277,"audio":false},{"filename":"","crunched":0,"start":56277,"end":58407,"audio":false},{"filename":"","crunched":0,"start":58407,"end":58579,"audio":false},{"filename":"","crunched":0,"start":58579,"end":58635,"audio":false},{"filename":"","crunched":0,"start":58635,"end":61126,"audio":false},{"filename":"","crunched":0,"start":61126,"end":61295,"audio":false},{"filename":"","crunched":0,"start":61295,"end":61470,"audio":false},{"filename":"","crunched":0,"start":61470,"end":63933,"audio":false},{"filename":"","crunched":0,"start":63933,"end":63989,"audio":false},{"filename":"","crunched":0,"start":63989,"end":64164,"audio":false},{"filename":"","crunched":0,"start":64164,"end":64995,"audio":false},{"filename":"","crunched":0,"start":64995,"end":65627,"audio":false},{"filename":"","crunched":0,"start":65627,"end":65682,"audio":false},{"filename":"","crunched":0,"start":65682,"end":65737,"audio":false},{"filename":"","crunched":0,"start":65737,"end":66149,"audio":false},{"filename":"","crunched":0,"start":66149,"end":67097,"audio":false},{"filename":"","crunched":0,"start":67097,"end":67790,"audio":false},{"filename":"","crunched":0,"start":67790,"end":69853,"audio":false},{"filename":"","crunched":0,"start":69853,"end":87753,"audio":false},{"filename":"","crunched":0,"start":87753,"end":31235487,"audio":false},{"filename":"","crunched":0,"start":31235487,"end":31235599,"audio":false},{"filename":"","crunched":0,"start":31235599,"end":31235640,"audio":false},{"filename":"","crunched":0,"start":31235640,"end":31235670,"audio":false},{"filename":"","crunched":0,"start":31235670,"end":31235711,"audio":false},{"filename":"","crunched":0,"start":31235711,"end":31235734,"audio":false},{"filename":"","crunched":0,"start":31235734,"end":31247461,"audio":false},{"filename":"","crunched":0,"start":31247461,"end":31247603,"audio":false},{"filename":"","crunched":0,"start":31247603,"end":31247859,"audio":false},{"filename":"","crunched":0,"start":31247859,"end":31248133,"audio":false},{"filename":"","crunched":0,"start":31248133,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31248469,"audio":false},{"filename":"","crunched":0,"start":31248469,"end":31249305,"audio":false},{"filename":"","crunched":0,"start":31249305,"end":31249472,"audio":false},{"filename":"","crunched":0,"start":31249472,"end":31258712,"audio":false},{"filename":"","crunched":0,"start":31258712,"end":31258726,"audio":false},{"filename":"","crunched":0,"start":31258726,"end":31303739,"audio":true},{"filename":"","crunched":0,"start":31303739,"end":31308162,"audio":true},{"filename":"","crunched":0,"start":31308162,"end":31331286,"audio":true},{"filename":"","crunched":0,"start":31331286,"end":39040390,"audio":true},{"filename":"","crunched":0,"start":39040390,"end":39271912,"audio":true},{"filename":"","crunched":0,"start":39271912,"end":49082137,"audio":true},{"filename":"","crunched":0,"start":49082137,"end":51062597,"audio":true},{"filename":"","crunched":0,"start":51062597,"end":51062968,"audio":false},{"filename":"","crunched":0,"start":51062968,"end":51064532,"audio":false},{"filename":"","crunched":0,"start":51064532,"end":51064640,"audio":false},{"filename":"","crunched":0,"start":51064640,"end":51116899,"audio":false},{"filename":"","crunched":0,"start":51116899,"end":51168531,"audio":false},{"filename":"","crunched":0,"start":51168531,"end":51171946,"audio":false},{"filename":"","crunched":0,"start":51171946,"end":51172647,"audio":false},{"filename":"","crunched":0,"start":51172647,"end":51173135,"audio":false},{"filename":"","crunched":0,"start":51173135,"end":51181272,"audio":false},{"filename":"","crunched":0,"start":51181272,"end":51181697,"audio":false},{"filename":"","crunched":0,"start":51181697,"end":51182428,"audio":false},{"filename":"","crunched":0,"start":51182428,"end":51183901,"audio":false},{"filename":"","crunched":0,"start":51183901,"end":51188695,"audio":false},{"filename":"","crunched":0,"start":51188695,"end":51192844,"audio":false},{"filename":"","crunched":0,"start":51192844,"end":51193207,"audio":false},{"filename":"","crunched":0,"start":51193207,"end":51193776,"audio":false},{"filename":"","crunched":0,"start":51193776,"end":51194883,"audio":false},{"filename":"","crunched":0,"start":51194883,"end":51198243,"audio":false},{"filename":"","crunched":0,"start":51198243,"end":51205077,"audio":false},{"filename":"","crunched":0,"start":51205077,"end":51205499,"audio":false},{"filename":"","crunched":0,"start":51205499,"end":51206159,"audio":false},{"filename":"","crunched":0,"start":51206159,"end":51207474,"audio":false},{"filename":"","crunched":0,"start":51207474,"end":51211732,"audio":false},{"filename":"","crunched":0,"start":51211732,"end":51215851,"audio":false},{"filename":"","crunched":0,"start":51215851,"end":51216191,"audio":false},{"filename":"","crunched":0,"start":51216191,"end":51216715,"audio":false},{"filename":"","crunched":0,"start":51216715,"end":51217792,"audio":false},{"filename":"","crunched":0,"start":51217792,"end":51221139,"audio":false},{"filename":"","crunched":0,"start":51221139,"end":51223380,"audio":false},{"filename":"","crunched":0,"start":51223380,"end":51228061,"audio":false},{"filename":"","crunched":0,"start":51228061,"end":51238960,"audio":false},{"filename":"","crunched":0,"start":51238960,"end":51275657,"audio":false},{"filename":"","crunched":0,"start":51275657,"end":51283848,"audio":false},{"filename":"","crunched":0,"start":51283848,"end":51284313,"audio":false},{"filename":"","crunched":0,"start":51284313,"end":51285043,"audio":false},{"filename":"","crunched":0,"start":51285043,"end":51286526,"audio":false},{"filename":"","crunched":0,"start":51286526,"end":51291259,"audio":false},{"filename":"","crunched":0,"start":51291259,"end":51299454,"audio":false},{"filename":"","crunched":0,"start":51299454,"end":51299897,"audio":false},{"filename":"","crunched":0,"start":51299897,"end":51300641,"audio":false},{"filename":"","crunched":0,"start":51300641,"end":51302113,"audio":false},{"filename":"","crunched":0,"start":51302113,"end":51306886,"audio":false},{"filename":"","crunched":0,"start":51306886,"end":51307799,"audio":false},{"filename":"","crunched":0,"start":51307799,"end":51308475,"audio":false},{"filename":"","crunched":0,"start":51308475,"end":51309331,"audio":false},{"filename":"","crunched":0,"start":51309331,"end":51309647,"audio":false},{"filename":"","crunched":0,"start":51309647,"end":51310146,"audio":false},{"filename":"","crunched":0,"start":51310146,"end":51310417,"audio":false},{"filename":"","crunched":0,"start":51310417,"end":51310606,"audio":false},{"filename":"","crunched":0,"start":51310606,"end":51343405,"audio":false},{"filename":"","crunched":0,"start":51343405,"end":51343870,"audio":false},{"filename":"","crunched":0,"start":51343870,"end":51344787,"audio":false},{"filename":"","crunched":0,"start":51344787,"end":51351621,"audio":false},{"filename":"","crunched":0,"start":51351621,"end":51359169,"audio":false},{"filename":"","crunched":0,"start":51359169,"end":51365832,"audio":false},{"filename":"","crunched":0,"start":51365832,"end":51410412,"audio":false},{"filename":"","crunched":0,"start":51410412,"end":51411698,"audio":false},{"filename":"","crunched":0,"start":51411698,"end":51413211,"audio":false},{"filename":"","crunched":0,"start":51413211,"end":51414117,"audio":false},{"filename":"","crunched":0,"start":51414117,"end":51415816,"audio":false},{"filename":"","crunched":0,"start":51415816,"end":51416506,"audio":false},{"filename":"","crunched":0,"start":51416506,"end":51417233,"audio":false},{"filename":"","crunched":0,"start":51417233,"end":51418042,"audio":false},{"filename":"","crunched":0,"start":51418042,"end":51421936,"audio":false},{"filename":"","crunched":0,"start":51421936,"end":51423400,"audio":false},{"filename":"","crunched":0,"start":51423400,"end":51428296,"audio":false},{"filename":"","crunched":0,"start":51428296,"end":51431093,"audio":false},{"filename":"","crunched":0,"start":51431093,"end":51434806,"audio":false},{"filename":"","crunched":0,"start":51434806,"end":51436955,"audio":false},{"filename":"","crunched":0,"start":51436955,"end":51440462,"audio":false},{"filename":"","crunched":0,"start":51440462,"end":51443432,"audio":false},{"filename":"","crunched":0,"start":51443432,"end":51464528,"audio":false},{"filename":"","crunched":0,"start":51464528,"end":51467458,"audio":false},{"filename":"","crunched":0,"start":51467458,"end":51500962,"audio":false},{"filename":"","crunched":0,"start":51500962,"end":51524312,"audio":false},{"filename":"","crunched":0,"start":51524312,"end":51532804,"audio":false},{"filename":"","crunched":0,"start":51532804,"end":51542442,"audio":false},{"filename":"","crunched":0,"start":51542442,"end":51548385,"audio":false},{"filename":"","crunched":0,"start":51548385,"end":51587598,"audio":false},{"filename":"","crunched":0,"start":51587598,"end":51603033,"audio":false},{"filename":"","crunched":0,"start":51603033,"end":51603905,"audio":false},{"filename":"","crunched":0,"start":51603905,"end":51646313,"audio":false},{"filename":"","crunched":0,"start":51646313,"end":51686969,"audio":false},{"filename":"","crunched":0,"start":51686969,"end":51698182,"audio":false},{"filename":"","crunched":0,"start":51698182,"end":51698359,"audio":false},{"filename":"","crunched":0,"start":51698359,"end":51699632,"audio":false},{"filename":"","crunched":0,"start":51699632,"end":51700650,"audio":false},{"filename":"","crunched":0,"start":51700650,"end":51701453,"audio":false},{"filename":"","crunched":0,"start":51701453,"end":51702827,"audio":false},{"filename":"","crunched":0,"start":51702827,"end":51706380,"audio":false},{"filename":"","crunched":0,"start":51706380,"end":51709452,"audio":false},{"filename":"","crunched":0,"start":51709452,"end":51711447,"audio":false},{"filename":"","crunched":0,"start":51711447,"end":51713762,"audio":false},{"filename":"","crunched":0,"start":51713762,"end":51716252,"audio":false},{"filename":"","crunched":0,"start":51716252,"end":51717156,"audio":false}]});

})();
