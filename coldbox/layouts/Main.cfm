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
<cfoutput>
<!doctype html>
<html lang="en">
<head>
	<!--- Metatags --->
	<meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="ie=edge" http-equiv="X-UA-Compatible">
    <title>Pucmm EICT Github Invitations</title>
	<meta name="description" content="Github invitations software application">
    <meta name="author" content="Gustavo Henriquez">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>

	<!---Base URL --->
	<base href="#event.getHTMLBaseURL()#" />
</head>
<body class="bg-gray-100">
	#view()#
</body>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="/static/js/index.js"></script>
</html>
</cfoutput>
