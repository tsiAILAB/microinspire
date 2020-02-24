(function ($) {
    'use strict';

    var BootstrapTable = $.fn.bootstrapTable.Constructor,
        _calculateObjectValue = $.fn.bootstrapTable.utils.calculateObjectValue;
    $.fn.bootstrapTable.methods.push('getSelectedIndex', 'getSelectedRows', 'selectRow', 'getRowData', 'CustomSearch', 'getAllFields', 'Export', 'firstPage', 'lastPage');

    BootstrapTable.prototype.initServer = function (silent, query) {
        var that = this,
            data = {},
            params = {
                pageSize: this.options.pageSize,
                pageNumber: this.options.pageNumber,
                searchText: this.searchText,
                sortName: this.options.sortName,
                sortOrder: this.options.sortOrder
            };

        if (!this.options.url) {
            if (this.options.clientData) {
                setTimeout(function () {
                    that.load(that.options.clientData);
                }, 1);
            }
            return;
        }

        if (this.options.queryParamsType === 'limit') {
            params = {
                search: params.searchText,
                sort: params.sortName,
                order: params.sortOrder
            };
            if (this.options.pagination) {
                params.limit = this.options.pageSize;
                params.offset = this.options.pageSize * (this.options.pageNumber - 1);
            }
        }
        if (this.options.sidePagination === 'server')
            params.serverPagination = true;
        else
            params.serverPagination = false;
        params.searchBy = this.searchBy;
        params.wildcard = this.options.wildcardsearch;        
        params.loadBySP = this.options.loadBySP;
        params.parameters = this.options.parameters || [];

        if (this.options.dataLoader) {
            params.tempKeyName = this.options.dataLoader.tempKeyName || '';
            params.isSession = this.options.dataLoader.isSession || false;
            params.expression = this.options.dataLoader.expression || '';

            params.assemblyName = this.options.dataLoader.assemblyName || '';
            params.className = this.options.dataLoader.className || '';
            params.constructorParams = this.options.dataLoader.constructorParams || '';
            params.methodName = this.options.dataLoader.methodName || '';
            params.methodParams = this.options.dataLoader.methodParams || '';
        }
        data = _calculateObjectValue(this.options, this.options.queryParams, [params], data);

        $.extend(data, query || {});

        // false to stop request
        if (data === false) {
            return;
        }

        if (!silent) {
            this.$tableLoading.show();
        }

        $.ajax($.extend({}, _calculateObjectValue(null, this.options.ajaxOptions), {
            type: this.options.method,
            url: this.options.url,
            data: this.options.contentType === 'application/json' && this.options.method === 'post' ?
                JSON.stringify({ parameters: data }) : data,
            cache: this.options.cache,
            contentType: this.options.contentType,
            dataType: this.options.dataType,
            success: function (res) {
                //res = _calculateObjectValue(that.options, that.options.responseHandler, [res], res);

                //var serverData;

                //if (that.options.sidePagination === 'server') {
                //    that.options.totalRows = res.total;
                //    serverData = res.rows;
                //}
                //else
                //    serverData = res.rows;
                //that.load(serverData);
                //that.trigger('load-success', serverData);

                res = _calculateObjectValue(that.options, that.options.responseHandler, [res], res);

                that.load(res);
                that.trigger('load-success', res);
                if (!silent) that.$tableLoading.hide();
            },
            error: function (res) {
                that.trigger('load-error', res.status);
            },
            complete: function () {
                if (!silent) {
                    that.$tableLoading.hide();
                }
            },
            async: true
        }));
    };
    BootstrapTable.prototype.getAllFields = function () {
        return this.options.columns[0];
    };

    BootstrapTable.prototype.CustomSearch = function (event) {
        var searchby = $(event.currentTarget).data('searchby');
        //var text = $.trim($(event.currentTarget).val());
        var text = $(event.currentTarget).val();
        // trim search input
        if (this.options.trimOnSearch) {
            $(event.currentTarget).val(text);
        }

        if (text === this.searchText) {
            return;
        }

        this.searchText = text;
        this.searchBy = searchby;

        this.options.pageNumber = 1;
        this.initSearch();
        this.updatePagination();
        this.trigger('search', text);
    };
    BootstrapTable.prototype.Export = function (options) {
        var data = {},
            params = {
                searchBy: this.searchBy,
                search: this.searchText,
                sort: this.options.sortName,
                order: this.options.sortOrder,
                exportType: options.exportType,
                serverPagination: false
            };

        if (!options.exportUrl) {
            return;
        }
        if (this.options.dataLoader) {
            params.assemblyName = this.options.dataLoader.assemblyName || '';
            params.className = this.options.dataLoader.className || '';
            params.methodName = this.options.dataLoader.methodName || '';
            params.methodParams = this.options.dataLoader.methodParams || '';
        }
        params.columns = this.getAllFields();
        data = _calculateObjectValue(this.options, this.options.queryParams, [params], data);
        $.ajax({
            type: 'POST',
            url: options.exportUrl,
            data: JSON.stringify({ parameters: data }),
            cache: false,
            contentType: 'application/json',
            dataType: 'json',
            success: function (res) {
                if ($.isFunction(options.afterPrepare)) {
                    options.afterPrepare.apply(res);
                }
            },
            error: function () {
            },
            complete: function () {
            }
        });
    };

    BootstrapTable.prototype.getSelectedIndex = function () {
        var index = this.$body.find(".selectedRow").data('index');
        if (index == undefined) index = -1;
        return index;
    };

    BootstrapTable.prototype.selectRow = function (index) {
        if (index == undefined || index <= 0) {
            if (this.options.sidePagination == "server")
                index = 0;
            else
                index = (this.options.pageNumber - 1) * this.options.pageSize;
        }

        if (index >= this.options.totalRows) index = this.options.totalRows;
        var $tr = this.$body.find('> tr[data-index="' + index + '"]');
        $tr.addClass('selectedRow').siblings().removeClass('selectedRow');
        if ($tr.length) {
            var position = $tr.position();
            var top = parseInt(position.top);
            if (this.$tableBody[0].offsetHeight < top) {
                this.scrollTo(top);
            }
            else if (top <= 25) {
                this.scrollTo(0);
            }
        }
    };

    BootstrapTable.prototype.getRowData = function (index) {
        return this.data[index];
    };

    BootstrapTable.prototype.getSelectedRows = function () {
        var that = this;

        return $.grep(this.options.data, function (row) {
            return row[that.header.stateField];
        });
    };

    BootstrapTable.prototype.firstPage = function () {
        this.options.pageNumber = 1;
        this.updatePagination();
    };

    BootstrapTable.prototype.lastPage = function () {
        this.options.pageNumber = this.options.totalPages;
        this.updatePagination();
    };

})(jQuery);