module PeopleHelper

		def button_select(model_name, target_property, button_source)
			html=''
			list = button_source.sort 
			if list.length <4
			  list.each {|x|
			   html << radio_button(model_name, target_property, x[1])
			   html << h(x[0])
			   html << '<br />'
			  }
			else
			   html << select(model_name, target_property, list)
			end

			return html
		end




	   
end
