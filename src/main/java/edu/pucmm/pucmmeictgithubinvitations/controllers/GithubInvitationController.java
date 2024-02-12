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

package edu.pucmm.pucmmeictgithubinvitations.controllers;

import edu.pucmm.pucmmeictgithubinvitations.properties.PucmmProperties;
import edu.pucmm.pucmmeictgithubinvitations.service.GithubInvitationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping(path = "/github-invitations")
public class GithubInvitationController {
    private final GithubInvitationService githubInvitationService;
    private final PucmmProperties properties;

    @GetMapping(path = "/available-subjects")
    @ResponseStatus(HttpStatus.OK)
    public Map<String, String> getAvailableSubjects() {
        return properties.getAvailableSubjects();
    }

    @GetMapping(path = "/{email}/{subject}/{githubUser}")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public void requestInvitation(
            @PathVariable("email") final String email,
            @PathVariable("subject") final String subject,
            @PathVariable("githubUser") final String githubUser
    ) {
        log.debug("email: {}", email);
        log.debug("subject: {}", subject);
        log.debug("githubUser: {}", githubUser);

        githubInvitationService.processInvitation(email, subject, githubUser);
    }
}
