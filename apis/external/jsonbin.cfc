component {
    property name="log"     inject="logbox:logger:apis.external.github";
    property name="http"    inject="components.http";
    property name="datetime"    inject="components.datetime";
    property name="wirebox" inject="wirebox";

    property name="baseUrl" type="string";
    property name="headers" type="struct";

    function init() {
        variables.baseUrl = "https://api.jsonbin.io";
        variables.headers = {};
    }

    struct function readBin(required string binId){
        local.settings = wirebox.getInstance( "coldbox" ).getConfigSettings();

        try {
            local.recordInfo = getFileInfo("/tmp/subjects.json");
            
            log.info("Reading subjects json file from disk...");

            local.record = deserializeJSON(fileRead("/tmp/subjects.json"));

            if (dateCompare(now(), dateAdd("n", 30, local.recordInfo.fileCreated)) eq 1) {
                fileDelete("/tmp/subjects.json");
            }
        } catch (any ex) {
            variables.headers["X-Access-Key"] = settings.jsonbin.accessKey;

            local.response = http.request(
                method  = "get",
                baseUrl = variables.baseUrl,
                path    = "/v3/b/#arguments.binId#",
                headers = variables.headers
            );

            local.record = local.response.data.record;
            
            log.warn("The file subjects does not exists, creating it...");
            
            fileWrite("/tmp/subjects.json", serializeJSON(record), "utf-8");
        }

        return record;
    }
}