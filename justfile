# List all just commands
default:
	@just --list

# git (add, commit and push)
git:
	git add .
	git commit -m "auto"
	git push