class Data():
  def recollect_git_info_if_necessary(sf):
    def extract_names(array):
      for idx, item in enumerate(array):
        array[idx] = item.name

    if 'dir' in sf.characteristics and '.git' in sf.characteristics['dir']:
      from git import Repo
      import subprocess
      
      sf.special['git'] = {}
      
      # Command line recollection
      all_branches_cmd = 'cd ' + sf.root['dir'] + '; git branch -a'
      output = subprocess.check_output(all_branches_cmd, shell=True)
      all_branches = output.split('\n')
      all_branches = [branch.strip() for branch in all_branches if branch != '']
      all_branches = [branch.replace('* ', '') for branch in all_branches]

      contributors_cmd = 'cd ' + sf.root['dir'] + '; git shortlog HEAD -s -n'
      output = subprocess.check_output(contributors_cmd, shell=True)
      contributors = output.split('\n')
      contributors = [contributor.strip() for contributor in contributors if contributor != '']
      contributors = [contributor.split('\t') for contributor in contributors]
      contributors = [contributor[1] + ': ' + contributor[0] for contributor in contributors
        if len(contributor) == 2]

      sf.special['git']['all_branches'] = all_branches
      sf.special['git']['contributors'] = contributors
      
      # PyGit API recollection
      repo = Repo(sf.root['dir'])
      
      sf.special['git']['local_branches'] = repo.branches
      sf.special['git']['description'] = repo.description
      sf.special['git']['refs'] = list(repo.refs)
      sf.special['git']['remote'] = repo.remote().url
      sf.special['git']['tags'] = repo.tags
      sf.special['git']['commits_count'] = repo.head.commit.count()
      
      for key in ['local_branches', 'refs', 'tags']:
        extract_names(sf.special['git'][key])
