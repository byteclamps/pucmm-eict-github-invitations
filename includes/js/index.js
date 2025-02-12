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

$(document).ready(() => {
    setTimeout(() => {
        try {
            $(".error-alert-message").remove();
        } catch (e) {}

        try {
            $(".success-alert-message").remove();
        } catch (e) {}
    }, 5000);

    $("#submit-button").on("click", (event) => {
        $(this).prop("disabled", true);
        $(this).text("Enviando solicitud...");
    });

    $("#subject").change(function () {
        let currentValue = this.value;

        if (currentValue !== "") {
            $(".download-guide-link").removeClass("hidden");
        } else {
            $(".download-guide-link").addClass("hidden");
        }

        if ((currentValue in guides) && guides[currentValue]['guide-link'].length === 0) {
            $(".download-guide-link").addClass("hidden");
        }
    });

    $(".download-guide-link").on("click", function() {
        let subjectCode = $("#subject").val();

        window.open(guides[subjectCode]['guide-link']);
    });

    $("#subject").trigger("change");
});
