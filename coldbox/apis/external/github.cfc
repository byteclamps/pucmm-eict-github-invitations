component {
    property name="log"     inject="logbox:logger:apis.external.github";
    property name="http"    inject="components.http";
    property name="wirebox" inject="wirebox";

    property name="baseUrl" type="string";
    property name="headers" type="struct";

    function init() {
        variables.baseUrl = "https://api.github.com";
        variables.headers = {
            "Accept" = "application/vnd.github+json",
            "X-GitHub-Api-Version" = "2022-11-28"
        };
    }

    void function addOrUpdateMember(required string org, required string team, required string username) {
        local.settings = wirebox.getInstance( "coldbox" ).getConfigSettings();
        variables.headers["Authorization"] = "Bearer #settings.github.token#";

        local.response = http.request(
			method  = "put",
			baseUrl = variables.baseUrl,
			path    = "/orgs/#arguments.org#/teams/#arguments.team#/memberships/#arguments.username#",
			headers = variables.headers,
            body = {
                "role" = "member"
            }
		);
    }

    boolean function memberExists(required string org, required string team, required string username) {
        local.result = false;

        local.settings = wirebox.getInstance( "coldbox" ).getConfigSettings();
        variables.headers["Authorization"] = "Bearer #settings.github.token#";

        try {
            local.response = http.request(
                method  = "get",
                baseUrl = variables.baseUrl,
                path    = "/orgs/#arguments.org#/teams/#arguments.team#/memberships/#arguments.username#",
                headers = variables.headers
            );
            
            local.result = local.response['data']['state'] == "active";
        } catch (any ex) {
            if (ex.code eq 404) {
                local.result = false;

                log.warn("Member #username# does not exists in the github team of #team# (Org: #org#)...")

                return local.result;
            }

            log.error("There has been an error while parsing the result of verificating is the user exists within the github team...");
        }

        return local.result;
    }
}
