cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "com.kingo.PhotoSnip.PhotoSnipPlugin",
        "file": "plugins/com.kingo.PhotoSnip/www/PhotoSnipPlugin.js",
        "pluginId": "com.kingo.PhotoSnip",
        "clobbers": [
            "cordova.plugins.PhotoSnipPlugin"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.3.2",
    "com.kingo.PhotoSnip": "0.1"
};
// BOTTOM OF METADATA
});