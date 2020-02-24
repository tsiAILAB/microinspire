MicroInspireApp.factory("$finder", function ($utility, $appConst) {
    var finder = {};
    finder.ShowFinder = function () {
        this.options = {};
        if (arguments && arguments.length !== 0) {
            this.options = arguments[0];
        }
        new DataFinder(this.options).ShowDialog();
    };
    function DataFinder(config) {
        this.options = config;        
        if (this.options.url === "Dummy")
            this.options.url = undefined;
        else
            this.options.url = this.options.url || $appConst.BaseUrl + '/Grid/GetSearchGridData';
        this.options.title = this.options.title || "";
        this.options.width = this.options.width || 700;
        this.options.height = this.options.height || 360;
        this.options.dataLoader = this.options.dataLoader || {};
        this.options.columns = this.options.columns || [];
        this.options.sortName = this.options.sortName || this.options.columns[0].field;
        this.options.wildcardsearch = this.options.wildcardsearch === true ? true : false;
        this.options.loadBySP = this.options.loadBySP === true ? true : false;
        this.options.parameters = this.options.parameters || [];

        this.options.activeSearchField = this.options.activeSearchField || "";

        this.options.multiSelect = this.options.multiSelect || false;
        this.options.selectedIds = this.options.selectedIds || "";
        this.options.onSelect = this.options.onSelect || null;

        this.options.pageSize = this.options.pageSize || 50;
        if (this.options.remove === undefined)
            this.options.remove = true;

        if (this.options.multiSelect)
            this.options.columns.splice(0, 0, { field: 'state', checkbox: true });

        if (this.options.serverSide === false)
            this.options.serverSide = "client";
        else
            this.options.serverSide = "server";

        return this;
    }

    DataFinder.prototype.ShowDialog = function () {
        var self = this;
        //var svg = angular.element('<svg width="600" height="100" class="svg"></svg>');
        var $dialog = $('<div class="common-search-container"><div class="input-group input-group-sm"><div class="input-group-btn"><button data-toggle="dropdown" class="btn btn-default dropdown-toggle" style="color: black !important;border-color: #7f9db9 !important;" type="button"><span class="finder-search-concept"> </span> <span class="caret"></span></button><ul role="menu" class="dropdown-menu common-search-by"></ul></div><input type="text" placeholder="Search term......" class="form-control input-sm common-search-text"></div><table class="table table-responsive table-hover table-striped common-search-grid"></table></div>');
        //var $dialog = $('<div class="common-search-container"><div class="input-group input-group-sm"><div class="input-group-btn"><button data-toggle="dropdown" class="btn btn-default dropdown-toggle" style="color: #0B62B9 !important;" type="button"><span class="finder-search-concept"> </span> <span class="caret"></span></button><ul role="menu" class="dropdown-menu common-search-by"></ul></div><input type="text" placeholder="Search term......" class="form-control input-sm common-search-text"><div class="input-group-btn"><button type="button" class="btn btn-default dropdown-toggle" style="color: #0B62B9 !important;width: 160px;" data-toggle="dropdown"><span><i class="glyphicon glyphicon-export"></i> Export To</span> <span class="caret"></span></button><ul class="dropdown-menu export-menu" role="menu"><li><a href="#"><i class="glyphicon glyphicon-file"></i> PDF</a></li><li><a href="#"><i class="glyphicon glyphicon-file"></i> Excel</a></li><li><a href="#"><i class="glyphicon glyphicon-file"></i> Word</a></li><li><a href="#"><i class="glyphicon glyphicon-file"></i> CSV</a></li></ul></div></div><table class="table table-responsive table-hover table-striped common-search-grid"></table></div>');
        self.GenerateSearchGridScript($dialog);
        this.dia = $utility.ShowDialog({
            title: self.options.title,
            width: self.options.width,
            remove: true,
            content: $dialog[0],
            onOkClick: function () {
                self._onSelect(self);
            },
            onCancelClick: function () {
                if (self.options.focusControl) $(self.options.focusControl).focus();
            }
        });
    };

    DataFinder.prototype._onSelect = function (self) {
        if (self.options.onSelect) {
            var rowData = {};
            if (self.options.multiSelect) {
                rowData = self.$gridTable.bootstrapTable('getSelectedRows');
            } else {
                var rowId = self.$gridTable.bootstrapTable('getSelectedIndex');
                if (rowId !== -1) {
                    rowData = self.$gridTable.bootstrapTable('getRowData', rowId);
                }
            }
            self.options.onSelect(rowData);
            if (self.options.focusControl) $(self.options.focusControl).focus();
            self.dia.close();
        }
    };

    DataFinder.prototype.GenerateSearchGridScript = function ($dialog) {
        this.$gridTable = $dialog.find('.common-search-grid');
        this.$gridFilterBy = $dialog.find('.common-search-by');
        this.$gridSearchText = $dialog.find('.common-search-text');
        this.$gridSearchConcept = $dialog.find('.finder-search-concept');
        var self = this;
        this.$gridTable.bootstrapTable({
            method: 'post',
            url: self.options.url,
            clientData: self.options.clientData,
            cache: false,
            height: self.options.height,
            striped: true,
            pagination: true,
            pageSize: self.options.pageSize,
            pageList: [self.options.pageSize, 50, 100],
            sidePagination: self.options.serverSide,
            showPaginationDetail: false,
            showColumns: false,
            showRefresh: false,
            clickToSelect: self.options.multiSelect,
            singleSelect: !self.options.multiSelect,
            maintainSelected: true,
            sortName: self.options.sortName,
            wildcardsearch: self.options.wildcardsearch,            
            loadBySP: self.options.loadBySP,
            parameters: self.options.parameters,
            dataLoader: self.options.dataLoader,
            columns: self.options.columns,
            onClickRow: function (item, $element) {
                if (!self.options.multiSelect)
                    $element.addClass('selectedRow').siblings().removeClass('selectedRow');
                return false;
            },
            onDblClickRow: function (row) {
                if (!self.options.multiSelect && self.options.onSelect) {
                    self.options.onSelect(row);
                    if (self.options.focusControl) $(self.options.focusControl).focus();
                }
                self.dia.close();
            }
        });
        var firstField = this.options.activeSearchField || '';
        var firstCaption = firstField;
        var fields = this.$gridTable.bootstrapTable('getAllFields');
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].field !== 'state' && fields[i].visible) {
                var className = '';
                if (firstField === '') {
                    firstField = fields[i].field;
                    firstCaption = fields[i].title;
                    className = 'active';
                }
                else if (fields[i].field === firstField) {
                    firstCaption = fields[i].title;
                    className = 'active';
                }
                this.$gridFilterBy.append('<li class="' + className + '" data-searchby="' + fields[i].field + '"><a href="#"><i class="glyphicon glyphicon-th"></i> ' + fields[i].title + '</a></li>');
            }
        }
        self.$gridSearchConcept.html('<i class="glyphicon glyphicon-filter"></i> ' + firstCaption);
        this.$gridSearchText.data('searchby', firstField);
        this.$gridFilterBy.find('li').click(function (e) {
            e.preventDefault();
            self.$gridSearchText.data('searchby', $(this).data('searchby'));
            self.$gridSearchConcept.html('<i class="glyphicon glyphicon-filter"></i> ' + $(this).text());
            $(this).parent('ul').find('li').removeClass('active');
            $(this).addClass('active');
            if (self.$gridSearchText) self.$gridSearchText.focus();
        });
        var timeoutId;
        //$dialog.off('keyup').on('keyup', function (event) {
        //    event.preventDefault();
        //    switch (event.key) {
        //        case 'PageUp': //previous page 
        //            self.$gridTable.bootstrapTable('prevPage');
        //            return false;
        //        case 'PageDown': //next page   
        //            self.$gridTable.bootstrapTable('nextPage');
        //            return false;           
        //    }
        //});
        $dialog.off('keydown').on('keydown', function (event) {
            var index = 0;
            switch (event.keyCode) {
                case 36: //first page 
                    self.$gridTable.bootstrapTable('firstPage');
                    return false;
                case 35: //last page 
                    self.$gridTable.bootstrapTable('lastPage');
                    return false;
                case 33: //previous page 
                    self.$gridTable.bootstrapTable('prevPage');
                    return false;
                case 34: //next page   
                    self.$gridTable.bootstrapTable('nextPage');
                    return false;
                case 38: //previous row   
                    index = self.$gridTable.bootstrapTable('getSelectedIndex');
                    self.$gridTable.bootstrapTable('selectRow', index - 1);
                    return false;
                case 40: //next row   
                    index = self.$gridTable.bootstrapTable('getSelectedIndex');
                    self.$gridTable.bootstrapTable('selectRow', index + 1);
                    return false;
                case 13:
                    self._onSelect(self);
                    return false;
            }
        });
        //this.$gridSearchText.off('keyup').on('keyup', function (event) {
        //    clearTimeout(timeoutId);
        //    timeoutId = setTimeout(function () {
        //        self.$gridTable.bootstrapTable('CustomSearch', event);
        //    }, 500);
        //});
        this.$gridSearchText.off('keyup').on('keyup', function (event) {
            if (event.key === "Alt" || event.key === "Control" || event.key === "Shift"
                || event.key === "Home" || event.key === "End"
                || event.key === "PageUp" || event.key === "PageDown"
                || event.shiftKey || event.ctrlKey || event.altKey
                || event.keyCode === 37 || event.keyCode === 38
                || event.keyCode === 39 || event.keyCode === 40
                || event.keyCode === 36 || event.keyCode === 35) return false;
            clearTimeout(timeoutId);
            timeoutId = setTimeout(function () {
                self.$gridTable.bootstrapTable('CustomSearch', event);
            }, 500);
        });

        this.$gridSearchText.off('paste').on('paste', function (event) {
            clearTimeout(timeoutId);
            timeoutId = setTimeout(function () {
                self.$gridTable.bootstrapTable('CustomSearch', event);
            }, 500);
        });

        var sid = setInterval(function () {
            if (self.$gridSearchText) {
                self.$gridSearchText.focus();
                clearInterval(sid);
            }
        }, 500);
    };

    return finder;
});