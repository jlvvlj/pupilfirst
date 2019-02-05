class Level < ApplicationRecord
  validates :number, uniqueness: { scope: :course }, presence: true
  validates :name, presence: true

  has_many :target_groups, dependent: :restrict_with_error
  has_many :startups, dependent: :restrict_with_error
  has_many :targets, through: :target_groups
  has_many :weekly_karma_points, dependent: :restrict_with_error
  belongs_to :course

  def display_name
    "#{course.short_name}##{number}: #{name}"
  end

  def self.zero
    Level.find_by(number: 0)
  end

  def self.maximum
    order(:number).last
  end

  def short_name
    'Level ' + number.to_s
  end

  def unlocked
    !unlock_on&.future?
  end
end
