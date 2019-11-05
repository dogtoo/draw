/**
 * ddra.Collection
 * collection 管理器
 */

;(function ($, undefined) {

    var toString = Object.prototype.toString,
        push = Array.prototype.push,
        slice = Array.prototype.slice;

    //$.Class = ddra.class function Class
    var Collection = $.Class(function () {
        this.length = 0;

    }).methods({

        size: function () {
            return this.length;
        },
        toArray: function () {
            return slice.call(this, 0);
        },
        /**
         * 派?所有子元素的simulate
         * 故需?定子元素的simulate
         */
        simulate: function () {
            this.dispatch('simulate');
        },
        dispatch: function (fnName) {
            for (var i = 0; i < this.length; i ++) {
                (fnName in this[i]) && this[i][fnName].call(this[i]);
            }
        },

        push: push,
        sort: [].sort,
        splice: [].splice

    });

    $.Collection = Collection;

})(ddra);