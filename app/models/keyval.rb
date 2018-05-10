class KeyVal
  include MotionModel::Model
  include MotionModel::FMDBModelAdapter
  include MotionModel::Validatable
  columns :key => :string,
          :val => :string
end
