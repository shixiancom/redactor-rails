class RedactorRails::PicturesController < ApplicationController
  before_filter :redactor_authenticate_user!

  def index
    @pictures = RedactorRails.picture_model.where(
        RedactorRails.picture_model.new.respond_to?(RedactorRails.devise_user) ? { RedactorRails.devise_user_key => redactor_current_user.id } : { })
    render :json => @pictures.to_json
  end

  def create
    @picture = RedactorRails.picture_model.new

    p "-------------"

    file = params[:file]
    @picture.data = RedactorRails::Http.normalize_param(file, request)
    if @picture.has_attribute?(:"#{RedactorRails.devise_user_key}")
      p 'uuuuuuuu'
      @picture.send("#{RedactorRails.devise_user}=", redactor_current_user)
      @picture.assetable = redactor_current_user
    end

    if @picture.save
      p "ssssssssss"
      render :text => { :file_path => @picture.url }.to_json
    else
      p "eeeeeeeeeee"
      render json: { error: @picture.errors }
    end
  end

  private

  def redactor_authenticate_user!
    if RedactorRails.picture_model.new.has_attribute?(RedactorRails.devise_user)
      super
    end
  end
end
