<cfoutput>
    <div class="flex-col flex items-center m-10">
		<div class="flex flex-row justify-center w-full">
			<div>
				<img class="object-center object-top" width="200px" src="/includes/images/github.png" alt="Github Logo">
			</div>
			<div>
				<img class="object-center object-top" width="200px" src="/includes/images/logo-pucmm.png" alt="Pucmm Logo">
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
					<cfloop collection="#rc.pucmm.subjects#" item="key"  >
						<option value="#key#">#rc.pucmm.subjects[key]["name"]#</option>
                    </cfloop>
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
			<!--- <#if success?? && !success>
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
			</#if> --->
			<div class="flex items-center justify-between">
				<button id="submit-button" class="bg-blue-500 w-full hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
						type="submit">
					Enviar
				</button>
			</div>
		</form>
		<hr class="my-6 border-gray-200 sm:mx-auto dark:border-gray-700 lg:my-8" />
		<span class="block text-sm text-gray-500 sm:text-center dark:text-gray-400">© #now().year()# <a href="https://ghencon.com/" class="hover:underline">Ghencon™</a>. All Rights Reserved.</span>
	</div>
</cfoutput>
