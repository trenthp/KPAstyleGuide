(function () {
    window.Namespace = function (ns, fs) {
        var register = function (thisNs) {
            var nsParts = thisNs.split(".");
            var obj = window;

            for (var i = 0, j = nsParts.length; i < j; i++) {
                obj = obj[nsParts[i]] = obj[nsParts[i]] || {};
            }
        }

        register(ns);

        fs();
    };
})();