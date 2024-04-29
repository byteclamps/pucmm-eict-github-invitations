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

package edu.pucmm.pucmmeictgithubinvitations.repository;

import com.google.api.services.sheets.v4.Sheets;
import com.google.api.services.sheets.v4.model.BatchGetValuesResponse;
import com.google.api.services.sheets.v4.model.ValueRange;
import com.google.auth.http.HttpCredentialsAdapter;
import edu.pucmm.pucmmeictgithubinvitations.dto.RequestBodyDTO;
import edu.pucmm.pucmmeictgithubinvitations.model.Student;
import edu.pucmm.pucmmeictgithubinvitations.properties.PucmmProperties;
import edu.pucmm.pucmmeictgithubinvitations.service.GoogleCredentialsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.List;

@Repository
@Slf4j
@RequiredArgsConstructor
public class GoogleSpreadsheetRepository {
    private final PucmmProperties pucmmProperties;

    @Value("${google.application-name}")
    private String applicationName;

    public Student findStudentByEmail(RequestBodyDTO dto) throws GeneralSecurityException, IOException {
        var subject = pucmmProperties.getSubjects().get(dto.getSubject());
        var spreadsheetId = subject.getGoogleSpreadSheetId();
        var credentials = GoogleCredentialsService.getCredentials();
        var sheetsService = new Sheets.Builder(GoogleCredentialsService.getHttpTransport(), GoogleCredentialsService.getJsonFactory(), new HttpCredentialsAdapter(credentials))
                .setApplicationName(applicationName)
                .build();

        BatchGetValuesResponse readResult = sheetsService.spreadsheets().values()
                .batchGet(spreadsheetId)
                .setRanges(List.of(subject.getSpreadSheetRange()))
                .execute();

        List<List<Object>> result = readResult.getValueRanges()
                .stream()
                .map(ValueRange::getValues)
                .findFirst().orElse(Collections.emptyList());

        if (result.isEmpty()) {
            log.error("The list of students is empty, cannot proceed...");

            throw new RuntimeException("There has been an issue while trying to validate the process...");
        }

        var emailNotValidMessage = String.format("The email '%s' is not valid.", dto.getEmail());
        var student = result
                .stream()
                .filter(current -> {
                    var email = current.get(1).toString();

                    return email.equalsIgnoreCase(dto.getEmail());
                })
                .map(current -> Student.builder()
                        .fullName(current.get(0).toString())
                        .email(current.get(1).toString())
                        .spreadsheetId(spreadsheetId)
                        .githubUsername(dto.getGithubUser())
                        .subjectName(subject.getName())
                        .subjectId(dto.getSubject())
                        .build())
                .findFirst()
                .orElseGet(() -> pucmmProperties
                        .getEmails()
                        .stream()
                        .filter(current -> current.equalsIgnoreCase(dto.getEmail()))
                        .map(current -> Student.builder()
                                .fullName("Administrador")
                                .email(current)
                                .spreadsheetId(spreadsheetId)
                                .githubUsername(dto.getGithubUser())
                                .subjectName(subject.getName())
                                .subjectId(dto.getSubject())
                                .build())
                        .findFirst().orElseThrow(() -> new RuntimeException(emailNotValidMessage)));

        log.info("Student found: {}", student.toString());

        return student;
    }
}
