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
import edu.pucmm.pucmmeictgithubinvitations.feign.GithubFeign;
import edu.pucmm.pucmmeictgithubinvitations.properties.PucmmProperties;
import edu.pucmm.pucmmeictgithubinvitations.validators.SupportedSubject;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
@Validated
public class GithubInvitationService {
    private final PucmmProperties pucmmProperties;
    private final GithubFeign githubFeign;

    public void processInvitation(@Valid @SupportedSubject final String subject, final String githubUser) {
        var org = pucmmProperties.getGithubOrg();
        var foundTeam = pucmmProperties.getCurrentTeams().get(subject);
        var dto = GithubInvitationDTO.builder().role("member").build();

        log.debug("org: {}", org);
        log.debug("foundTeam: {}", foundTeam);
        log.debug("dto: {}", dto);

        if (Objects.nonNull(foundTeam) && Objects.nonNull(githubUser)) {
            try {
                githubFeign.addOrUpdateMemberInvitation(org, foundTeam, githubUser, dto);
            } catch (Exception e) {
                var message = "There has been an error while sending the request to github...";

                log.error(message, e);

                throw new RuntimeException(message);
            }
        } else {
            throw new RuntimeException("There has been an error while trying to send the invitation...");
        }
    }
}
