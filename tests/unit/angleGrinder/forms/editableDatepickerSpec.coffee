describe "module: angleGrinder.forms", ->

  describe "directive: editableDatepicker", ->

    beforeEach module "angleGrinder.forms"

    $scope = null
    element = null

    beforeEach inject ($rootScope, $compile) ->
      $scope = $rootScope.$new()
      $scope.user = birth: new Date()

      element = angular.element """
        <form editable-form name="testForm">
          <span editable-datepicker="user.birth">{{user.birth | date}}</span>
        </form>
      """
      $compile(element)($scope)
      $scope.$digest()

    describe "when the form is visible", ->

      beforeEach ->
        $scope.testForm.$show()
        $scope.$digest()

      editableScope = null
      beforeEach -> editableScope = element.find("[editable-datepicker]").scope()

      calendarButtonEl = null
      beforeEach -> calendarButtonEl = element.find("button i.fa-calendar")

      it "has a button for open the picker", ->
        expect(calendarButtonEl.length).to.eq 1

      it "initially has closed calendar", ->
        expect(editableScope.opened).to.be.false


    beforeEach inject ($rootScope, $compile) ->
      $scope = $rootScope.$new()
      $scope.user = birth: new Date()

      element = angular.element """
        <form editable-form name="testForm">
          <span editable-datepicker="user.birth" e-readonly="true">{{user.birth | date}}</span>
        </form>
      """
      $compile(element)($scope)
      $scope.$digest()

    describe "when the form is visible", ->

      beforeEach ->
        $scope.testForm.$show()
        $scope.$digest()

      editableScope = null
      beforeEach ->
        editableScope = element.find("[editable-datepicker]").scope()

      calendarButtonEl = null
      beforeEach -> calendarButtonEl = element.find("button")

      it "has a button for open the picker", ->
        expect(calendarButtonEl.length).to.eq 1

      it "initially has closed calendar", ->
        expect(editableScope.opened).to.be.false


