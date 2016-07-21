require_relative 'config/db'
require_relative 'models/project'
Project.where("(ts + interval '1 day') < now()").destroy_all