cordova.define("com.kingo.PhotoSnip.PhotoSnipPlugin", function(require, exports, module) {
var exec = require('cordova/exec');

exports.coolMethod = function(arg0, success, error) {
    exec(success, error, "PhotoSnipPlugin", "coolMethod", [arg0]);
};

});
