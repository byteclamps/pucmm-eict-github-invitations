package edu.pucmm.pucmmeictgithubinvitations.dto;

import edu.pucmm.pucmmeictgithubinvitations.validators.SupportedSubject;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class RequestBodyDTO {
    private String email;
    @SupportedSubject
    private String subject;
    private String githubUser;
}
