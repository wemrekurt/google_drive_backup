require 'google_drive'
require 'yaml'
@config = YAML::load_file(File.join(__dir__, 'config.yml'))

full_path = config['project_dir']
session = GoogleDrive::Session.from_config("config.json")

if @config['mode'] == 'daily'
  files_path = full_path + Date.today.prev_day.strftime('/%Y/%m/%d')
  list = Date.today.prev_day.strftime('%Y/%m/%d').split('/').reverse
elsif @config['mode'] == 'yearly'
  files_path = full_path + Date.today.strftime('/%Y')
  list = [Date.today.prev_day.strftime('%Y')]
elsif @config['mode'] == 'specific'
  files_path = full_path + '/' + @config['spec_folder']
  list = [@config['spec_folder']]
else
  files_path = full_path
  list = []
end


def create_folders(gd, path)
  sf = Dir.glob(path+'/*').select {|f| File.directory? f}
  subpath = nil
  sf.each do |folder|
    subpath = create_if_not_exists(gd, folder)
    create_folders(subpath, folder)
  end  
end

def create_if_not_exists(gd_path, path)
  folder = path.split('/').last
  gd = gd_path.subcollection_by_title(folder).nil? ? gd_path.create_subcollection(folder) : gd_path.subcollection_by_title(folder)
  files = Dir.glob(path+'/*').select {|f| !File.directory? f}
  files.each do |file|
    gd.file_by_title(file.split('/').last).nil? ? gd.upload_from_file(file) : gd.file_by_title(file.split('/').last)
  end
  return gd
end

def gd_date_path(root_path, list)
  folder = list.pop
  sub_p = root_path.subcollection_by_title(folder).nil? ? root_path.create_subcollection(folder) : root_path.subcollection_by_title(folder)
  if list.size > 0
    gd_date_path(sub_p, list)
  else
    sub_p
  end
end

def upload(session, list, files_path)
  if list.size > 0
    create_folders(gd_date_path(session.collection_by_title(@config['drive_root']), list), files_path)
  else
    create_folders(session.collection_by_title(@config['drive_root']), files_path)
  end
end


upload(session, list, files_path)
