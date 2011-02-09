GIT=git

nothing:
	@echo "What do you want to make today? Choices:"
	@echo "	update-master"
	@echo "	update-next"

update-master:
	$(GIT) checkout master
	$(GIT) merge next
	$(GIT) checkout next
	$(GIT) push

update-next:
	$(GIT) checkout next
	$(GIT) merge master
	$(GIT) checkout master
	$(GIT) push

