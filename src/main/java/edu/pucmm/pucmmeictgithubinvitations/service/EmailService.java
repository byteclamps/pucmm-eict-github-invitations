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

package edu.pucmm.pucmmeictgithubinvitations.service;

import edu.pucmm.pucmmeictgithubinvitations.model.Student;
import io.pebbletemplates.pebble.PebbleEngine;
import io.pebbletemplates.pebble.template.PebbleTemplate;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {
    private final JavaMailSender javaMailSender;

    @Value("${pucmm.features.send-email-notification}")
    private Boolean pucmmSendEmailNotification;

    public void send(String to, String subject, String body) {
        log.info("Attempting to send email to: '{}'...", to);

        if (pucmmSendEmailNotification.equals(Boolean.FALSE)) {
            log.warn("Feature to send emails is not enabled, therefore email will not be sent...");

            return;
        }

        MimeMessage message = javaMailSender.createMimeMessage();

        try {
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(subject);
            message.setFrom(System.getenv("SMTP_FROM_EMAIL"));
            message.setRecipient(Message.RecipientType.CC, new InternetAddress(System.getenv("SMTP_CC_EMAIL")));
            message.setContent(body, "text/html; charset=utf-8");

            javaMailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }

    public void sendEmailNotification(final Student student) {
        PebbleEngine engine = new PebbleEngine.Builder().build();
        PebbleTemplate compiledTemplate = engine.getTemplate("templates/pebble/notification.peb.html");

        Writer writer = new StringWriter();
        Map<String, Object> context = new HashMap<>();
        context.put("subject", student.getSubjectName());
        context.put("githubUsername", student.getGithubUsername());
        context.put("email", student.getEmail());
        context.put("spreadsheetId", student.getSpreadsheetId());
        context.put("studentFullName", student.getFullName());

        try {
            compiledTemplate.evaluate(writer, context);

            send("gustavojoseh@gmail.com", "[PUCMM EICT GITHUB INVITATIONS] A new user has been added to one of the teams", writer.toString());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
