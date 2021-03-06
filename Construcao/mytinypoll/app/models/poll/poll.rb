# Description:
# => Model for a generic Poll. This class ...
class Poll::Poll < ActiveRecord::Base
    belongs_to :user
    has_many :poll_invite_people, :class_name => "::Poll::InvitePerson"
    has_many :answers, :class_name => "::Poll::Answer"
    
    validates_presence_of :title
    validates_presence_of :privacy
    validates_presence_of :question
    validates_presence_of :deadline
    
    has_attached_file :poll_avatar, styles: { large: "600x600>", medium: "300x300>", thumb: "100x100>" }
    validates_attachment_content_type :poll_avatar, content_type: /\Aimage\/.*\Z/
    
    # Description:
    # => Method to create a new poll (Discursive and Objective) and handle
    # possible erros.
    def create_poll(is_discursive, poll_config, options)
        return_state = true
        
        if is_discursive
            self.attributes = poll_config
            self.save
        else
            #  Create the Objective Poll and Filter only the non-empty 
            # fields for options in place
            obj_poll = @@obj_poll.new(poll_config)
            options.reject!(&:empty?)
            
            #  Check if the object can be saved and the options input has at 
            # least two options
            if obj_poll.save and options.length >= 2
                # Create the options and save in the DB
                options.each  do |val|
                    # Create the options of the Objective Poll
                    obj_option = @@obj_option.new(:alternative => val)
                    obj_option.poll_polls = obj_poll
                    obj_option.save
                end
            else
                return_state = false
            end
        end
        
        return return_state, self.id
    end
    
    # Description:
    # => Method to search for poll and return the most likely result
    def self.search_poll(query, search_type, user)
        # Initialize an empty query_result array
        query_result = []
        
        # For User with manager role
        if user.has_role? :manager
            if !query.empty?
                query = query.split
                
                case search_type 
                    when "0"
                        query.each do |word|
                            tmp_result = self.where(
                                "LOWER(title) LIKE LOWER(?)", "%#{word}%"    
                            )
                            query_result << tmp_result.take(tmp_result.length)
                        end
                    when "1"
                        query.each do |word|
                            tmp_result = self.where(
                                "LOWER(question) LIKE LOWER(?)", "%#{word}%"
                            )
                            query_result << tmp_result.take(tmp_result.length)
                        end
                end
            else
                tmp_result = self.all
                query_result << tmp_result.take(tmp_result.length)
            end
            
        # Any user that hasn't a manager role    
        else
            if !query.empty?
                query = query.split
                
                case search_type 
                    when "0"
                        query.each do |word|
                            tmp_result = self.where(
                                "LOWER(title) LIKE LOWER(?) AND privacy=0", "%#{word}%"    
                            )
                            query_result << tmp_result.take(tmp_result.length)
                        end
                    when "1"
                        query.each do |word|
                            tmp_result = self.where(
                                "LOWER(question) LIKE LOWER(?) AND privacy=0", "%#{word}%"
                            )
                            query_result << tmp_result.take(tmp_result.length)
                        end
                end
            else
                # If empty, return all the polls
                tmp_result = self.where(:privacy => '0')
                query_result << tmp_result.take(tmp_result.length)
            end
        end
        
        #  Get uniq elements in the array, reject the nil values,
        # sort by the most recent created pol and return the result
        query_result.flatten!
        query_result.uniq!
        query_result.reject!{ |x| x.nil?}
        
        return query_result.sort_by{|x| x.created_at}.reverse!
    end
    
    private
        @@obj_poll = ::Poll::Objective::ObjectivePoll
        @@obj_option = ::Poll::Objective::ObjectiveOption
end
