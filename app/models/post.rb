class Post < ApplicationRecord
    has_one_attached :image
    before_validation :set_nameless_name
    validates :name, presence: true, length: { maximum: 100 }
    validates :user_id, {presence: true}
    validate :validate_name_not_including_comma
    scope :recent, -> { order(created_at: :desc) }
    # Ex:- scope :active, -> {where(:active => true)}

    def user
        return User.find_by(id: self.user_id)
    end

    def self.csv_attributes
        ["name", "description", "created_at"]
    end
    
    def self.generate_csv
        CSV.generate(headers: true) do |csv|
            csv << csv_attributes
            all.each do |post|
                csv << csv_attributes.map{|attr| post.send(attr)}
            end
        end
    end
    
    def self.ransackable_attributes(auth_object = nil)
        %w[name created_at]
    end

    def self.ransackable_associations(auth_object = nil)
        []
    end

    private

    def validate_name_not_including_comma
        errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
    end
    
    def set_nameless_name
        self.name = '名前なし' if name.blank?
    end

end
