gridz = angular.module("angleGrinder.gridz")

gridz.directive "agGrid", [
  "$timeout", "$log", "$parse", "agGridDataLoader", "ActionPopupHandler", "pathWithContext", "camelize"
  ($timeout, $log, $parse, agGridDataLoader, ActionPopupHandler, pathWithContext, camelize) ->

    link = (scope, element, attrs, gridCtrl) ->
      # find grid placeholder
      gridEl = element.find("table.gridz")

      # publish agGrid controller to the parent scope
      alias = attrs.agGridName
      $parse(alias).assign(scope, gridCtrl) if alias
      $parse("$grid").assign(scope, gridCtrl) #Make the grid available to controllers as $scope.$grid

      # read grid options
      options = $parse(attrs.agGrid)(scope)
      throw new Error("undefined grid options") unless options

      # read colModel from the `ag-grid-col-model` attribute
      options.colModel = angular.fromJson(attrs.agGridColModel) if attrs.agGridColModel

      # kill the grid when the related scope is destroyed
      scope.$on "$destroy", ->
        $log.debug "[agGrid] destroying the grid", gridEl
        gridEl.jqGrid("GridDestroy")

      # Initializes a grid with the given options
      initializeGrid = ->
        $log.debug "[agGrid] initializing '#{alias}' with", options

        # assign the url
        if not options.url? and options.path?
          options.url = pathWithContext(options.path)

        # use `$http` service to load the grid data
        if options.datatype is undefined or options.datatype is null
          options.datatype = agGridDataLoader(options.url, gridCtrl)

        gridEl.on "jqGridAfterGridComplete", () ->
          # Add `min` class to remove pading to minimize row height
          if options.minRowHeight
            _.each gridEl[0].rows, (it) ->
              angular.element(it).addClass('min')

        # jqGrid sucks at this point it expects `pager` to be an id
        unless options.pager is false
          options.pager = element.find(".gridz-pager").attr("id") or "gridz-pager"

        if options.selectFirstRow is true
          _gridComplete = options.gridComplete

          onGridComplete = ->
            dataIds = gridEl.getDataIDs()
            if dataIds.length > 0
              gridEl.setSelection dataIds[0], true
            _gridComplete.apply this, arguments if _.isFunction(_gridComplete)

          options.gridComplete = onGridComplete;

        # initialize jqGrid on the given element
        gridEl.gridz(options)

        # initialize actionPopup handler
        ActionPopupHandler(gridEl, scope, attrs)
        angular.element(element.find("select").wrap('<span class="select-wrapper"></span>'))

      if element.is(":visible")
        # Element is visible, initialize the grid now
        initializeGrid()
      else
        $log.info "grid is not visible:", alias

        # Initialize the grid when the element will be visible
        timeoutPromise = null
        unregister = scope.$watch ->
          $timeout.cancel(timeoutPromise) #Cancel previous timeout

          #We have to do timeout because of this issue with uib-tab https://github.com/angular-ui/bootstrap/issues/3796
          #Otherwise when tab is clicked and digest cycle ($watch) runs, the element.is(":visible") is still false, and hence grid is never initialized.
          timeoutPromise = $timeout(()->
            return unless element.is(":visible")
            # initialize the grid on the visible element
            initializeGrid()

            # unregister the watcher to free resources
            unregister()

          , 100, false) #Here false means don't fire new digest cycle, otherwise $watch will be called infinitely.

          return false



    restrict: "A"

    require: "agGrid"
    controller: "AgGridCtrl"

    template: """
      <table class="gridz"></table>
      <div class="gridz-pager"></div>
    """

    compile: (element, attrs) ->
      # modify grid html element, generate grid id from the name or assign default value
      id = if attrs.agGridName? then camelize(attrs.agGridName) else "gridz"

      element.find("table.gridz").attr("id", id)
      element.find("div.gridz-pager").attr("id", "#{id}-pager")
      console.log element.find("div")

      # return linking function which will be called at a later time
      post: link
]
