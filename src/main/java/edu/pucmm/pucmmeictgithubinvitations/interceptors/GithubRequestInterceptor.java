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

package edu.pucmm.pucmmeictgithubinvitations.interceptors;

import feign.RequestInterceptor;
import feign.RequestTemplate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class GithubRequestInterceptor implements RequestInterceptor {
    @Value("${GITHUB_TOKEN}")
    private String githubToken;

    @Override
    public void apply(RequestTemplate requestTemplate) {
        requestTemplate.header("Accept", "application/vnd.github+json");
        requestTemplate.header("X-GitHub-Api-Version", "2022-11-28");
        requestTemplate.header("Authorization", String.format("Bearer %s", githubToken));
    }
}
