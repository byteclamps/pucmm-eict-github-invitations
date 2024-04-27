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

package edu.pucmm.pucmmeictgithubinvitations.controllers;

import edu.pucmm.pucmmeictgithubinvitations.dto.RequestBodyDTO;
import edu.pucmm.pucmmeictgithubinvitations.properties.PucmmProperties;
import edu.pucmm.pucmmeictgithubinvitations.service.GithubInvitationService;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import java.util.stream.Collectors;

@Controller
@Slf4j
public class GenericController {
    private final PucmmProperties pucmmProperties;
    private final GithubInvitationService githubInvitationService;

    public GenericController(PucmmProperties pucmmProperties, GithubInvitationService githubInvitationService) {
        this.pucmmProperties = pucmmProperties;
        this.githubInvitationService = githubInvitationService;
    }

    @PostMapping(path = "/", consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE})
    @ResponseStatus(HttpStatus.ACCEPTED)
    public ModelAndView requestInvitation(RequestBodyDTO dto, Model model) {
        log.debug("dto: {}", dto.toString());

        model.addAttribute("subjects", pucmmProperties.getAvailableSubjects());

        try {
            githubInvitationService.processInvitation(dto);

            model.addAttribute("success", true);
            model.addAttribute("message", String.format("Invitation has been sent. Please check your email '%s'.", dto.getEmail().substring(0, 5) + "**********" + dto.getEmail().substring(dto.getEmail().length() - 5)));
        } catch (ConstraintViolationException e) {
            model.addAttribute("success", false);
            model.addAttribute("message", e.getConstraintViolations().stream().map(ConstraintViolation::getMessage).collect(Collectors.joining("<br>")));

            log.error(e.getMessage(), e);
        } catch (Exception e) {
            model.addAttribute("success", false);
            model.addAttribute("message", e.getMessage());

            log.error(e.getMessage(), e);
        }

        return new ModelAndView("index");
    }

    @RequestMapping(path = "/", method = RequestMethod.GET)
    public ModelAndView index(Model model) {
        model.addAttribute("subjects", pucmmProperties.getAvailableSubjects());

        return new ModelAndView("index");
    }
}
