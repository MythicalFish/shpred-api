ActiveAdmin.register Video do

  permit_params :title, :description, :meta_description, :file, :preview, :thumb, :tag_list, :published, :private

  menu :priority => 1

  filter :title
  filter :description
  filter :tags
  filter :created_at

  form :partial => "form"

  controller do

    def find_resource
      Video.friendly.find(params[:id])
    end

    def create

      @video = Video.new(permitted_params[:video])
      @video.sid = SecureRandom.hex
      @video.title = @video.file_title
      @video.populate_meta

      respond_to do |format|
        if @video.save
          @video.encode
          format.html { redirect_to edit_admin_video_url(@video.id) }
          format.json { render json: {slug: @video.slug}, status: :created, location: @video }
        else
          format.html { render action: "new" }
          format.json { render json: @video.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  index do
    selectable_column
    column "Preview" do |video|
      if video.thumbnail
        link_to(image_tag(video.thumbnail), admin_video_path(video))
      end
    end
    column "Details" do |video|
      content_tag(:p, "Length: #{video.length}") +
      content_tag(:p, "Resolution: #{video.dimensions}") +
      "Views: #{video.views}"
    end
    column "Description" do |video|
      content_tag(:p, content_tag(:b, video.title)) +
      video.description
    end
    column :created_at
    column :published
    actions
  end

  show do
    attributes_table do
      row :title
      row "Link" do |video|
        link_to("Video URL", "http://shp.red/videos/#{video.slug}", target: '_blank')
      end
      row :meta_description
      row :created_at
      row :description
      row :tag_list
      row :thumbnail do |video|
        image_tag(video.thumbnail)
      end
      row :file do |video|
        content_tag(:video,{width:360}) do
          tag("source", {src: video.file.url, type: "video/mp4"})
        end
      end
    end
  end

end
