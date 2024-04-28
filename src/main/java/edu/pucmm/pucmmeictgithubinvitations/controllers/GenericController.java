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
import edu.pucmm.pucmmeictgithubinvitations.service.EmailService;
import edu.pucmm.pucmmeictgithubinvitations.service.GithubInvitationService;
import edu.pucmm.pucmmeictgithubinvitations.service.RequestRateService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import lombok.RequiredArgsConstructor;
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

import java.time.LocalDateTime;
import java.util.stream.Collectors;

@Controller
@Slf4j
@RequiredArgsConstructor
public class GenericController {
    private final PucmmProperties pucmmProperties;
    private final GithubInvitationService githubInvitationService;
    private final EmailService emailService;
    private final RequestRateService requestRateService;

    @PostMapping(path = "/", consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE})
    @ResponseStatus(HttpStatus.ACCEPTED)
    public ModelAndView requestInvitation(HttpServletRequest request, RequestBodyDTO dto, Model model) {
        log.debug("dto: {}", dto.toString());

        final StringBuilder stringBuilder = new StringBuilder();

        model.addAttribute("subjects", pucmmProperties.getSubjects());

        try {
            requestRateService.execute(request, () -> {
                var student = githubInvitationService.processInvitation(dto);

                model.addAttribute("success", true);

                stringBuilder.append(String.format("Invitation has been sent. Please check your email '%s'.", student.getEmail().substring(0, 5) + "**********" + student.getEmail().substring(student.getEmail().length() - 5)));

                emailService.sendEmailNotification(student);
            });
        } catch (ConstraintViolationException e) {
            model.addAttribute("success", false);

            stringBuilder.append(e.getConstraintViolations().stream().map(ConstraintViolation::getMessage).collect(Collectors.joining("<br>")));

            log.error(e.getMessage(), e);
        } catch (Exception e) {
            model.addAttribute("success", false);

            stringBuilder.append(e.getMessage());

            log.error(e.getMessage(), e);
        } finally {
            model.addAttribute("message", stringBuilder.toString());
            model.addAttribute("currentYear", String.valueOf(LocalDateTime.now().getYear()));
        }

        return new ModelAndView("ftl/index");
    }

    @RequestMapping(path = "/", method = RequestMethod.GET)
    public ModelAndView index(Model model) {
        model.addAttribute("subjects", pucmmProperties.getSubjects());
        model.addAttribute("currentYear", String.valueOf(LocalDateTime.now().getYear()));

        return new ModelAndView("ftl/index");
    }
}
