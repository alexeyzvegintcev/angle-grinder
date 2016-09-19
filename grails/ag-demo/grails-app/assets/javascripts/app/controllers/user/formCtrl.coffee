class FormCtrl

  @$inject = ["$scope", "$http", "pathWithContext", "formlyValidationMessages"]
  constructor: ($scope, $http, pathWithContext, formlyValidationMessages) ->
    formlyValidationMessages.addTemplateOptionValueMessage('notEmail', 'notEmail', 'The Email should contain @', '22', 'notEmail');
    
    $scope.fields.userFields=[
      {
        key: 'contact.firstName',
        type: 'input',
        templateOptions: {
          label: 'Name'
        }
      },{
        key: 'contact.lastName',
        type: 'input',
        templateOptions: {
          label: 'Last Name'
        }
      },{
        key: 'contact.email',
        type: 'input',
        templateOptions: {
          label: 'Email'
        },
        validators: {
          notEmail: "$viewValue.indexOf('@') > 0"
        }
      },{
        key: 'contact.type',
        type: 'select',
        templateOptions: {
          label: 'Type',
          options: [
            {name: 'admin', value: 'ADMIN'},
            {name: 'customer', value: 'CUSTOMER'}
          ]
        }
      },{
        key: 'contact.org.id',
        type: 'select',
        templateOptions: {
          label: 'Org',
          options: [
            {name: '', value: '-- chose org --'} #TODO: check how we can apply ` <option ng-repeat="org in orgs" value="{{org.id}}">{{org.name}}</option>`
          ]
        }
      },{
        key: 'contact.tagForReminders',
        type: 'checkbox',
        templateOptions: {
          label: 'Tag For Reminders'
        }
      },{
        key: 'date1',
        type: 'datepicker',
        templateOptions: {
          label: 'Date 1',
          type: 'text',
          datepickerPopup: 'dd-MMMM-yyyy'
        }
      }

    ]
     # Do
    $http.get(pathWithContext("/org/listAll")).success (orgs) ->
      $scope.orgs = orgs

angular.module("angleGrinder")
  .controller("user.FormCtrl", FormCtrl)
