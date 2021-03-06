require 'ghtorrent/ghtorrent'


# A version of the GHTorrent class that creates a transaction per processed
# item
class TransactedGhtorrent < GHTorrent::Mirror

  def ensure_repo(owner, repo, commits = false, project_members = false,
                  watchers = false, forks = false, labels = false)
    check_transaction do
      super(owner, repo, commits, project_members, watchers, forks, labels)
    end
  end

  def ensure_commit(repo, sha, user, comments = true)
    check_transaction do
      super(repo, sha, user, comments)
    end
  end

  def ensure_commit_comment(owner, repo, sha, comment_id)
    check_transaction do
      super(owner, repo, sha, comment_id)
    end
  end

  def ensure_fork(owner, repo, fork_id)
    check_transaction do
      super(owner, repo, fork_id)
    end
  end

  def ensure_pull_request(owner, repo, pullreq_id,
                          comments = true, commits = true, history = true,
                          state = nil, actor = nil, created_at = nil)
    check_transaction do
      super(owner, repo, pullreq_id, comments, commits, history, state, actor, created_at)
    end
  end

  def ensure_pullreq_comment(owner, repo, pullreq_id, comment_id)
    check_transaction do
      super(owner, repo, pullreq_id, comment_id)
    end
  end

  def ensure_issue(owner, repo, issue_id, events = true, comments = true, labels = true)
    check_transaction do
      super(owner, repo, issue_id, events, comments, labels)
    end
  end

  def ensure_issue_event(owner, repo, issue_id, event_id)
    check_transaction do
      super(owner, repo, issue_id, event_id)
    end
  end

  def ensure_issue_comment(owner, repo, issue_id, comment_id, pull_req_id = nil)
    check_transaction do
      super(owner, repo, issue_id, comment_id, pull_req_id)
    end
  end

  def ensure_issue_label(owner, repo, issue_id, name)
    check_transaction do
      super(owner, repo, issue_id, name)
    end
  end

  def ensure_project_member(owner, repo, new_member, date_added)
    check_transaction do
      super(owner, repo, new_member, date_added)
    end
  end

  def ensure_watcher(owner, repo, watcher, date_added = nil)
    check_transaction do
      super(owner, repo, watcher, date_added)
    end
  end

  def ensure_repo_label(owner, repo, name)
    check_transaction do
      super(owner, repo, name)
    end
  end

  def check_transaction(&block)
    if @db.in_transaction?
      yield block
    else
      transaction do
        yield block
      end
    end
  end
end
