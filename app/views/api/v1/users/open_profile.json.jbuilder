json.user @current_user.username
json.open_profile_of do
    json.user_id @profile.id
    json.username @profile.username
    json.user_image @profile.profile_image.attached? ? @profile.profile_image.blob.url : ''
    json.post_count @profile.posts.count
    json.profile_posts @profile.posts.each do |post|
      json.post_description post.description
      json.post_image post.post_image.attached? ? post.post_image.blob.url : ''
      json.post_likes post.likes.count
      json.post_comments_count post.comments.count
      json.post_comments post.comments.each do |comment|
        json.id comment.id
        json.description comment.description
        json.parent_id comment.parent_id
        json.comment_likes comment.likes.count
        json.child_comments_count comment.comments.count
        json.child_comments comment.comments.each do |child_comment|
          json.id child_comment.id
          json.description child_comment.description
          json.parent_id child_comment.parent_id
          json.child_comment_likes child_comment.likes.count
        end
      end
    end
  end
