/*
 * Copyright 2024 ghencon.com @ https://ghencon.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *           http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package edu.pucmm.pucmmeictgithubinvitations.service;

import edu.pucmm.pucmmeictgithubinvitations.dto.GithubInvitationDTO;
import edu.pucmm.pucmmeictgithubinvitations.dto.RequestBodyDTO;
import edu.pucmm.pucmmeictgithubinvitations.feign.GithubFeign;
import edu.pucmm.pucmmeictgithubinvitations.properties.PucmmProperties;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashSet;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
@Validated
public class GithubInvitationService {
    private final PucmmProperties pucmmProperties;
    private final GithubFeign githubFeign;

    public void processInvitation(final @Valid RequestBodyDTO dto) {
        var org = pucmmProperties.getGithubOrg();
        var foundTeam = pucmmProperties.getCurrentTeams().get(dto.getSubject());
        var githubDto = GithubInvitationDTO.builder().role("member").build();

        validateEmail(dto.getEmail(), dto.getSubject());

        log.debug("org: {}", org);
        log.debug("foundTeam: {}", foundTeam);
        log.debug("githubDto: {}", githubDto);
        log.debug("dto: {}", dto);

        if (Objects.nonNull(foundTeam) && Objects.nonNull(dto.getGithubUser())) {
            try {
                githubFeign.addOrUpdateMemberInvitation(org, foundTeam, dto.getGithubUser(), githubDto);
            } catch (Exception e) {
                var message = "There has been an error while sending the request to github...";

                log.error(message, e);

                throw new RuntimeException(message);
            }
        } else {
            throw new RuntimeException("There has been an error while trying to send the invitation...");
        }
    }

    private void validateEmail(final String email, final String subject) {
        try {
            var resource = String.format("%s/.subjects/%s/.valid-emails", System.getProperty("user.home"), subject);

            var validEmails = new HashSet<>(FileUtils.readLines(new File(resource), Charset.defaultCharset()));

            if (validEmails.stream().noneMatch(s -> s.equalsIgnoreCase(email))) {
                throw new RuntimeException(String.format("The email '%s' is not valid. Please refer to the reviser for more information.", email));
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
