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
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<img class="object-center object-top" width="500px" src="/images/github.png" alt="Github">
<form class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 m-10" method="post" action="/">
    <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2" for="subject">
            Materia
        </label>
        <select class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" name="subject" id="subject">
            <option value="">Seleccione una opcion</option>
            <#list subjects?keys as key>
                <option value="${key}">${subjects[key]}</option>
            </#list>
        </select>
    </div>
    <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2" for="username">
            Usuario (Github)
        </label>
        <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" id="githubUser" name="githubUser" placeholder="username"/>
    </div>
    <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
            Correo Electronico
        </label>
        <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" type="text" id="email" name="email" placeholder="email"/>
    </div>
    <#if success?? && !success>
        <div role="alert">
            <div class="bg-red-500 text-white font-bold rounded-t px-4 py-2">
                Error
            </div>
            <div class="border border-t-0 border-red-400 rounded-b bg-red-100 px-4 py-3 text-red-700">
                <p>${message}</p>
            </div>
        </div>
        <br>
    <#elseif success?? && success>
        <div role="alert">
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
        <button class="bg-blue-500 w-full hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                type="submit">
            Enviar
        </button>
    </div>
</form>
</body>
<script src="../static/js/index.js"></script>
</html>