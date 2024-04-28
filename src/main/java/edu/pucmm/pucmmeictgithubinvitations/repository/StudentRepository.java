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

import edu.pucmm.pucmmeictgithubinvitations.dto.RequestBodyDTO;
import edu.pucmm.pucmmeictgithubinvitations.model.Student;
import edu.pucmm.pucmmeictgithubinvitations.properties.PucmmProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Repository;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashSet;

@Repository
@Slf4j
@RequiredArgsConstructor
public class StudentRepository {
    private final PucmmProperties pucmmProperties;

    public Student findStudent(final RequestBodyDTO dto) throws IOException {
        var resource = String.format("%s/.subjects/%s/.valid-emails", System.getProperty("user.home"), dto.getSubject());
        var validEmails = new HashSet<>(FileUtils.readLines(new File(resource), Charset.defaultCharset()))
                .stream()
                .map(current -> Student.builder().email(current.split(",")[0]).fullName(current.split(",")[1]).build())
                .toList();

        var student = validEmails.stream().filter(s -> s.getEmail().equalsIgnoreCase(dto.getEmail())).findFirst().orElseThrow(() -> new RuntimeException(String.format("The email '%s' is not valid. Please refer to the reviser for more information.", dto.getEmail())));
        student.setSubjectId(dto.getSubject());
        student.setSubjectName(pucmmProperties.getSubjects().get(dto.getSubject()).getName());
        student.setGithubUsername(dto.getGithubUser());
        student.setSpreadsheetId(pucmmProperties.getSubjects().get(dto.getSubject()).getGoogleSpreadSheetId());

        return student;
    }
}
