ActiveAdmin.register Venue do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name,
                :location,
                :user_id,
                :category,
                :description,
                :capacity,
                :activity,
                :price,
                :latitude,
                :longitude,
                :perks,
                :published,
                venue_spec_attributes: %i(spaces garage_spaces bathrooms total_area),
                photos: []
  #
  # or
  #
  # permit_params do
  #   permitted  [:name, :location, :user_id, :category, :description, :capacity, :activity, :price, :latitude, :longitude]
  #   permitted << :other if params[:action]  'create' && current_user.admin?
  #   permitted
  # end
  form title: 'Venue' do |f|
    f.inputs "Venue" do      
      f.input :name,
                required: true,
                autofocus: true,
                input_html: { autocomplete: "Name" }
      f.input :user   
      f.input :location,
              required: true,
              input_html: { autocomplete: "Location", id: 'location' }      
      f.input :category, collection: venue_category_for_select[1..-1],
              required: true         
      f.input :activity,
              collection: venue_activity_for_select[1..-1],
              required: true         
      f.input :capacity,
                required: true,
                input_html: { min: 0, oninput: "validity.valid||(value'');" }     
      f.input :price, as: :number,
                required: true,
                input_html: { placeholder: "CHF", min: 0, oninput: "validity.valid||(value'');" }     
      f.input :description,
                required: true   
      f.fields_for :venue_spec_attributes do |h|       
                  h.input :spaces, as: :number, required: true,
                    input_html: { min: 0, oninput: "validity.valid||(value'');" }                     
                  h.input :total_area, as: :number, required: true,
                    input_html: { min: 0, oninput: "validity.valid||(value'');" }                        
                  h.input :bathrooms, as: :number, required: true,
                    input_html: { min: 0, oninput: "validity.valid||(value'');" }                      
                  h.input :garage_spaces, as: :number, required: true,
                    input_html: { min: 0, oninput: "validity.valid||(value'');" }                 
      end
      f.input :perks, hint: "Example: Internet, Air Conditioning, Heating, Parking, Security, Kitchen, Catering, Handicap, Friendly"
      f.input :photos, as: :file, input_html: { multiple: true }
      f.input :published  

    end
    para "Press cancel to return to the list without saving."
    actions
  end
end
