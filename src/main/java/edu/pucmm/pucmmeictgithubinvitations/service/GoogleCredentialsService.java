/*
 *    Copyright 2024 ghencon.com @ https://ghencon.com
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package edu.pucmm.pucmmeictgithubinvitations.service;

import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.sheets.v4.SheetsScopes;
import com.google.auth.oauth2.GoogleCredentials;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Paths;
import java.security.GeneralSecurityException;
import java.util.List;

@Service
@Slf4j
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class GoogleCredentialsService {
    public static GoogleCredentials getCredentials() throws IOException {
        var path = Paths.get(System.getenv("GOOGLE_SERVICE_ACCOUNT_JSON_FILE_LOCATION")).toUri().toURL();
        final List<String> SCOPES_ARRAY = List.of(SheetsScopes.SPREADSHEETS_READONLY);

        return GoogleCredentials
                .fromStream(path.openStream())
                .createScoped(SCOPES_ARRAY);
    }

    public static JsonFactory getJsonFactory() {
        return new GsonFactory();
    }

    public static HttpTransport getHttpTransport() throws GeneralSecurityException, IOException {
        return GoogleNetHttpTransport.newTrustedTransport();
    }
}
