module Prid
  class Client
    def self.run
      repo_name = ARGV.first
      unless repo_name
        warn 'usage:   prid YOUR_REPOSITORY'
        warn 'example: prid willnet/prid'
        exit 1
      end

      unless ENV['GITHUB_ACCESS_TOKEN']
        warn 'environmental variable "GITHUB_ACCESS_TOKEN" is blank!'
        exit 1
      end
      branch = `git branch 2> /dev/null | grep '^\*' | cut -b 3-`
      branch.chomp!
      if branch.nil? || branch.empty?
        warn 'Are you on a git directory?'
        exit 1
      end

      client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
      prs = client.pull_requests(repo_name)
      matched_pr = prs.find do |pr|
        pr[:head][:ref] == branch
      end

      if matched_pr
        print matched_pr[:url].slice /\d+\z/
      end
    end
  end
end
