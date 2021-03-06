class ImagesController < ApplicationController
  # GET /images
  # GET /images.xml
  before_filter :check_regular_user  

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = Image.find(params[:id])    
  end


  def mark_sub
      i = Image.find(params[:id])
      a = Album.find(i.album_id)
      if i.mark > 0
      i.mark = i.mark - 1
      i.save
      end
      redirect_to album_url(a)
  end


  def mark_add
       i = Image.find(params[:id])
       a = Album.find(i.album_id)
       if i.mark <= 5
       i.mark = i.mark + 1
       i.save
       end
       redirect_to album_url(a)
  end  

  # GET /images/new
  # GET /images/new.xml
  def new
    @image = Image.new()   
  end

  # POST /images
  # POST /images.xml
  def create 
    @a = Album.find(params[:album_id])
   if !@a.access?(@current_user.id)
          render :text=>"Чужой альбом редактировать нельзя!", :layout => 'application'
   else
    i = @a.images.new(params[:image])       
    if i.save && i.errors.empty?      
      @a.histories.create(:event => "изображение #{i.img_file_name} добавлено в альбом")      
      @a.to_zip(@current_user.login)
      redirect_to album_path(@a), :notice => "Картинка добавлена"            
    else  
      errors = i.errors.to_s
      if errors[0...3] == "img"
        flash[:error]  = "Вы не выбрали файл!"
      else
        flash[:error] = errors
      end
      redirect_to album_path(@a)            
    end
  end
  

  end


  def destroy_images
	form = params[:form]
	images = form.keys
	values = form.values
        album = Album.find(Image.find(images[0].to_i).album_id)
     if !album.access?(@current_user.id)
          render :text=>"Чужой альбом редактировать нельзя!", :layout => 'application'
          return
     end
       for i in 0... images.size
         if values[i].to_i == 1
          img = Image.find(images[i].to_i)
          fname = img.img_file_name
          img.destroy
          album.histories.create(:event => "изображение #{fname} удалено из альбома")
         end
       end
     redirect_to album_path(album), :notice => "Картинки успешно удалены"
  end


  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy    
    i = Image.find(params[:id])
    a = Album.find(i.album_id)
   if !a.access?(@current_user.id)
          render :text=>"Чужой альбом редактировать нельзя!", :layout => 'application'
   else    
    a.histories.create(:event => "изображение #{i.img_file_name} удалено из альбома")
    i.destroy
    a.to_zip(@current_user.login)
    redirect_to album_url(a), :notice => "Картинка удалена"
   end
  end
  
  
end
