# The entry point for the application

app = angular.module "exampleApp", [
  "ngAnimate"
  "ngRoute"

  "blueimp.fileupload"
  "placeholders.txt"

  "angleGrinder.common"
  "angleGrinder.gridz"
  "angleGrinder.forms"
  "angleGrinder.alerts"
  "angleGrinder.spinner"

  "exampleApp.resources"
  "exampleApp.grids"
  "exampleApp.docs"
]

# Sample `pathWithContext` configuration block
app.config [
  "pathWithContextProvider", (pathWithContextProvider) ->
    contextPath = $("body").data("context-path")
    pathWithContextProvider.setContextPath(contextPath) if contextPath?
]

app.factory "httpErrorsInterceptor", [
  "$q", "$log", "alerts",
  ($q, $log, alerts) ->

    responseError: (response) ->
      errorMessage = response.data?.error || "Unexpected HTTP error"
      $log.debug "intercepting", errorMessage, response

      # skip validation errors
      alerts.error(errorMessage) if response.status isnt 422

      $q.reject(response)

]

app.config [
  "$httpProvider", ($httpProvider) ->
    # register http errors interceptor
    $httpProvider.interceptors.push("httpErrorsInterceptor")
]

app.config [
  "agDateFilterProvider", (provider) ->
    # set default date format
    provider.setDefaultFormat("longDate")
]
