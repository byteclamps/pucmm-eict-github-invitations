package edu.pucmm.pucmmeictgithubinvitations.configuration;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;

import java.util.TimeZone;

@Configuration
@Slf4j
public class GeneralConfiguration {
    @PostConstruct
    public void configureTimezone() {
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));

        log.info("Timezone configured!");
    }
}
