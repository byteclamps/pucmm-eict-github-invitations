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

import edu.pucmm.pucmmeictgithubinvitations.model.CustomRequest;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.concurrent.ConcurrentHashMap;

@Service
@Slf4j
public class RequestRateService {
    @Value("${pucmm.rate-limit}")
    private Integer rateLimit;

    @Value("${pucmm.cache-in-seconds}")
    private Integer cacheInSeconds;

    private final ConcurrentHashMap<String, CustomRequest> concurrentHashMap;

    public RequestRateService() {
        this.concurrentHashMap = new ConcurrentHashMap<>();
    }

    public void execute(HttpServletRequest request, Runnable runnable) throws IllegalAccessException {
        this.concurrentHashMap.putIfAbsent(request.getRemoteAddr(), CustomRequest.builder()
                .ipAddress(request.getRemoteAddr())
                .createdAt(LocalDateTime.now())
                .counter(1)
                .build());

        var existingCustomRequest = this.concurrentHashMap.get(request.getRemoteAddr());

        if (existingCustomRequest.getCounter() > rateLimit) {
            throw new IllegalAccessException("You have exceeded the rate limit, please come back later.");
        }

        existingCustomRequest.incrementCounter();

        this.concurrentHashMap.put(request.getRemoteAddr(), existingCustomRequest);

        runnable.run();
    }

    @Scheduled(cron = "*/10 * * * * *")
    public void cleanConcurrentHashMap(){
        log.info("Attempting to clear concurrent hashmap...");

        var now = LocalDateTime.now();

        this.concurrentHashMap.forEach((key, value) -> {
            if (now.isAfter(value.getCreatedAt().plusSeconds(cacheInSeconds))) {
                this.concurrentHashMap.remove(key);
            }
        });
    }
}
