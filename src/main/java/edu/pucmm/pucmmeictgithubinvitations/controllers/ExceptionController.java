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

import edu.pucmm.pucmmeictgithubinvitations.dto.ExceptionDTO;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.stream.Collectors;

@RestController
@ControllerAdvice
@Slf4j
@RequiredArgsConstructor
public class ExceptionController {
    private static final String README_ENDPOINT = "/github-invitation-manual.html";

    @ExceptionHandler(Exception.class)
    public ExceptionDTO handlingGenericException(Exception exception) {
        var baseUrl = ServletUriComponentsBuilder.fromCurrentContextPath().build();
        var finalUrl = baseUrl + README_ENDPOINT;
        var message = String.format("There has been some errors in the web-service. Please refer to the manual '%s' for more information.", finalUrl);

        log.debug("There has been some errors in the web-service...", exception);

        return ExceptionDTO.builder()
                .message(message)
                .build();
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ExceptionDTO handlingGenericException(ConstraintViolationException exception) {
        log.debug("There has been some validation errors in the web-service...", exception);

        return ExceptionDTO.builder()
                .message(exception.getConstraintViolations().stream().map(ConstraintViolation::getMessage).collect(Collectors.joining(", ")))
                .build();
    }
}
