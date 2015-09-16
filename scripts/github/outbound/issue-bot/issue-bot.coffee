#

module.exports = (robot) ->
	github = require('githubot')(robot)
	pad = require('pad')
	limit = 20
	our_repo = 'rocketchat/Rocket.Chat'
	# console.log 'You must call me by my name - ' + robot.name
	# console.log 'If you are curious, I am listening to  ' +  robot.listeners.length + ' source'

	disp_issues = (issues, pullreq) ->
		output = '```\n'
		count = 0
		for g in issues

			if g.pull_request?
				if pullreq == true
					output = output + pad( '' + g.number, 8)  + pad(g.user.login, 20) + '  '  + g.title + '\n'
					count++
					if (count >= limit)
						output = output + 'MORE ...\n'
						break
			else
				if pullreq
					continue
				output = output + pad( '' + g.number, 8)  + pad(g.user.login, 20) + '  '  + g.title + '\n'
				count++
				if count >= limit
					output = output + 'MORE ...\n'
					break
		output = output + '```'
		return output

	disp_issue = (issue) ->
		issueText = "Issue"

		if issue.pull_request?
			issueText = "Pull Request"

		output = """
		#{issueText}: \##{issue.number}
		Opened by: #{issue.user.login}
		Title: #{issue.title}
		Status: #{issue.state}
		Url: #{issue.html_url}
		Body:
			#{issue.body}
		"""
		return output

	robot.respond /issues for (.*)/i, (res) ->
		url = "https://api.github.com/repos/" + res.match[1] + "/issues?state=open"

		github.get url, (issues) ->
			res.send disp_issues(issues, false)


	robot.respond /our issues/i, (res) ->
		url = "https://api.github.com/repos/" + our_repo + "/issues?state=open"

		github.get url, (issues) ->
			res.send disp_issues(issues, false)


	robot.respond /prs for (.*)/i, (res) ->
		url = "https://api.github.com/repos/" + res.match[1] + "/issues?state=open"

		github.get url, (issues) ->
			res.send disp_issues(issues, true)

	robot.respond /our prs/i, (res) ->
		url = "https://api.github.com/repos/" +  our_repo + "/issues?state=open"

		github.get url, (issues) ->
			res.send disp_issues(issues, true)

	robot.respond /(pr|issue) (.*) for (.*)/i, (res) ->
		url = "https://api.github.com/repos/" + res.match[3] + '/issues/' + res.match[2]

		github.get url, (issue) ->
			res.send disp_issue(issue)

	robot.respond /our (pr|issue) (.*)/i, (res) ->
		url = "https://api.github.com/repos/" + our_repo + "/issues/" + res.match[2]

		github.get url, (issue) ->
			res.send disp_issue(issue)
