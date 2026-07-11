class_name FileUtils

static func iter_files(fdir:String, fn:Callable):
	for dir in DirAccess.get_directories_at(fdir):
		iter_files(fdir.path_join(dir), fn)
	for file in DirAccess.get_files_at(fdir):
		fn.call(fdir, file)
