class JiraIssue
  def self.find keys
    begin
      find_single_request keys
    rescue Exception => e
      find_multiple_requests keys
    end
  end

  ## This method exists because getting all issues in one request returns
  # a HTTPError if one of the keys is not valid.
  # This allows us to skip involid keys and still display the valid ones.
  def self.find_multiple_requests keys
    keys.map { |key|
      begin
        Rails.cache.fetch(key, expires_in: 1200.seconds) do
          JIRAClient.new.Issue.jql("issueKey=#{key}").first
        end
      rescue
      end
    }.compact
  end

  def self.find_single_request keys
    return [] if keys.empty?
    jql = keys.map { |key| "issueKey=#{key}" }.join(" or ")
    JIRAClient.new.Issue.jql jql
  end
end
