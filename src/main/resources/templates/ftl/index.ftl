<!--
  ~ Copyright 2024 ghencon.com @ https://ghencon.com
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~           http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
  -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="ie=edge" http-equiv="X-UA-Compatible">
    <title>Pucmm EICT Github Invitations</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="flex-col flex items-center m-10">
    <div class="flex flex-row justify-center w-full">
        <div>
            <img class="object-center object-top" width="200px" src="/images/github.png" alt="Github Logo">
        </div>
        <div>
            <img class="object-center object-top" width="200px" src="/images/logo-pucmm.png" alt="Pucmm Logo">
        </div>
    </div>
    <h1 class="text-center mb-4 text-4xl font-extrabold leading-none tracking-tight text-gray-900 md:text-5xl lg:text-6xl dark:text-black">PUCMM EICT GITHUB INVITATIONS</h1>
    <p class="text-center mb-6 text-lg font-normal text-gray-500 lg:text-xl sm:px-16 xl:px-48 dark:text-gray-600">Application for self-inviting into github subject's team.</p>
    <form class="shadow-md rounded px-8 pt-6 pb-8 mb-4 m-10 w-1/2 bg-white" id="github-form" method="post" action="/">
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="subject">
                Subject
            </label>
            <select class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" name="subject" id="subject">
                <option value="">Select an option</option>
                <#list subjects?keys as key>
                    <option value="${key}">${subjects[key].getName()}</option>
                </#list>
            </select>
        </div>
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="username">
                Username (Github)
            </label>
            <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" id="githubUser" name="githubUser" placeholder="Your github valid username"/>
        </div>
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
                Email
            </label>
            <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" id="email" name="email" placeholder="Your institution email (*****@ce.pucmm.edu.do)"/>
        </div>
        <#if success?? && !success>
            <div role="alert" class="error-alert-message">
                <div class="bg-red-500 text-white font-bold rounded-t px-4 py-2">
                    Error
                </div>
                <div class="border border-t-0 border-red-400 rounded-b bg-red-100 px-4 py-3 text-red-700">
                    <p>${message}</p>
                </div>
            </div>
            <br>
        <#elseif success?? && success>
            <div role="alert" class="success-alert-message">
                <div class="bg-teal-500 text-white font-bold rounded-t px-4 py-2">
                    Message
                </div>
                <div class="border border-t-0 border-teal-400 rounded-b bg-teal-100 px-4 py-3 text-teal-700">
                    <p>${message}</p>
                </div>
            </div>
            <br>
        </#if>
        <div class="flex items-center justify-between">
            <button id="submit-button" class="bg-blue-500 w-full hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                    type="submit">
                Enviar
            </button>
        </div>
    </form>
    <hr class="my-6 border-gray-200 sm:mx-auto dark:border-gray-700 lg:my-8" />
    <span class="block text-sm text-gray-500 sm:text-center dark:text-gray-400">© ${currentYear} <a href="https://ghencon.com/" class="hover:underline">Ghencon™</a>. All Rights Reserved.</span>
</div>
</body>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/static/js/index.js"></script>
</html>
