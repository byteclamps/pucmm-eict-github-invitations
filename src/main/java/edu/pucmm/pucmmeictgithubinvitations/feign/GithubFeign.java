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

package edu.pucmm.pucmmeictgithubinvitations.feign;

import edu.pucmm.pucmmeictgithubinvitations.configuration.GithubFeignConfiguration;
import edu.pucmm.pucmmeictgithubinvitations.dto.GithubInvitationDTO;
import edu.pucmm.pucmmeictgithubinvitations.dto.GithubMemberDTO;
import lombok.NonNull;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@FeignClient(value = "github-feign", url = "https://api.github.com", configuration = GithubFeignConfiguration.class)
public interface GithubFeign {
    @RequestMapping(path = "/orgs/{org}/teams/{team}/memberships/{username}", method = RequestMethod.PUT)
    void addOrUpdateMemberInvitation(
            @PathVariable("org") String org,
            @PathVariable("team") @NonNull String team,
            @PathVariable("username") String username,
            @RequestBody GithubInvitationDTO dto
    );

    @RequestMapping(path = "/orgs/{org}/teams/{team}/memberships/{username}", method = RequestMethod.GET)
    GithubMemberDTO memberExists(
            @PathVariable("org") String org,
            @PathVariable("team") @NonNull String team,
            @PathVariable("username") String username
    );
}
