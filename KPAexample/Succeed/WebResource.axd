// zumiPage 2.11 for ASP.NET 2.0 - http://zumipage.com
// Copyright (C) 2006 All rights reserved.

Function.hw = function (method, an) {
    return function () {
method(an);
}
}
Function.gl = function () {
}
Function.dw = function (script) {
    var fn = null;
    eval("fn = function() {" + script + "};");
    if (typeof (fn) != 'function') {
        fn = null;
}
return fn;
}
String.prototype.gk = function (suffix) {
    return (this.substr(this.length - suffix.length) == suffix);
}
String.prototype.gj = function (prefix) {
    return (this.substr(0, prefix.length) == prefix);
}
String.prototype.gi = function () {
    return this.replace(/^\s*/, "");
}
String.prototype.ev = function () {
    return this.replace(/\s*$/, "");
}
String.prototype.gh = function () {
return this.ev().gi();
}
String.prototype.gg = function (startStr, endStr) {
    var ak = this.indexOf(startStr);
    var dt = this.indexOf(endStr, ak);
    if (dt > ak && ak != -1)
        return this.substring(ak + startStr.length, dt);
else
        return "";
}
String.prototype.ew = function (fromStr, toStr) {
    var fu = new RegExp(fromStr, "ig");
    return this.replace(fu, toStr);
}
Array.prototype.p = function (item) {
this.push(item);
}
Array.prototype.ii = function (items) {
    var length = items.length;
    if (length != 0) {
        for (var g = 0; g < length; g++) {
this.push(items[g]);
}
}
}
Array.prototype.clear = function () {
    if (this.length > 0) {
        this.splice(0, this.length);
}
}
Array.prototype.ih = function () {
    var at = [];
    var length = this.length;
    for (var g = 0; g < length; g++) {
        at[g] = this[g];
}
return at;
}
Array.prototype.parseInt = function () {
    var at = [];
    var length = this.length;
    for (var g = 0; g < length; g++) {
        at[g] = parseInt(this[g]);
}
return at;
}
Array.prototype.ig = function (item) {
    var g = this.indexOf(item);
    return (g >= 0);
}
Array.prototype.ie = function () {
return this.shift();
}
Array.prototype.indexOf = function (item) {
    var length = this.length;
    if (length != 0) {
        for (var g = 0; g < length; g++) {
            if (this[g] == item) {
return g;
}
}
}
    return -1;
}
Array.prototype.ic = function (g, item) {
    this.splice(g, 0, item);
}
Array.prototype.ib = function (item) {
this.push(item);
}
Array.prototype.et = function (item) {
    var g = this.indexOf(item);
    if (g >= 0) {
        this.splice(g, 1);
}
}
Array.prototype.ia = function (g) {
    this.splice(g, 1);
}
gfs = new Object();
gfs.hz = function (hy) {
    var bx = new Array();
    if ((typeof (hy) == 'string') &&
    (hy.length != 0)) {
bx.p(hy);
}
    this.t = function (text) {
        if ((text == null) || (typeof (text) == 'undefined')) {
return;
}
        if ((typeof (text) == 'string') && (text.length == 0)) {
return;
}
bx.p(text);
}
    this.fw = function (text) {
this.t(text);
bx.p('\r\n');
}
    this.clear = function () {
bx.clear();
}
    this.gb = function () {
        return (bx.length == 0);
}
    this.toString = function (gd) {
        gd = gd || '';
return bx.join(gd);
}
}
gfs.hx = new function () {
    function di() {
        if (!this.ek) {
            var ep = {};
            for (var f in this) {
                if (typeof (this[f]) != 'function') {
                    ep[f] = this[f];
}
}
            this.ek = ep;
}
return this.ek;
}
    function cy(s) {
        for (var f in this) {
            if (f == s) {
return this[f];
}
}
        throw 'Invalid Enumeration Value';
}
    function dn(value) {
        for (var i in this) {
            if (this[i] == value) {
return i;
}
}
        throw 'Invalid Enumeration Value';
}
    this.dw = function () {
        var aw = {};
        aw.di = di;
        aw.parse = cy;
        aw.toString = dn;
        for (var i = 0; i < arguments.length; i++) {
            aw[arguments[i]] = i;
}
return aw;
}
}
gfs.Event = function (hv, hu) {
    var ex = hv;
    var ac = null;
    var eg = hu;
    var fb = false;
    this.dd = function () {
return eg;
}
    this.bq = function () {
        if (ac == null) {
            ac = [];
}
return ac;
}
    this.eu = function () {
return ex;
}
    this.fa = function () {
        return ((ac != null) && (ac.length != 0));
}
    this.dm = function () {
return _isInvoked;
}
    this.bf = function () {
        if (ac) {
            for (var h = ac.length - 1; h >= 0; h--) {
                ac[h] = null;
}
            ac = null;
}
        ex = null;
}
    this.ef = function (value) {
        fb = true;
}
    this.p = function (el) {
this.bq().p(el);
        if (this.dd() && this.dm()) {
            el(this.eu(), null);
}
}
    this.et = function (el) {
this.bq().et(el);
}
    this.bp = function (hs, hr) {
        if (this.fa()) {
            var dv = this.bq();
var i;
            for (i = 0; i < dv.length; i++) {
                dv[i](hs, hr);
}
this.ef();
}
}
}
gfs.cm = gfs.hx.dw("Other", "InternetExplorer", "Firefox", "Opera");
function dkq(df) {
    switch (gfs.dl.gm()) {
case gfs.cm.InternetExplorer:
return df.text;
case gfs.cm.Firefox:
return df.textContent;
case gfs.cm.Opera:
            if (!df) {
                return "";
}
            else if (df.nodeValue) {
return df.nodeValue;
}
            else if (df.innerText) {
return df.innerText;
}
            else {
                return "";
}
}
}
function fmq(w) {
    if (!window.XMLHttpRequest) {
        window.XMLHttpRequest = function () {
            var ej = ['Msxml2.XMLHTTP', 'Microsoft.XMLHTTP'];
            for (var i = 0; i < ej.length; i++) {
                try {
                    var fl = new ActiveXObject(ej[i]);
return fl;
}
                catch (ex) {
}
}
return null;
}
}
}
function dxq(w) {
    function baq(df) {
        try {
            while (df && df.nodeType != 1) {
                df = df.parentNode;
}
}
        catch (ex) {
            df = null;
}
return df;
}
    w.attachEvent = function (hq, el) {
        this.addEventListener(hq, el, false);
}
    w.detachEvent = function (hq, el) {
        this.removeEventListener(hq, el, false);
}
    var az = function (hq, ht) {
        ht.hp = function (e) {
            window.event = e;
ht();
return e.returnValue;
};
        this.addEventListener(hq.slice(2), ht.hp, false);
}
    var ay = function (hq, ht) {
        if (ht.hp) {
            var cd = ht.hp;
delete ht.hp;
            this.removeEventListener(hq.slice(2), cd, false);
}
}
    w.attachEvent = az;
    w.detachEvent = ay;

    if (typeof (w.HTMLDocument) === "undefined") {
        w.Document.prototype.attachEvent = az;
        w.Document.prototype.detachEvent = ay;
    }
    else {
        w.HTMLDocument.prototype.attachEvent = az;
        w.HTMLDocument.prototype.detachEvent = ay;
    }

    w.HTMLElement.prototype.attachEvent = az;
    w.HTMLElement.prototype.detachEvent = ay;

    if (typeof (w.Event.prototype.__defineGetter__) === "undefined") {

        w.Event.prototype.__defineGetter__ = function(name, func) {
            Object.defineProperty(w.Event.prototype, name, {
                configurable: true,
                get: func
            });
        };
    }

    if (typeof (w.Event.prototype.__defineSetter__) === "undefined") {

        w.Event.prototype.__defineSetter__ = function (name, func) {
            Object.defineProperty(w.Event.prototype, name, {
                configurable: true,
                set: func
            });
        };
    }

    w.Event.prototype.__defineGetter__('srcElement', function () {
        var n = baq(this.target);
return n;
});

    function crx(fs) {
        var c = { x: 0, y: 0 };
        while (fs) {
            c.x += fs.offsetLeft;
            c.y += fs.offsetTop;
            fs = fs.offsetParent;
}
return c;
}

    w.Event.prototype.__defineGetter__('offsetX', function () {
        return window.pageXOffset + this.clientX - crx(this.srcElement).x;
});

    w.Event.prototype.__defineGetter__('offsetY', function () {
        return window.pageYOffset + this.clientY - crx(this.srcElement).y;
});

    w.Event.prototype.__defineSetter__('returnValue', function (v) {
        if (!v) {
this.preventDefault();
}
        this.cancelDefault = v;
return v;
});

    w.Event.prototype.__defineGetter__('returnValue', function () {
return this.cancelDefault;
});

    w.Event.prototype.__defineGetter__('fromElement', function () {
var n;
        if (this.type == 'mouseover') {
            n = this.relatedTarget;
}
        else if (this.type == 'mouseout') {
            n = this.target;
}
return baq(n);
});

    w.Event.prototype.__defineGetter__("toElement", function () {
var n;
        if (this.type == 'mouseout') {
            n = this.relatedTarget;
}
        else if (this.type == 'mouseover') {
            n = this.target;
}
return baq(n);
});

    w.Event.prototype.__defineGetter__('button', function () {
        return (this.which == 1) ? 1 : (this.which == 3) ? 2 : 0;
});

    if (typeof (HTMLElement) != "undefined" && !HTMLElement.prototype.insertAdjacentElement) {
        HTMLElement.prototype.insertAdjacentElement = function (ho, srcElement) {
            switch (ho) {
                case 'beforeBegin':
                    this.parentNode.insertBefore(srcElement, this);
break;
                case 'afterBegin':
                    this.insertBefore(srcElement, this.firstChild);
break;
                case 'beforeEnd':
this.appendChild(srcElement);
break;
                case 'afterEnd':
                    if (this.nextSibling)
                        this.parentNode.insertBefore(srcElement, this.nextSibling);
else
this.parentNode.appendChild(srcElement);
break;
}
}
        HTMLElement.prototype.insertAdjacentHTML = function (ho, srcHtml) {
            var ff = this.ownerDocument.createRange();
ff.setStartBefore(this);
            var srcElement = ff.createContextualFragment(srcHtml);
            this.insertAdjacentElement(ho, srcElement);
}
        HTMLElement.prototype.insertAdjacentText = function (ho, text) {
            var srcElement = document.createTextNode(text);
            this.insertAdjacentElement(ho, srcElement);
}
}
}
gfs.hn = function () {
    var ck = 1000;
var cc;
    var z = null;
    var cz = [];
    this.fq = function () {
return ck;
}
    this.cl = function (value) {
        if (z != null)
cn();
        if (value > 0) {
            ck = value;
cx(this);
            cc = true;
}
else
            cc = false;
}
    this.ee = function () {
return cc;
}
    this.bh = function (value) {
        if (value != this.ee()) {
            cc = value;
            if (value) {
cx(this);
}
            else {
cn();
}
}
}
    this.av = function (hu) {
        var au = new gfs.Event(this, hu);
cz.p(au);
return au;
}
    this.dc = this.av();
    this.bf = function () {
this.bh(false);
cn();
        if (this.dc) {
this.dc.bf();
            this.dc = null;
}
}
    function de(an) {
        an.dc.bp(an, null);
}
    function cx(fc) {
        z = window.setInterval(Function.hw(de, fc), ck);
}
    function cn() {
window.clearInterval(z);
        z = null;
}
}
gfs.hj = function (hm) {
    var cj = hm;
    this.p = function (hm, title, hl) {
        if (hm <= cj) {
            window.alert(title + "\r\n\r\n" + hl);
}
}
    this.bc = function (hm, text) {
        if (hm <= cj && window.clipboardData) {
            try {
                clipboardData.setData("Text", text);
}
            catch (e) { }
}
}
    this.ed = function (hm) {
        cj = hm;
}
}
gfs.hk = new gfs.hj(0);
gfs.hf = function (hi, hh) {
    var a = hi;
    var v = hh;
    this.ap = function () {
return a.responseText;
}
    this.db = function () {
return a.status;
}
    this.fk = function () {
return a.statusText;
}
    this.fh = function () {
return v;
}
    this.fj = function () {
        var dq = a.responseXML;
        try {
            if (!dq.documentElement)
                dq = null;
}
        catch (e) {
            dq = null;
};
return dq;
}
}
gfs.hg = function () {
    var ez = null;
var am;
    var aj = 0;
    var ao = null;
    var dp = null;
    var v = null;
    var a = null;
    var z = null;
    var r = true;
    var ci = false;
    var cs = false;
var bi;
    var cz = [];
    this.ft = function () {
return cs;
}
    this.fp = function () {
        return !r;
}
    this.ct = function () {
return dp;
}
    this.du = function (value) {
        dp = value;
}
    this.bg = function () {
        if (ao == null) {
            ao = {};
}
return ao;
}
    this.ds = function () {
        if (r && a && !bi) {
            bi = new gfs.hf(a, v);
            a = null;
}
return bi;
}
    this.en = function () {
return aj;
}
    this.be = function (value) {
        aj = value;
}
    this.fo = function () {
return ci;
}
    this.ga = function () {
return ez;
}
    this.ei = function (value) {
        if (!am) {
            ez = value;
}
}
    this.av = function (hu) {
        var au = new gfs.Event(this, hu);
cz.p(au);
return au;
}
    this.fi = this.av();
    this.bb = this.av();
    this.cb = this.av();
    this.abort = function () {
        if (z != null) {
window.clearTimeout(z);
            z = null;
}
        if (a != null) {
            a.onreadystatechange = Function.gl;
a.abort();
            if (r == false) {
                cs = true;
                r = true;
                this.fi.bp(this, null);
}
            a = null;
}
        bi = null;
        v = null;
}
    this.bf = function () {
        if (this.bb) {
this.bb.bf();
            this.bb = null;
}
        if (this.cb) {
this.cb.bf();
            this.cb = null;
}
this.abort();
}
    this.cw = function () {
return ez;
}
    this.bp = function (hh) {
        if (r == false) {
this.abort();
}
        r = false;
        cs = false;
        ci = false;
        bi = null;
        v = hh;
        a = new XMLHttpRequest();
        if (!am) {
            am = this.cw();
}
        if (dp != null) {
            a.onreadystatechange = Function.hw(onReadyStateChange, this);
            a.open('POST', am, true);
            if ((ao == null) || !ao['Content-Type']) {
                a.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
}
}
        else {
            aj = 0;
            a.open('GET', am, false);
}
        if (ao != null) {
            for (var er in ao) {
                a.setRequestHeader(er, ao[er]);
}
}
        if (aj != 0) {
            z = window.setTimeout(Function.hw(em, this), aj);
}
a.send(dp);
        if (dp == null) {
            r = true;
return this.ds();
}
}
    function onReadyStateChange(an) {
        if (a.readyState == 4) {
            if (z != null) {
window.clearTimeout(z);
                z = null;
}
            r = true;
            a.onreadystatechange = Function.gl;
            an.bb.bp(an, null);
            a = null;
            v = null;
}
}
    function em(an) {
        if (r == false) {
            if (z != null) {
window.clearTimeout(z);
                z = null;
}
            ci = true;
            r = true;
            a.onreadystatechange = Function.gl;
a.abort();
            an.cb.bp(an, null);
            a = null;
            v = null;
}
}
}
gfs.he = function () {
    this.da = zumiPage_Members[0];
    this.ec = zumiPage_Members[1];
    this.eb = zumiPage_Members[2];
    this.cv = zumiPage_Members[3];
    this.q = zumiPage_WaitClientScriptControl;
    this.ca = zumiPage_WaitClientScriptStart;
    this.cf = zumiPage_WaitClientScriptEnd;
    this.bt = zumiPage_ExcludeControls;
    this.ce = function (hc) {
        if (this.q) {
            id = this.q.indexOf(hc);
            if (id != -1)
return this.ca[id];
}
return null;
}
    this.cq = function (hc) {
        if (this.q) {
            id = this.q.indexOf(hc);
            if (id != -1)
return this.cf[id];
}
return null;
}
    this.cp = function (hc) {
        return this.bt && this.bt.indexOf(hc) != -1;
}
}
gfs.dl = new function () {
}
gfs.dl.hb = null;
gfs.dl.ha = null;
gfs.dl.gz = null;
gfs.dl.gy = null;
gfs.dl.gx = null;
gfs.dl.gw = [];
gfs.dl.gt = null;
gfs.dl.gs = null;
gfs.dl.gr = null;
gfs.dl.gq = null;
gfs.dl.gp = null;
gfs.dl.go = null;
gfs.dl.gn = null;
gfs.dl.gm = function () {
    if (!gfs.dl.gs) {

        // This check gets IE9 and lower. IE11 and above don't contain MSIE in the UA
        if (navigator.userAgent.indexOf('MSIE 10') == -1
            && navigator.userAgent.indexOf('MSIE') != -1) {
            gfs.dl.gs = gfs.cm.InternetExplorer;
}
        else {
            gfs.dl.gs = gfs.cm.Firefox;
}
}
return gfs.dl.gs;
}
gfs.dl._init = function (je) {
    gfs.dl.gr = new gfs.hn();
gfs.dl.gr.dc.p(gfs.dl.iy);
    gfs.dl.gq = new gfs.hn();
gfs.dl.gq.dc.p(gfs.dl.iv);
gfs.dl.jb();
    gfs.hk.p(3, "Browser detection: " + gfs.dl.gm(), navigator.userAgent);
    if (gfs.dl.gt.cv) {
gfs.dl.jd(document.getElementById(je));
}
}
gfs.dl.jb = function () {
    gfs.dl.gt = new gfs.he();
gfs.dl.gr.cl(gfs.dl.gt.da);
gfs.dl.gq.cl(gfs.dl.gt.ec);
gfs.hk.ed(gfs.dl.gt.eb);
}
gfs.dl.iz = function () {
    gfs.dl.hb.elements["zumiPage_FirstRequest"].value = "false";
    zumiPage_WaitClientScriptControl = null;
    zumiPage_WaitClientScriptStart = null;
    zumiPage_WaitClientScriptEnd = null;
    zumiPage_ExcludeControls = null;
    Page_Validators = new Array();
    __defaultFired = false;
    __theFormPostData = "";
    __theFormPostCollection = new Array();
}
gfs.dl.ja = function () {
    var form = gfs.dl.hb;
    window.detachEvent("onload", gfs.dl.ja);
    if (form.elements["zumiPage_FirstRequest"].value == "false") {
        gfs.hk.p(2, "History browsing detected, resetting the form fields to the initial static state.", "");
        if (gfs.dl.gm() == gfs.cm.InternetExplorer) {
form.reset();
}
        else {
            window.location.href = window.location.href;
}
}
}
gfs.dl.iy = function (hn) {
    if (!gfs.dl.ix()) {
hn.bh(false);
        var l = new gfs.hg();
l.ei(gfs.dl.hb.action);
        l.bg()['zumiPage'] = 'true';
        l.bg()['Cache-Control'] = 'no-cache';
l.be(30000);
l.bb.p(gfs.dl.iw);
l.du("zumiPage_KeepAliveRequest=true");
l.bp();
}
}
gfs.dl.iw = function (hn) {
gfs.dl.gr.bh(true);
}
gfs.dl.iv = function (hn) {
gfs.dl.gq.bh(false);
    __doPostBack("zumiPage_UserTimer", "");
}
gfs.dl.iu = function (it, u, ch) {
    var fz = new gfs.hz();
    var br = 0;
    for (var bo = 0; bo < u.length; bo++) {
        if (u[bo] < 0) {
            var length = u[bo] * -1;
            fz.t(ch.substr(br, length));
            br = br + length;
}
        else {
            var ak = u[bo];
bo++;
            var length = u[bo];
            fz.t(it.substr(ak, length));
}
}
return fz.toString();
}
gfs.dl.ix = function () {
    return gfs.dl.gx != null;
}
gfs.dl.is = function () {
    if (gfs.dl.ix()) {
gfs.dl.gx.abort();
gfs.dl.gx.bf();
        gfs.dl.gx = null;
}
}
gfs.dl._doPostBack = function (ir, iq) {
    if (gfs.dl.ix()) {
        if (window.event) {
            window.event.returnValue = false;
}
return;
}
    var form = gfs.dl.hb;
    form.__EVENTTARGET.value = ir;
    form.__EVENTARGUMENT.value = iq;
    gfs.dl.ha = null;
    gfs.dl.gp = ir.split("$").join("_");
    var bn = gfs.dl.im();
    if (bn) {
form.submit();
    } else if (window.event) {
        window.event.returnValue = false;
}
}
gfs.dl.io = function () {
    var b = window.event.srcElement;
    if (b.disabled) {
return;
}
    if (gfs.dl.ix()) {
return;
}
    gfs.dl.gp = b.id;
    if (b.tagName == 'INPUT') {
        var type = b.type;
        if (type == 'submit') {
            gfs.dl.ha = b.name + '=' + encodeURIComponent(b.value);
}
        else if (type == 'image') {
            var x = window.event.offsetX;
            var y = window.event.offsetY;
            gfs.dl.ha = b.name + '.x=' + x + '&' + b.name + '.y=' + y;
}
}
    else if ((b.tagName == 'BUTTON') && (b.name.length != 0) && (b.type == 'submit')) {
        gfs.dl.ha = b.name + '=' + encodeURIComponent(b.value);
}
}
gfs.dl.im = function () {
    if (gfs.dl.ix()) {
        if (window.event) {
            window.event.returnValue = false;
}
return false;
}
    var by = true;
    if (gfs.dl.gz) {
        by = gfs.dl.gz();
}
    if (by == false) {
        if (window.event) {
            window.event.returnValue = false;
}
return false;
}
    var k = gfs.dl.gp;
    if (gfs.dl.gt.cp(k)) {
        gfs.hk.p(3, "Postback initiated by excluded control, standard postback will occur.", k);
return true;
}
    var form = gfs.dl.hb;
    if (form.action != form.il) {
return true;
}
    document.body.style.cursor = "wait";
    var dg = gfs.dl.gt.ce(k);
    if (dg) {
        try {
eval(dg);
}
        catch (e) { }
}
    var m = new gfs.hz();
m.t('zumiPage_XmlRequest=true&');
    var count = form.elements.length;
    for (var i = 0; i < count; i++) {
        var b = form.elements[i];
        var name = b.name;
        if ((name == null) || (name.length == 0)) {
continue;
}
        var tagName = b.tagName;
        if (tagName == 'INPUT') {
            var type = b.type;
            if ((type == 'text') ||
            (type == 'password') ||
            (type == 'hidden') ||
            (((type == 'checkbox') || (type == 'radio')) && b.checked)) {
m.t(name);
m.t('=');
m.t(encodeURIComponent(b.value));
m.t('&');
}
}
        else if (tagName == 'SELECT') {
            var ea = b.options.length;
            for (var j = 0; j < ea; j++) {
                var eq = b.options[j];
                if (eq.selected == true) {
m.t(name);
m.t('=');
m.t(encodeURIComponent(eq.value));
m.t('&');
}
}
}
        else if (tagName == 'TEXTAREA') {
m.t(name);
m.t('=');
m.t(encodeURIComponent(b.value));
m.t('&');
}
}
    if (gfs.dl.ha) {
m.t(gfs.dl.ha);
        gfs.dl.ha = null;
}
    var l = new gfs.hg();
l.ei(form.action);
    l.bg()['zumiPage'] = 'true';
    l.bg()['Cache-Control'] = 'no-cache';
l.be(90000);
l.bb.p(gfs.dl.jg);
l.cb.p(gfs.dl.jf);
l.du(m.toString());
    gfs.hk.bc(2, l.ct());
    gfs.hk.p(3, "Sending xmlhttp request: " + l.ct().length + " characters.", l.ct());
    gfs.dl.gx = l;
l.bp();
    if (window.event) {
        window.event.returnValue = false;
}
return false;
}
gfs.dl.jg = function (hs, hr) {
    var ad = hs.ds();
    var root = ad.fj();
    var form = gfs.dl.hb;
    var k = gfs.dl.gp;
    gfs.hk.bc(1, ad.ap());
    if (!root || root.childNodes.length === 0) {
        var status = ad.db();
        var fy = ad.ap();
gfs.dl.ip();
        if (status === 500)
        {
            gfs.hk.p(2, "Server exception.\r\nStatus code:", status);
            document.clear();
            document.write(fy);
            document.close();
        }
        else
        {
            if (status === 200)
            {
                alert("An error has occurred; please try again.");
                window.location.href = window.location.href;
            }
            else if (status === 425)//Status created specifically to handle html and js validation exception.
            {
                alert("HTML and Javascript are not allowed.");
                window.location.href = window.location.href;
            }
            else
            {
                gfs.hk.p(0, "zumiPage: Response contains invalid xml formatting.\r\nPlease try to remove any inline code blocks (e.g. <% ... %>), CDATA tags (e.g. ']]>') or use well formatted xhtml.\r\nStatus code:", status);
            }
        }
        return;
}
    var eo = root.getElementsByTagName("refresh").length > 0;
    if (eo) {
        gfs.hk.p(2, "Refresh requested", "");
        if (form.__EVENTTARGET.value == "")
            form.__EVENTTARGET.value = k;
form.submit();
gfs.dl.ip();
return;
}
    var bv = root.getElementsByTagName("redirect");
    if (bv.length > 0) {
        bv = dkq(bv[0]);
        gfs.hk.p(2, "Redirecting to url: ", bv);
gfs.dl.ip(true);
        window.location.href = bv;
return;
}
    var u = root.getElementsByTagName("patchkeys");
    if (u.length > 0) {
        if (!gfs.dl.go) {
            gfs.hk.p(1, "Last response not found, refreshing the page", "");
            if (form.__EVENTTARGET.value == "")
                form.__EVENTTARGET.value = k;
form.submit();
gfs.dl.ip();
return;
}
        else {
            gfs.hk.p(3, "Received diff response: " + ad.ap().length + " characters.", ad.ap());
            u = dkq(u[0]).split(',').parseInt();
            var ch = ad.ap().gg("<patchdata><![CDATA[", "]]></patchdata>").ew("]]&gt;", "]]>");
            var ah = gfs.dl.iu(gfs.dl.go, u, ch);
            var dq = "<zumipage><renderdata>" + ah + "</renderdata></zumipage>";
            if (gfs.dl.gm() == gfs.cm.InternetExplorer) {
root.loadXML(dq);
            } else {
                root = new DOMParser().parseFromString(dq, 'text/xml');
}
            gfs.hk.bc(1, dq);
            gfs.hk.p(3, "Decoded diff response: " + ah.length + " characters.", dq);
            gfs.dl.go = ah;
}
}
    else {
        gfs.hk.p(3, "Received partial response: " + ad.ap().length + " characters.", ad.ap());
        gfs.dl.go = ad.ap().gg("<renderdata>", "</renderdata>");
}
    var ah = root.getElementsByTagName("renderdata");
    if (ah.length > 0) {
gfs.dl.iz();
        var title = root.getElementsByTagName("title");
        if (title.length > 0) {
            document.title = dkq(title[0]).gh();
}
        else {
            document.title = "";
}
        gfs.hk.p(4, "Updating page title:", document.title);
        var bm = root.getElementsByTagName("style");
        if (bm.length > 0) {
            var bj = dkq(bm[bm.length - 1]);
            if (bj != gfs.dl.gn) {
                gfs.dl.gn = bj;
                gfs.hk.p(3, "Updating stylesheet:", bj);
gfs.dl.ik(bj);
}
}
        var af = root.getElementsByTagName("update");
        for (var i = 0; i < af.length; i++) {
            var aa = af[i].attributes.getNamedItem('id').nodeValue;
            var ag = dkq(af[i].firstChild);
            gfs.hk.p(3, "Updating element: " + aa, ag);
            gfs.dl.ij(aa, ag);
}
        var bl = root.getElementsByTagName("input");
        for (var i = 0; i < bl.length; i++) {
            if (bl[i].attributes.getNamedItem("type").nodeValue.toLowerCase().gh() == "hidden") {
                var name = bl[i].attributes.getNamedItem('name').nodeValue.gh();
                var value = bl[i].attributes.getNamedItem('value').nodeValue;
                if (form.elements[name]) {
                    gfs.hk.p(4, "Updating hidden field: " + name, value);
                    form.elements[name].value = value;
}
                else {
                    gfs.hk.p(3, "Adding new hidden field: " + name, value);
                    var cu = document.createElement("input");
                    cu.type = "hidden";
                    cu.value = value;
                    cu.name = name;
                    cu.id = name;
form.appendChild(cu);
}
}
}
        var formElements = root.getElementsByTagName("form");
        for (var i = 0; i < formElements.length; i++) {
            if (formElements[i].attributes.getNamedItem('id').nodeValue.gh() == form.id) {
                var onsubmit = formElements[i].attributes.getNamedItem('onsubmit');
                if (onsubmit) {
                    gfs.hk.p(3, "Updating form onsubmit action:", onsubmit.nodeValue);
                    gfs.dl.gz = Function.dw(onsubmit.nodeValue);
}
                else {
                    gfs.dl.gz = null;
}
break;
}
}
        var o = root.getElementsByTagName("script");
        if (o.length > 0) {
gfs.dl.ge(o);
}
gfs.dl.ip();
}
    else {
        gfs.hk.p(0, "zumiPage: Render data not found in xml. Patch data might be corrupted.", "");
gfs.dl.ip();
}
}
gfs.dl.ip = function (jh) {
    gfs.hk.p(2, "Completed.", "");
gfs.dl.jb();
    if (!jh) {
        document.body.style.cursor = "";
        var k = gfs.dl.gp;
        var eh = gfs.dl.gt.cq(k);
        if (eh) {
            try {
eval(eh);
}
            catch (e) { }
}
}
    var form = gfs.dl.hb;
    if (form.__EVENTTARGET) {
        form.__EVENTTARGET.value = "";
        form.__EVENTARGUMENT.value = "";
}
gfs.dl.gx.bf();
    gfs.dl.gx = null;
    gfs.dl.ha = null;
    gfs.dl.gp = null;
}
gfs.dl.jf = function (hs, hr) {
    gfs.hk.p(1, "Request timed-out!", "");
gfs.dl.ip();
}
gfs.dl.jd = function (form) {
    gfs.dl.hb = form;
    form.il = form.action;
    gfs.dl.gz = form.onsubmit;
    form.onsubmit = null;
    form.addEventListener('onsubmit', gfs.dl.im, false);
    form.addEventListener('onclick', gfs.dl.io, false);
    window.addEventListener('onload', gfs.dl.ja, false);
    gfs.dl.gy = window.__doPostBack;
    if (gfs.dl.gy) {
        window.__doPostBack = gfs.dl._doPostBack;
}
}
gfs.dl.ij = function (aa, bs) {
    var ae = document.getElementById(aa + '_Start');
    if (ae) {
        var parentNode = ae.parentNode;
        var cg = document.getElementById(aa + '_End');
        while (ae.nextSibling != cg) {
parentNode.removeChild(ae.nextSibling);
}
        ae.insertAdjacentHTML('afterEnd', bs);
}
    else {
        var ar = document.getElementById(aa);
        if (ar) {
            if (bs == "") {
                bs = '<span id="' + aa + '"><\/span>';
}
            ar.insertAdjacentHTML('afterEnd', bs);
ar.parentNode.removeChild(ar);
}
        else {
            gfs.hk.p(0, "zumiPage: The ReturnControls collection contains an element that is not existing on the target document:", aa + "\r\n\r\nPlease try to put the control inside a panel control, and return the panel instead of the control itself.");
}
}
}
gfs.dl.ge = function (o) {
    if (gfs.dl.gw.length == 0) {
        var bu = document.getElementsByTagName('SCRIPT');
        for (var i = bu.length - 1; i >= 0; i--) {
            var bk = bu[i];
            if (bk.attributes.getNamedItem) {
                var aq = bk.attributes.getNamedItem('src');
                var src = (aq) ? aq.nodeValue : '';
                if (src.length) {
                    if (src.indexOf('/WebResource.axd?') >= 0) {
                        var dy = src.indexOf('&t=');
                        src = src.substring(0, dy);
}
                    if (!gfs.dl.gw.ig(src)) {
gfs.dl.gw.p(src);
}
}
}
bk.parentNode.removeChild(bk);
}
}
    var ai = "";
    for (var i = 0; i < o.length; i++) {
        var d = o[i];
        if (d.attributes.getNamedItem("type") == null || d.attributes.getNamedItem("type").nodeValue.indexOf("xml") == -1) {
            var aq = d.attributes.getNamedItem('src');
            var src = (aq) ? aq.nodeValue : '';
            if (src.length) {
                if (src.indexOf('/WebResource.axd?') >= 0) {
                    var dy = src.indexOf('&t=');
                    src = src.substring(0, dy);
}
                if (gfs.dl.gw.ig(src)) {
                    gfs.hk.p(2, "Existing script found, not loading again.", src);
}
                else {
gfs.dl.gw.p(src);
                    gfs.hk.p(2, "Loading src script using xmlhttp:", src);
                    var l = new gfs.hg();
l.ei(src);
                    var ad = l.bp();
                    var text = ad.ap();
                    var status = ad.db();
                    gfs.hk.p(2, "Script response received. Status: " + status, text);
                    if (status < 400) {
gfs.dl._loadScript(text);
}
}
}
            else {
                var text = "";
                if (d.childNodes.length != 0) {
                    for (var c = d.childNodes.length - 1; c >= 0; c--) {
                        text += d.childNodes[c].nodeValue;
}
}
                else {
                    text = d.nodeValue;
}
                if (text != "") {
                    if (text.indexOf('function __doPostBack(') >= 0) {
continue;
}
                    ai += text.ew("\n", "\r\n") + "\r\n";
}
}
}
}
    if (ai.text != "") {
        gfs.hk.p(2, "Loading text script:", ai);
gfs.dl._loadScript(ai);
}
}
gfs.dl._loadScript = function (ai) {
    var e = document.createElement('SCRIPT');
    e.type = 'text/javascript';
    var bw = document.getElementsByTagName('HEAD')[0];
bw.appendChild(e);
    e.text = ai;
}
gfs.dl.ik = function (cssText) {
    if (gfs.dl.gm() == gfs.cm.InternetExplorer) {
        var ey = document.styleSheets;
        var bd = ey[ey.length - 1];
        bd.cssText = cssText;
    }
    else {
        var ey = document.getElementsByTagName('STYLE');
        var bd = ey[ey.length - 1];

        // US-1887 In IE 10 bd.childNodes[0] is undefined in some cases as the child node does not exist. This guard 
        // is put in place to get around the issue but the problem may be rooted deeper
        if (bd.childNodes[0]) {
            bd.removeChild(bd.childNodes[0]);
        }

        bd.appendChild(document.createTextNode(cssText));
    }
}
fmq(window);
if (gfs.dl.gm() == gfs.cm.Firefox) {
dxq(window);
}
function __initZumiPage(je)
{
    gfs.dl._init(je);
}
var zumiPage_WaitClientScriptControl;
var zumiPage_WaitClientScriptStart;
var zumiPage_WaitClientScriptEnd;
var zumiPage_ExcludeControls;
