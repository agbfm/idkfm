output "github_repo_html_url" {
  value       = github_repository.repo.html_url
  description = "The URL for the GitHub repository"
}

output "github_repo_ssh_clone_url" {
  value       = github_repository.repo.ssh_clone_url
  description = "The SSH clone URL for the GitHub repository"
}
