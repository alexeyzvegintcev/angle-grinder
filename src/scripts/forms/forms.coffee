# Here be dragons. Decorate `daypickerDirective`.
angular.module("ui.bootstrap.datepicker").config [
  "$provide", ($provide) ->
    $provide.decorator "daypickerDirective", ["$delegate", ($delegate) ->
      directive = $delegate[0]

      oldCompile = directive.compile
      directive.compile = ->
        link = oldCompile.apply(this, arguments)

        (scope) ->
          link.apply(this, arguments)

          scope.$watch "rows", ->

            angular.forEach scope.rows, (row) ->
              if _.every(row, (dt) -> dt.secondary)
                _.map(row, (dt) -> dt.hide = true)

      return $delegate
    ]
]
#XXX should be reviewed and refactored
forms = angular.module("angleGrinder.forms", [
  "ui.bootstrap.collapse"
  "ui.bootstrap.accordion"
  "ui.bootstrap.alert"
  "ui.bootstrap.buttons"
  "ui.bootstrap.carousel"
  "ui.bootstrap.dateparser"
  "ui.bootstrap.position"
  "ui.bootstrap.dropdown"
  "ui.bootstrap.stackedMap"
  "ui.bootstrap.modal"
  "ui.bootstrap.pagination"
  "ui.bootstrap.progressbar"
  "ui.bootstrap.rating"
  "ui.bootstrap.tabs"
  "ui.bootstrap.tpls"
  "ui.bootstrap.tooltip"
  "xeditable"
  "angleGrinder.common"
  "angleGrinder.alerts"
  "formly"
  "formlyBootstrap"
])

forms.run [
  "$templateCache", ($templateCache) ->

    # Override html template for the angular-ui/bootstrap pagination
    # to make it backward compatible with bootstrap 3.x

    $templateCache.put "template/pagination/pagination.html",
      """
          <ul class="pagination">
            <li ng-class="{disabled: noPrevious(), previous: align}">
              <a href ng-click="selectPage(page - 1)">{{getText('previous')}}</a>
            </li>

            <li ng-repeat="page in pages" ng-class="{active: page.active, disabled: page.disabled}">
              <a ng-click="selectPage(page.number)">{{page.text}}</a>
            </li>

            <li ng-class="{disabled: noNext(), next: align}">
              <a href ng-click="selectPage(page + 1)">{{getText('next')}}</a>
            </li>
          </ul>
      """

    $templateCache.put 'tooltip/tooltip.tpl.html',
                       """
        <div class="tooltip in" ng-show="title">
          <div class="tooltip-arrow"></div>
          <div class="tooltip-inner" ng-bind="title"></div>
        </div>
      """
      $templateCache.put 'datepicker.html',
                       """
        <ag-datepicker date-type="date"
                           ng-model="model"

                           name="datepick"/>
                </ag-datepicker>
      """
]

forms.run [ "formlyConfig",
  (formlyConfig) ->
    attributes = [
      'date-disabled'
      'custom-class'
      'show-weeks'
      'starting-day'
      'init-date'
      'min-mode'
      'max-mode'
      'format-day'
      'format-month'
      'format-year'
      'format-day-header'
      'format-day-title'
      'format-month-title'
      'year-range'
      'shortcut-propagation'
      'datepicker-popup'
      'show-button-bar'
      'current-text'
      'clear-text'
      'close-text'
      'close-on-date-selection'
      'datepicker-append-to-body'
    ]
    bindings = [
      'datepicker-mode'
      'min-date'
      'max-date'
    ]
    ngModelAttrs = {}

    camelize = (string) ->
      string = string.replace(/[\-_\s]+(.)?/g, (match, chr) ->
        if chr then chr.toUpperCase() else ''
      )
      # Ensure 1st char is always lowercase
      string.replace /^([A-Z])/, (match, chr) ->
        if chr then chr.toLowerCase() else ''

    angular.forEach attributes, (attr) ->
      ngModelAttrs[camelize(attr)] = attribute: attr
      return
    angular.forEach bindings, (binding) ->
      ngModelAttrs[camelize(binding)] = bound: binding
      return
    console.log ngModelAttrs
    formlyConfig.setType
      name: 'datepicker'
      templateUrl: 'datepicker.html'
      wrapper: [
        'bootstrapLabel'
        'bootstrapHasError'
      ]
      defaultOptions:
        ngModelAttrs: ngModelAttrs
        templateOptions: datepickerOptions:
          format: 'MM.dd.yyyy'
          initDate: new Date
      controller: [
        '$scope'
        ($scope) ->
          $scope.datepicker = {}
          $scope.datepicker.opened = false

          $scope.datepicker.open = ($event) ->
            $scope.datepicker.opened = !$scope.datepicker.opened
            return

          return
      ]
    return
]
