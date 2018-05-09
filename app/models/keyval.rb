class KeyVal
  defined? MotionModel
  include MotionModel::Model
  include MotionModel::FMDBModelAdapter
  include MotionModel::Validatable
  columns :key => :string,
          :val => :string
end
