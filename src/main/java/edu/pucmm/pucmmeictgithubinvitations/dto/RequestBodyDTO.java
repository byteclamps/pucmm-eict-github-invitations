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

package edu.pucmm.pucmmeictgithubinvitations.dto;

import com.fasterxml.jackson.annotation.JsonCreator;
import edu.pucmm.pucmmeictgithubinvitations.validators.SupportedSubject;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.validator.constraints.Length;

@Data
@NoArgsConstructor
@ToString
public class RequestBodyDTO {
    @NotNull(message = "The email is required")
    @NotEmpty(message = "The email cannot be empty")
    @Length(max = 64, message = "The email cannot exceed 64 characters")
    @Email(message = "The email is not valid")
    private String email;
    @SupportedSubject
    @NotNull(message = "The subject is required")
    @NotEmpty(message = "The subject cannot be empty")
    @Length(max = 64, message = "The subject cannot exceed 64 characters")
    private String subject;
    @NotNull(message = "The github-user is required")
    @NotEmpty(message = "The github-user cannot be empty")
    @Length(max = 64, message = "The github-user cannot exceed 64 characters")
    private String githubUser;

    @JsonCreator
    public RequestBodyDTO(String email, String subject, String githubUser) {
        this.email = email.trim().toLowerCase();
        this.subject = subject.trim().toLowerCase();
        this.githubUser = githubUser.trim();
    }
}
