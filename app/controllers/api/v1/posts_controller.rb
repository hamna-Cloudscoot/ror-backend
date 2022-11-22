class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_post, only: [:show, :update_posts, :destroy]

  def index
    @posts = @current_user.posts.by_recently_created(20)
    if @posts.present?

    else
      render json: { message: "No posts for this particular user" }, status: :not_found
    end
  end

  def show
    render json: { post: @current_user.posts.by_recently_created },
           # post_image: @post.post_image.attached? ? @post.post_image.blob.url : '' },
           status: :ok
  end

  def create
    @post = @current_user.posts.new(post_params)
    if @post.save
      render json: { user: @post, post_image: @post.post_image.attached? ? @post.post_image.blob.url : '', message: 'Post created successfully' }, status: :ok
    else
      render_error_messages(@post)
    end
  end

  def update_posts
    unless @post.update(post_params)
      render_error_messages(@post)
    else
      @post.update(post_params)
      render json: { post: @post,
                     post_image: @post.post_image.attached? ? @post.post_image.blob.url : '',
                     message: "Post Updated" },
             status: :ok
    end
  end

  def destroy
    @post.destroy
    render json: { message: "Post successfully destroyed" }, status: :ok
  end

  def explore
    @tags=ActsAsTaggableOn::Tag.all.pluck(:name).uniq
    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
      if @posts.present?
      else
        render json: { message: "No Post found against this tag " }, status: :not_found
      end
    else
      render json: { message: "Tag not found " }, status: :not_found
    end
  end

  def tags
    @tags=ActsAsTaggableOn::Tag.all.pluck(:name).uniq
    render json:{tags: @tags}, status: :ok if @tags.present?
  end

  def following_posts
    @following=@current_user.followers.where(is_following: true).pluck(:follower_user_id)
    @following=User.where(id: @following)
  end
  def recent_posts
    @recent_posts = Post.where(tournament_meme: false).by_recently_created(20)
  end

  def trending_posts
    debugger
  end


  private

  def find_post
    unless (@post = @current_user.posts.find_by(id: params[:post_id]))
      return render json: { message: 'Post Not found' }
    end
  end

  def post_params
    params.permit(:id, :description, :tag_list, :post_likes, :post_image, :user_id, :tournament_banner_id, :tournament_meme)
  end
end
