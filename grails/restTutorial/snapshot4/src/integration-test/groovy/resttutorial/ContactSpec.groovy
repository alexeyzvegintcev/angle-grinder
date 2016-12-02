package resttutorial

import grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import grails.test.mixin.integration.Integration
import org.grails.web.json.JSONElement
import spock.lang.Shared
import spock.lang.Specification

@Integration
class ContactSpec extends Specification {

    def setup() {
    }

    def cleanup() {
    }

    @Shared
    RestBuilder rest = new RestBuilder()

    def getBaseUrl(){"http://localhost:${serverPort}/api"}

    void "check GET list request without params "() {
        when:
        RestResponse response = rest.get("${baseUrl}/contacts")

        then:
        response.status == 200
        response.json != null
        JSONElement json = response.json.rows
        //by default max value is 10 rows
        json.size() == 10
        json[0].firstName == "Marie"
        json[0].lastName == "Scott"
        json[0].email == "mscott0@ameblo.jp"
    }

    void "check GET list request with max parameter"() {
        when: "list endpoint with max param"
        RestResponse response = rest.get("${baseUrl}/contacts?max=20")

        then:
        response.status == 200
        response.json != null
        JSONElement json = response.json.rows
        json.size() == 20
        json[0].firstName == "Marie"
        json[0].lastName == "Scott"
        json[0].email == "mscott0@ameblo.jp"
    }

    void "check GET by id"() {
        when:
        RestResponse response = rest.get("${baseUrl}/contacts/1")

        then:
        response.status == 200
        response.json != null
        JSONElement json = response.json
        json.firstName == "Marie"
        json.lastName == "Scott"
        json.email == "mscott0@ameblo.jp"

    }

    void "check POST request"() {
        when:
        RestResponse response = rest.post("${baseUrl}/contacts"){
            json([
                    firstName: "Test contact",
                    "email":"foo@bar.com",
                    inactive: true
            ])
        }

        then:
        response.status == 201
        response.json != null
        JSONElement json = response.json
        json.firstName == "Test contact"
        json.lastName == null
        json.email == "foo@bar.com"
        json.inactive == null
    }

    void "check POST request with name field"() {
        when:
        RestResponse response = rest.post("${baseUrl}/contacts"){
            json([
                    name: "Joe Cool",
                    "email":"foo@bar.com"
            ])
        }

        then:
        response.status == 201
        response.json != null
        JSONElement json = response.json
        json.firstName == "Joe"
        json.lastName == "Cool"
    }


    void "check PUT request"() {
        when:
        RestResponse response = rest.put("${baseUrl}/contacts/101"){
            json([
                    firstName: "new Test contact",
                    "email":"newfoo@bar.com",
                    lastName: "Doe"
            ])
        }

        then:
        response.status == 200
        response.json != null
        JSONElement json = response.json
        json.id == 101
        json.firstName == "new Test contact"
        json.lastName == "Doe"
        json.email == "newfoo@bar.com"
    }

    void "check DELETE request"() {
        when:
        RestResponse response = rest.delete("${baseUrl}/contacts/1")

        then:
        response.status == 200
    }

    void "check inactivate endpoint"() {
        when:
        RestResponse response = rest.delete("${baseUrl}/contacts/2/active")

        then:
        response.status == 200
        response.json != null
        JSONElement json = response.json
        json.inactive == true
    }
}